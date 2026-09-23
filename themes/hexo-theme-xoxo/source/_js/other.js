// 埋点：SDK 由主题 _config.yml 的 scripts 引入（track.lion1ou.tech）。
// 首屏 PV、JS 错误与性能指标由 SDK 自动采集，静态站无需手动 pageView。
(function () {
  if (!window.FantaReport) return;
  window.FantaReport.initReport({
    reportHost: 'https://track.lion1ou.tech/v1/track',
    appName: 'lion1ou-blog',
  });
})();
