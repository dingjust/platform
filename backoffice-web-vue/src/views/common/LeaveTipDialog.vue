<template>
<!--  <a-modal :visible.sync="TipDialogVisible" width="400px" class="member-limit-dialog-box " :footer="null" @cancel="TipDialogVisible=false">-->
    <div>
      <el-row>
        <h2 style="margin-bottom: 20px"><i class="el-icon-warning" style="color: #E6A23C"></i>注意</h2>
      </el-row>
      <el-row type="flex" align="middle" style="margin-left: 30px">
        <div class="leave_tip">
          <h6>有部分信息变更尚未保存,</h6>
          <h6>确认要离开当前页面吗</h6>
        </div>
      </el-row>
      <el-row type="flex" align="middle" justify="end">
        <el-button type="primary" @click="leavelHandler(false)">
          留在页面
        </el-button>
        <el-button class="ml-16" @click="leavelHandler(true)">
          离开页面
        </el-button>
      </el-row>
    </div>
<!--  </a-modal>-->
</template>
<script>
  export default {
    name: 'LeaveTipDialog',
    data () {
      return {
      }
    },
    computed: {
      cId () {
        return this.orgItemData.cid
      }
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
