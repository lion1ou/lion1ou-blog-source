<template>
  <div style="position: relative; height: 100px;">
    <div style="background: green; width:100px; height: 100px;position:absolute;z-index:100"></div>
    <div style="position:absolute;z-index:99">
      <div style=" height:100px; width: 100px; background: red; position:absolute;z-index:101"></div>
      <div style=" height:100px; width: 100px; background: yellow;position:absolute;z-index:103"></div>
    </div>
  </div>
</template>
