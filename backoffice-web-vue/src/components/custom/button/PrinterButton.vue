<template>
  <div class="printer_btn">
    <el-row type="flex" justify="center" style="width:100%">
      <i class="iconfont2_2 printer_icon">&#xe639;</i>
    </el-row>
    <el-row type="flex" justify="center" style="width:100%">
      <p class="printer_font">打印单据</p>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'PrinterButton',    
  }

</script>
<style scoped>
  .printer_btn {
    width: 60px;
    height: 60px;
  }

  .printer_btn:hover {
    cursor: pointer;
  }

  .printer_icon {
    font-size: 35px;
    line-height: 30px;
  }

  .printer_font {
    margin-top: 3px;
    font-size: 10px;
    line-height: 10px;
  }

</style>
