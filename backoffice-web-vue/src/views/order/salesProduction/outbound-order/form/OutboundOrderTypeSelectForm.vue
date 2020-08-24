<template>
  <div>
    <el-row type="flex" justify="center">
      <el-col :span="4">
        <h6>选择外发订单类型</h6>
      </el-col>
    </el-row>
    <!-- <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-col :span="6">
        <h6 style="margin-top: 4px;">选择我方身份</h6>
      </el-col>
      <el-col :span="8">
        <el-radio v-model="formData.byAorB" :label="'PARTYA'">甲方</el-radio>
        <el-radio v-model="formData.byAorB" :label="'PARTYB'">乙方</el-radio>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center">
      <el-col :span="14">
        <h6 style="color: #F56C6C;font-size: 12px">这里的身份就是您在订单与合同的身份角色，甲方为发单方，乙方为接单方</h6>
      </el-col>
    </el-row> -->
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-col :span="6">
        <h6 style="margin-top: 4px;">订单管理方式</h6>
        <i class="el-icon-question" style="margin-left: 35px" v-popover:popover />
      </el-col>
      <el-col :span="8">
        <el-radio v-model="formData.managementMode" :label="'COLLABORATION'">协同订单</el-radio>
        <el-radio v-model="formData.managementMode" :label="'AUTOGESTION'">自管订单</el-radio>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-col :span="6">
        <el-button class="material-btn" @click="onSelectType">确认提交</el-button>
      </el-col>
    </el-row>
    <el-popover placement="top-start" width="400" trigger="hover" ref="popover">
      <div>
        <h6>
          <span style="color: #F56C6C">
            协同订单：
          </span>
          <span>{{collaborationTitle}}</span>
        </h6>
        <h6 style="padding-top: 10px">
          <span style="color: #F56C6C">
            自管订单：
          </span>
          <span>{{selfmanageTitle}}</span>
        </h6>
      </div>
    </el-popover>
  </div>
</template>

<script>
  export default {
    name: 'OutboundOrderTypeSelectForm',
    props: ['formData'],
    data() {
      return {
        collaborationTitle: '是由甲乙双方共同配合完成的订单管理方式，' +
          '订单需要双方确认，“生产进度” “发货”等动作由乙方' +
          '完成，任何一方的缺席订单无法顺利完成。',
        selfmanageTitle: '是有甲单方面完成订单的所有流程，不需要双方共同参与， 此类订单适合自我单方面管理订单。 ',
        confirmTiTle: '订单管理方式一旦选择后期不能更改，' +
          '你是否确认选择。'
      }
    },
    methods: {
      onSelectType() {
        this.$confirm(this.confirmTiTle, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$router.push({
            name: '创建外发订单',
            params: {
              formData: Object.assign({}, this.formData)
            }
          });
        });
      }
    },
    created() {}
  }

</script>

<style scoped>
  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }

</style>
