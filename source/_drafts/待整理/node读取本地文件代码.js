const fs = require('fs');
getSidebar().then((res) => {
  console.log('文件目录读取完成~')
  fs.writeFileSync('./docs/.vuepress/sideBar.js', `module.exports =${JSON.stringify(res)}`)
  console.log('数据写入完成~')
})
async function getSidebar() {

  // 用于读取本地两个文件夹内文件，最多支持两级目录
  return Promise.resolve({
    '/knowledge/': await readFileName('./docs/knowledge/'),
    '/interview/': await readFileName('./docs/interview/'),
  });

  function readFileName(path) {
    return new Promise((resolve, reject) => {
      var fileList = [{
        title: '',
        collapsable: false,
        children: []
      }]
      let files = fs.readdirSync(path, ['utf-8', true])
      let dirNum = 0
      let dirNumSync = 0
      let ignoreNum = 0
      files.forEach((file) => {
        var stats = fs.statSync(path + file)
        if (stats.isDirectory()) {
          dirNum++
        }
      })
      files.forEach((file, index) => {
        if (file !== 'node_modules' && file.indexOf('.') !== 0) {
          var stats = fs.statSync(path + file) // 读取文件属性
          if (stats.isFile()) {
            if (file.indexOf('README.md') === -1) {
              fileList[0].children.push(file)
            }
            if (dirNum === 0 && (files.length - 1 - ignoreNum) === index) {
              resolve(fileList)
            }
          } else if (stats.isDirectory()) {
            var obj = {
              title: file,
              collapsable: false,
              children: []
            }
            var pathTemp = path + file + '/'
            // 读取二级目录
            let files1 = fs.readdirSync(pathTemp, ['utf-8', true])
            dirNumSync++
            files1.forEach((file1, index1) => {
              obj.children.push(file + '/' + file1)
            })
            fileList.push(obj)
            if (dirNum === dirNumSync) {
              resolve(fileList)
            }
          } else {
            console.log('--------')
          }
        } else {
          ignoreNum++
        }
      })
    })
  }
}