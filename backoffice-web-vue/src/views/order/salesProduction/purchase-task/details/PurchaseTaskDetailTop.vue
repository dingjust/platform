<template>
  <div class="purchase-task-form">
    <el-form>
    <el-row type="flex" justify="space-between" align="middle">
      <el-col :span="6">
        <h6>采购单号：{{formData.code}}</h6>
      </el-col>
      <el-col :span="6">
        <h6>关联任务：{{formData.orderCode}}</h6>
      </el-col>
      <el-col :span="6">
        <h6>关联款号：{{formData.skuID}}</h6>
      </el-col>
      <el-col :span="6">
        <h6>状态：{{formData.status}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" justify="space-between" align="middle" class="basic-row">
      <el-col :span="6">
        <h6>采购名称：{{formData.purchaseName}}</h6>
      </el-col>
      <el-col :span="6">
        <h6>完成时间：{{formData.completedDateFrom | timestampToTime}}
          -{{formData.completedDateTo | timestampToTime}}</h6>
      </el-col>
      <el-col :span="4">
        <h6>创建人：{{formData.creator.name}}</h6>
      </el-col>
      <el-col :span="4">
        <h6>审批人：{{formData.approver.name}}</h6>
      </el-col>
      <el-col :span="4">
        <h6>采购人：{{formData.purchaser.name}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" justify="start" align="middle" class="basic-row">
      <el-col :span="4">
        <h6>生产要求</h6>
      </el-col>
    </el-row>
    <el-row type="flex" justify="start" align="middle" class="basic-row">
      <el-col :span="6">
<!--        <h6>是否含税：{{formData.taxIncluded ? '含税' : '不含税'}}</h6>-->
        <el-form-item label="是否含税：" label-width="60">
          <el-radio v-model="formData.taxIncluded" :label="true">含税</el-radio>
          <el-radio v-model="formData.taxIncluded" :label="false">不含税</el-radio>
        </el-form-item>
      </el-col>
      <el-col :span="6">
<!--        <h6>品质要求：{{formData.qualityLevel}}</h6>-->
        <el-form-item label="品质要求：" label-width="60">
          <h6 style="margin-bottom: 0px">{{formData.qualityLevel}}</h6>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row type="flex" justify="start" align="middle">
      <el-col :span="24">
        <my-address-form :readOnly="true" :vAddress.sync="formData.shippingAddress" ref="addressComp" />
      </el-col>
    </el-row>
    </el-form>
  </div>
</template>

<script>
  import MyAddressForm from '@/components/custom/order-form/MyAddressForm';
  export default {
    name: 'PurchaseTaskDetailTop',
    components: {MyAddressForm},
    props: ['formData'],
    data () {
      return {
        completionTime: [],
        personList: [{
          id: this.$store.getters.currentUser.id,
          name: this.$store.getters.currentUser.username
        }],
        qualityLevel: [{
          code: 'FIRST_GRADE',
          name: '一等品'
        }, {
          code: 'SECOND_GRADE',
          name: '二等品'
        }, {
          code: 'NO_REQUIREMENT',
          name: '无需求'
        }]
      }
    },
    watch: {
      completionTime: function (newVal, oldVal) {
        if (newVal == null) {
          this.formData.completedDateFrom = null;
          this.formData.completedDateTo = null;
        } else {
          this.formData.completedDateFrom = newVal[0];
          this.formData.completedDateTo = newVal[1];
        }
      }
    }
  }
</script>

<style scoped>
  .purchase-task-form {
    margin-left: 10px;
  }

  .basic-row {
    margin-top: 10px;
  }
</style>
