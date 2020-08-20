<template>
  <el-row type="flex" style="padding-left:10px">
    <el-form-item label="订单管理方式" prop="manageWay" label-width="130px"
      :rules="[{ required: true, message: '请选择订单管理方式', trigger: 'change' },]">
      <el-popover placement="right" width="350" trigger="hover">
        <el-row type="flex" justify="center">
          <h6>订单管理方式</h6>
        </el-row>
        <div class="text-container">
          <h6><span class="text-type">协同订单：</span>{{coordinationText}}</h6>
        </div>
        <div class="text-container">
          <h6><span class="text-type">自管订单：</span>{{selfText}}</h6>
        </div>
        <i class="el-icon-question text-icon" slot="reference"></i>
      </el-popover>
      <el-radio @change="onClick('1')" :value="formData.manageWay" label="1">协同订单</el-radio>
      <el-radio @change="onClick('2')" :value="formData.manageWay" label="2">自管订单</el-radio>
    </el-form-item>
  </el-row>
</template>

<script>
  export default {
    name: 'OutboundTypeSelect',
    props: {
      formData: {
        type: Object
      }
    },
    methods: {
      onClick(val) {
        this.$confirm('订单管理方式一旦选择后期不能更改, 你是否确认选择?', '提示', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          this.$set(this.formData, 'manageWay', val);
        }).catch(() => {

        });
      }
    },
    data() {
      return {
        coordinationText: '是由甲乙双方共同配合完成的订单管理方式，订单需要双方确认，“生产进度”，“发货”，等由乙方完成，任何一方的缺席订单无法顺利完成。',
        selfText: '是有甲乙任何一方单方面完成订单的所有流程，不需要双方共同参与，此类订单适合自我单方面管理订单。'
      }
    },
  };

</script>

<style scoped>
  .text-container {
    width: 100%;
    padding-left: 20px;
    padding-right: 20px;
    padding-top: 10px;
  }

  .text-type {
    color: red;
  }

  .text-icon {
    color: red;
    font-size: 18px;
    padding-top: 5px;
    margin-right: 10px;
  }

</style>
