<template>
  <div class="animated fadeIn factory-profiles">
    <el-row type="flex" >
      <el-col v-for="(item,index) in slotData.profiles" :key="index" :span="8" style="margin-right: 10px">
          <img :src="item.medias.length>0 ? item.medias[0].url : 'static/img/nopicture.png'" width="100%" height="180px" style="margin-bottom: 20px"/>
        <h6>{{item.description }}</h6>
      </el-col>
    </el-row>
  </div>

</template>

<script>
  export default {
    name: 'FactoryProfilesInfoPage',
    props: ['slotData'],
    computed: {
    },
    methods: {
    },
    data () {
      return {
      }
    }
  }
</script>

<style scoped>

</style>
