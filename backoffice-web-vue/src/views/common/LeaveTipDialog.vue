<template>
  <div class="el-message-box">
    <el-row>
      <h2 style="margin-bottom: 20px"><i class="el-icon-warning" style="color: #E6A23C"></i>注意</h2>
    </el-row>
    <el-row type="flex" align="middle" style="margin-left: 30px">
      <div class="leave_tip">
        <h6>有部分数据变更尚未保存,离开数据将不作保留</h6>
        <h6>确认要离开当前页面吗</h6>
      </div>
    </el-row>
    <el-row type="flex" align="middle" justify="end">
      <el-button class="ml-16" @click="leavelHandler(false)">
        留在页面
      </el-button>
      <el-button type="primary" @click="leavelHandler(true)">
        离开页面
      </el-button>
    </el-row>
  </div>
</template>
<script>
  export default {
    name: 'LeaveTipDialog',
    data () {
      return {
      }
    },
    computed: {
    },
    methods: {
      leavelHandler (b) {
        this.$emit('leavelHandler', b)
      }
    }
  }
</script>
<style scoped>
</style>
