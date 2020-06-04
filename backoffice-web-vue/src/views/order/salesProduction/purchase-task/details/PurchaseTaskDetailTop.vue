<template>
  <div class="purchase-task-form">
    <el-form>
    <el-row type="flex" justify="space-between" align="middle">
      <el-col :span="6">
        <el-form-item style="margin-bottom: 0">
          <label class="el-form-item__label">创建人：{{formData.code}}</label>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item style="margin-bottom: 0">
          <label class="el-form-item__label">关联任务：{{formData.orderCode}}</label>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item style="margin-bottom: 0">
          <label class="el-form-item__label">关联款号：{{formData.skuID}}</label>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item style="margin-bottom: 0">
          <label class="el-form-item__label">状态：{{formData.status}}</label>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row type="flex" justify="space-between" align="middle" class="basic-row">
      <el-col :span="6">
        <el-form-item style="margin-bottom: 0">
          <label class="el-form-item__label">采购名称：{{formData.purchaseName}}</label>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item style="margin-bottom: 0">
          <label class="el-form-item__label">完成时间：{{formData.completedDateFrom | timestampToTime}}
            ~ {{formData.completedDateTo | timestampToTime}}</label>
        </el-form-item>
      </el-col>
      <el-col :span="4">
        <el-form-item label="创建人" label-width="60" style="margin-bottom: 0">
<!--         <label class="el-form-item__label">创建人：{{formData.creator.name}}</label>-->
          <el-input :disabled="readOnly" v-model="formData.creator.name" style="width: 120px"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="4">
        <el-form-item label="审批人" label-width="60" style="margin-bottom: 0">
<!--         <label class="el-form-item__label">审批人：{{formData.approver.name}}</label>-->
          <el-select :disabled="readOnly" v-model="formData.approver" value-key="id" style="width: 120px">
            <el-option v-for="(item, index) in personList"
                       :value="item"
                       :key="item.id"
                       :label="item.name">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="4">
        <el-form-item label="采购人" label-width="60" style="margin-bottom: 0">
<!--          <label class="el-form-item__label">采购人：{{formData.purchaser.name}}</label>-->
          <el-select :disabled="readOnly" v-model="formData.purchaser" value-key="id" style="width: 120px">
            <el-option v-for="(item, index) in personList"
                       :value="item"
                       :key="item.id"
                       :label="item.name">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row type="flex" justify="start" align="middle" class="basic-row">
      <el-col :span="4">
        <el-form-item style="margin-bottom: 0">
          <label class="el-form-item__label">生产要求</label>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row type="flex" justify="start" align="top" class="basic-row">
      <el-col :span="6">
<!--        <h6>是否含税：{{formData.taxIncluded ? '含税' : '不含税'}}</h6>-->
        <el-form-item label="是否含税：" label-width="60">
          <el-radio :disabled="readOnly" v-model="formData.taxIncluded" :label="true">含税</el-radio>
          <el-radio :disabled="readOnly" v-model="formData.taxIncluded" :label="false">不含税</el-radio>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="品质要求：" label-width="60">
          <label class="el-form-item__label">{{formData.qualityLevel}}</label>
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
    props: ['formData', 'readOnly'],
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
