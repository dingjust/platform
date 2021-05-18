<template>
  <div class="out-contact-com">
    <el-row type="flex" justify="start" style="padding-left: 30px">
      <el-form-item label="标题" prop="title" style="margin: 0px">
        <el-input v-model="formData.title" style="width: 200px"></el-input>
      </el-form-item>
    </el-row>
    <el-row type="flex" justify="start" style="padding-left: 10px">
      <h6>合作对象</h6>
    </el-row>
    <div class="contact-row">
      <el-form-item label="外发工厂" prop="outboundCompanyName" 
        :rules="[{required: true, message: '请选择外发工厂', trigger: 'change'}]">
        <el-input v-model="formData.outboundCompanyName" :disabled="true"></el-input>
      </el-form-item>
      <el-form-item label="联系人" prop="outboundContactPerson"
        :rules="[{required: true, message: '请选择联系人', trigger: 'change'}]">
        <el-input v-model="formData.outboundContactPerson" :disabled="true"></el-input>
      </el-form-item>
      <el-form-item label="联系方式" prop="outboundContactPhone" style="margin-right: 20px"
        :rules="[{required: true, message: '请选择联系方式', trigger: 'change'}]">
        <el-input v-model="formData.outboundContactPhone" :disabled="true"></el-input>
      </el-form-item>
      <div>
        <el-button @click="suppliersSelectVisible=!suppliersSelectVisible">选择合作商</el-button>
      </div>
    </div>
    <el-dialog :visible.sync="suppliersSelectVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <supplier-select @onSelect="onSuppliersSelect" :categories="['SUPPLIER']" />
    </el-dialog>
  </div>
</template>

<script>
import { SupplierSelect } from '@/components'

export default {
  name: 'OutboundOrderContactCom',
  props: ['formData'],
  components: {
    SupplierSelect
  },
  methods: {
    onSuppliersSelect(val) {
      this.suppliersSelectVisible = false;
      this.formData.outboundCompanyName = val.name;
      this.formData.outboundContactPerson = val.person;
      this.formData.outboundContactPhone = val.phone;
      this.formData.targetCooperator.id = val.id;
      if (val.payPlan != null) {
        this.$delete(val.payPlan, 'id');
        val.payPlan.payPlanItems.forEach(element => {
          this.$delete(element, 'id');
        });
        // this.formData.payPlan = JSON.parse(JSON.stringify(val.payPlan));
        this.formData.payPlan = Object.assign({}, val.payPlan);
        this.$message.success('已关联选择合作商绑定账务方案：' + val.payPlan.name);
      }
    }
  },
  data () {
    return {
      suppliersSelectVisible: false
    }
  }
}
</script>

<style scoped>
.contact-row {
  display: flex; 
  justify-content: flex-start;
  align-items: flex-start;
  flex-wrap: wrap;
  padding-left: 30px;
}

</style>