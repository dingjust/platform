<template>
  <div class="purchase-task-form">
    <el-row type="flex" justify="start" align="middle">
      <el-col :span="8">
        <el-form-item label="采购单号" label-width="60">
          <el-input :disabled="true" v-model="formData.code" style="width: 250px"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label="关联订单" label-width="60">
          <el-input :disabled="true" v-model="formData.orderCode" style="width: 250px"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label="关联款号" label-width="60">
          <el-input :disabled="true" v-model="formData.skuID" style="width: 250px"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row type="flex" justify="start" align="middle">
      <el-col :span="8">
        <el-form-item label="完成时间" label-width="60">
          <el-date-picker
            v-model="completionTime"
            style="width: 250px"
            type="daterange"
            value-format="timestamp"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期">
          </el-date-picker>
        </el-form-item>
      </el-col>
      <el-col :span="5">
        <el-form-item label="创建人" label-width="60">
          <el-input :disabled="true" v-model="formData.creator.name" style="width: 150px"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="5">
        <el-form-item label="审批人" label-width="60">
          <el-select v-model="formData.approver" value-key="id" style="width: 150px">
            <el-option v-for="(item, index) in personList"
                       :value="item"
                       :key="item.id"
                       :label="item.name">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="2">
        <el-form-item>
          <el-checkbox v-model="formData.isApproval">无需审核</el-checkbox>
        </el-form-item>
      </el-col>
      <el-col :span="4">
        <el-form-item label="采购人" label-width="60">
          <el-select v-model="formData.purchaser" value-key="id" style="width: 120px">
            <el-option v-for="(item, index) in personList"
                       :value="item"
                       :key="item.id"
                       :label="item.name">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row type="flex" justify="start" align="middle">
      <el-col :span="4">
        <el-form-item label="采购要求" label-width="60"/>
      </el-col>
    </el-row>
    <el-row type="flex" justify="start" align="middle">
      <el-col :span="8">
        <el-form-item label="是否含税" label-width="60">
          <el-radio v-model="formData.taxIncluded" :label="true">含税</el-radio>
          <el-radio v-model="formData.taxIncluded" :label="false">不含税</el-radio>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label="品质要求" label-width="60">
          <el-select v-model="formData.qualityLevel">
            <el-option v-for="(item, index) in qualityLevel"
                       :key="item.code"
                       :value="item.code"
                       :label="item.name">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row type="flex" justify="start" align="middle">
      <el-col :span="24">
        <my-address-form :vAddress.sync="formData.shippingAddress" ref="addressComp" />
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import MyAddressForm from '@/components/custom/order-form/MyAddressForm';
  export default {
    name: 'PurchaseTaskFormTop',
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
          this.formData.createdDateFrom = null;
          this.formData.createdDateTo = null;
        } else {
          this.formData.createdDateFrom = newVal[0];
          this.formData.createdDateTo = newVal[1];
        }
      }
    }
  }
</script>

<style scoped>
  .purchase-task-form {
    margin-left: 10px;
  }

  /deep/ .el-date-editor .el-range-separator {
    width: 10%;
  }
</style>
