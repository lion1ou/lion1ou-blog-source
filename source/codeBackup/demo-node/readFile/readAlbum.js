// 用于移动nas内的备份图片

const fs = require('fs')
const path = require('path')
var copydir = require('copy-dir');


let src = '/Volumes/home/Drive/Moments/Mobile/MI\ 6/DCIM'
let src1 = '/Volumes/home/Drive/Moments/Mobile/MI\ 6/DCIM-1'

let files = fs.readdirSync(src, ['utf-8', true])
let progress = 0
for (let index = 0; index < files.length; index++) {
  const item = files[index];
  let path = `${src}/${item}`
  var stats = fs.statSync(path)
  if (stats.isDirectory()) {
    copydir(path, src, {
      utimes: true,  // keep add time and modify time
      mode: true,    // keep file mode
      cover: true    // cover file when exists, default is true
    }, function (err) {
      if (err) throw err;
      progress++
      console.log(`${path}  ${progress}/${files.length}    ${(progress / files.length).toFixed(2)}  done`);
    });
  } else {
    progress++
    console.log(`${path}   ${progress}/${files.length}    ${(progress / files.length).toFixed(2)}  done`);
  }
}


// function copyOrigin () {
//   let files1 = fs.readdirSync(path, ['utf-8', true])
//   files1.map(item1 => {
//     var stats1 = fs.statSync(`${path}/${item1}`)
//     if (stats1.isFile() && item1.indexOf('.jpg') !== 0) {
//       // fs.writeFileSync(`${src1}/${item1}`, fs.readFileSync(`${path}/${item1}`))
//       fs.createReadStream(`${path}/${item1}`).pipe(fs.createWriteStream(`${src1}/${item1}`));
//       console.log(`${path}/${item1}`, `${src1}/${item1}`)
//       allNum++
//     }
//   })
// }

// async function copy(from, to) {
//   await copydir(from, to)
// }


