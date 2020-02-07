<template>
  <div>
    <div id="div1" draggable="true"></div>
    <div id="div2"></div>
  </div>
</template>
<script>
export default {
  mounted() {
    document.getElementById('div1').addEventListener('dragstart', function (params) {
      console.log('dragstart')
    })
    document.getElementById('div1').addEventListener('dragend', function (params) {
      console.log('dragend')
    })
    document.getElementById('div2').addEventListener('dragenter', function (params) {
      console.log('dragenter')
    })
    document.getElementById('div2').addEventListener('dragover', function (params) {
      console.log('dragover')
    })
    document.getElementById('div1').addEventListener('drop', function (params) {
      console.log('drop')
    })
    document.getElementById('div1').addEventListener('dragover', function (params) {
      console.log('dragover')
    })
    document.getElementById('div1').addEventListener('click', function (params) {
      console.log('ssss')
    })
  }
};
</script>
<style scoped>
#div1{
  width: 100px;
  height: 100px;
  border: 1px solid #f0f;
}
#div2{
  width: 100px;
  height: 100px;
  border: 1px solid #2ff;
}
</style>
