<template>
  <div class="animated fadeIn factory-service">
    <el-row>
      <h6 class="textClass">资质荣誉</h6>
    </el-row>
    <el-row type="flex" v-for="(row,index) in imgDatas" :key="index" style="margin-bottom: 20px">
      <el-col v-for="(item,i) of row" :key="i" :span="5"  style="margin-right: 10px">
        <img :src="item.url" width="100%" height="250px"/>
      </el-col>
    </el-row>
  </div>

</template>

<script>
  export default {
    name: 'FactoryCertificateInfoPage',
    props: ['slotData'],
    computed: {
    },
    methods: {
    },
    watch: {
      'slotData': function () {
        let index = 0;
        var newArray = [];
        while (index < this.slotData.certificates.length) {
          newArray.push(this.slotData.certificates.slice(index, index += 5));
        }
        this.imgDatas = newArray;
      }
    },
    data () {
      return {
        imgDatas: []
      }
    }
  }
</script>

<style scoped>
  .factory-service .textClass{
    font-size: 15px;
    font-weight: bold;
  }
</style>
