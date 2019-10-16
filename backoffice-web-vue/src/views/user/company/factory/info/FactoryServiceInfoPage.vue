<template>
  <div class="animated fadeIn factory-service">
    <el-row>
      <h6 class="textClass">工厂服务</h6>
    </el-row>


  </div>
</template>

<script>
  export default {
    name: 'FactoryServiceInfoPage',
    props: ['slotData'],
    computed: {

    }
  }
</script>

<style scoped>
  .factory-service .rowClass{
    margin-bottom:10px;
  }
  .factory-service .rowClass2{
    margin-bottom:40px;
  }
  .factory-service .textClass{
    font-size: 15px;
    font-weight: bold;
  }
  .factory-service .titleTextClass{
    color: #C0C0C0;
  }

</style>
