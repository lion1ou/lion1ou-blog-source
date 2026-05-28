#!/usr/bin/env node

/**
 * Upload local Markdown images to Qiniu Kodo and rewrite references.
 *
 * Uses the official qiniu Node.js SDK FormUploader.putFile flow. It reads
 * .cursor/skills/.env, uploads local images, writes publish/cdn-map.json, and
 * outputs Markdown with CDN URLs.
 */

const fs = require("fs");
const path = require("path");
const qiniu = require("qiniu");

const IMAGE_RE = /!\[([^\]]*)\]\(([^)\s]+)(?:\s+(["'][^"']*["']))?\)/g;

function parseArgs(argv) {
  const args = {
    env: ".cursor/skills/.env",
    cdnMap: "",
    topicSlug: "",
    dryRun: false,
    force: false,
  };

  for (let i = 0; i < argv.length; i += 1) {
    const item = argv[i];
    if (item === "--dry-run") {
      args.dryRun = true;
    } else if (item === "--force") {
      args.force = true;
    } else if (item.startsWith("--")) {
      const key = item.slice(2).replace(/-([a-z])/g, (_, char) => char.toUpperCase());
      const value = argv[i + 1];
      if (!value || value.startsWith("--")) {
        throw new Error(`Missing value for ${item}`);
      }
      args[key] = value;
      i += 1;
    } else {
      throw new Error(`Unknown argument: ${item}`);
    }
  }

  for (const key of ["workspace", "markdown", "output"]) {
    if (!args[key]) throw new Error(`Missing required argument --${key}`);
  }

  return args;
}

function parseEnv(envPath) {
  if (!fs.existsSync(envPath)) return {};
  const values = {};
  const lines = fs.readFileSync(envPath, "utf8").split(/\r?\n/);
  for (const rawLine of lines) {
    const line = rawLine.trim();
    if (!line || line.startsWith("#") || !line.includes("=")) continue;
    const index = line.indexOf("=");
    const key = line.slice(0, index).trim();
    let value = line.slice(index + 1).trim();
    value = value.replace(/^['"]|['"]$/g, "");
    values[key] = value;
  }
  return values;
}

function loadConfig(envPath) {
  const env = parseEnv(envPath);
  const required = [
    "QINIU_KODO_ACCESS_KEY",
    "QINIU_KODO_SECRET_KEY",
    "QINIU_KODO_BUCKET",
    "QINIU_KODO_CDN_BASE_URL",
  ];
  const missing = required.filter((key) => !env[key]);
  if (missing.length > 0) {
    throw new Error(`Missing required Qiniu config in ${envPath}: ${missing.join(", ")}`);
  }

  return {
    accessKey: env.QINIU_KODO_ACCESS_KEY,
    secretKey: env.QINIU_KODO_SECRET_KEY,
    bucket: env.QINIU_KODO_BUCKET,
    cdnBaseUrl: env.QINIU_KODO_CDN_BASE_URL,
  };
}

function isRemoteTarget(target) {
  const lowered = target.toLowerCase();
  return (
    lowered.startsWith("http://") ||
    lowered.startsWith("https://") ||
    lowered.startsWith("data:") ||
    lowered.startsWith("#")
  );
}

function stripAngleBrackets(target) {
  if (target.startsWith("<") && target.endsWith(">")) return target.slice(1, -1);
  return target;
}

function resolveImagePath(markdownPath, workspace, target) {
  const clean = decodeURIComponent(stripAngleBrackets(target).split("#")[0]);
  if (path.isAbsolute(clean)) return path.resolve(clean);

  const fromMarkdown = path.resolve(path.dirname(markdownPath), clean);
  if (fs.existsSync(fromMarkdown)) return fromMarkdown;
  return path.resolve(workspace, clean);
}

function relativeToWorkspace(filePath, workspace) {
  const relative = path.relative(workspace, filePath);
  if (!relative.startsWith("..") && !path.isAbsolute(relative)) {
    return relative.split(path.sep).join("/");
  }
  return path.basename(filePath);
}

function findImages(markdown, markdownPath, workspace) {
  const refs = [];
  for (const match of markdown.matchAll(IMAGE_RE)) {
    const target = match[2].trim();
    if (isRemoteTarget(stripAngleBrackets(target))) continue;
    const localPath = resolveImagePath(markdownPath, workspace, target);
    refs.push({
      original: match[0],
      alt: match[1],
      target,
      title: match[3] || "",
      localPath,
      localRel: relativeToWorkspace(localPath, workspace),
    });
  }
  return refs;
}

function assetTypeFor(localRel) {
  const parts = localRel.toLowerCase().split("/");
  if (parts.includes("cover")) return "cover";
  if (parts.includes("inline")) return "inline";
  if (parts.includes("cards") || parts.includes("xhs")) return "cards";
  return "assets";
}

function buildKey(config, topicSlug, localRel) {
  const assetType = assetTypeFor(localRel);
  const filename = path.basename(localRel);
  return `articles/${topicSlug}/${assetType}/${filename}`;
}

function normalizeCdnBase(config) {
  let base = config.cdnBaseUrl.trim().replace(/\/+$/g, "");
  if (!base.includes("://")) {
    base = `https://${base}`;
  }
  return base;
}

function cdnUrl(config, key) {
  const encodedKey = key.split("/").map(encodeURIComponent).join("/");
  return `${normalizeCdnBase(config)}/${encodedKey}`;
}

function readExistingMap(cdnMapPath) {
  if (!fs.existsSync(cdnMapPath)) return {};
  const payload = JSON.parse(fs.readFileSync(cdnMapPath, "utf8"));
  const items = {};
  for (const item of payload.items || []) items[item.localPath] = item;
  return items;
}

function createQiniuConfig(config) {
  const sdkConfig = new qiniu.conf.Config({
    useHttpsDomain: true,
  });
  return sdkConfig;
}

function createUploadToken(config, key) {
  const mac = new qiniu.auth.digest.Mac(config.accessKey, config.secretKey);
  const putPolicy = new qiniu.rs.PutPolicy({
    scope: `${config.bucket}:${key}`,
  });
  return putPolicy.uploadToken(mac);
}

async function uploadFile(config, filePath, key) {
  const formUploader = new qiniu.form_up.FormUploader(createQiniuConfig(config));
  const putExtra = new qiniu.form_up.PutExtra();
  putExtra.fname = path.basename(filePath);
  const uploadToken = createUploadToken(config, key);

  const { data, resp } = await formUploader.putFile(uploadToken, key, filePath, putExtra);
  if (!resp || resp.statusCode < 200 || resp.statusCode >= 300) {
    throw new Error(`Qiniu upload failed ${resp ? resp.statusCode : "unknown"}: ${JSON.stringify(data)}`);
  }

  return {
    key: data && data.key ? data.key : key,
    hash: data && data.hash ? data.hash : "",
    response: data || {},
  };
}

function renderMarkdownImage(ref, url) {
  const title = ref.title ? ` ${ref.title}` : "";
  return `![${ref.alt}](${url}${title})`;
}

function uniqueRefs(refs) {
  const seen = new Set();
  const result = [];
  for (const ref of refs) {
    if (seen.has(ref.localRel)) continue;
    seen.add(ref.localRel);
    result.push(ref);
  }
  return result;
}

function writeJson(filePath, payload) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, `${JSON.stringify(payload, null, 2)}\n`);
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const workspace = path.resolve(args.workspace);
  const markdownPath = path.resolve(args.markdown);
  const outputPath = path.resolve(args.output);
  const cdnMapPath = path.resolve(args.cdnMap || path.join(workspace, "publish", "cdn-map.json"));
  const topicSlug = args.topicSlug || path.basename(workspace);
  const config = loadConfig(path.resolve(args.env));

  const markdown = fs.readFileSync(markdownPath, "utf8");
  const refs = findImages(markdown, markdownPath, workspace);
  const items = readExistingMap(cdnMapPath);

  for (const ref of uniqueRefs(refs)) {
    if (!fs.existsSync(ref.localPath)) {
      throw new Error(`Image not found: ${ref.localPath}`);
    }
    if (items[ref.localRel] && items[ref.localRel].url && !args.force) continue;

    const key = buildKey(config, topicSlug, ref.localRel);
    const url = cdnUrl(config, key);
    const uploadResult = args.dryRun ? { hash: "", key } : await uploadFile(config, ref.localPath, key);
    items[ref.localRel] = {
      localPath: ref.localRel,
      key: uploadResult.key || key,
      url,
      hash: uploadResult.hash || "",
    };
  }

  let rewritten = markdown;
  for (const ref of refs) {
    rewritten = rewritten.replace(ref.original, renderMarkdownImage(ref, items[ref.localRel].url));
  }

  const unresolved = findImages(rewritten, markdownPath, workspace);
  if (unresolved.length > 0) {
    throw new Error(
      `Unresolved local image references after rewrite: ${unresolved.map((ref) => ref.target).join(", ")}`,
    );
  }

  writeJson(cdnMapPath, {
    provider: "qiniu-kodo",
    bucket: config.bucket,
    uploadedAt: new Date().toISOString(),
    dryRun: Boolean(args.dryRun),
    items: Object.keys(items).sort().map((key) => items[key]),
  });

  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  fs.writeFileSync(outputPath, rewritten);
  process.stdout.write(
    `${JSON.stringify({
      markdown: markdownPath,
      output: outputPath,
      cdnMap: cdnMapPath,
      images: refs.length,
      uploaded: uniqueRefs(refs).length,
      dryRun: Boolean(args.dryRun),
    })}\n`,
  );
}

main().catch((error) => {
  process.stderr.write(`${error.message}\n`);
  process.exit(1);
});
