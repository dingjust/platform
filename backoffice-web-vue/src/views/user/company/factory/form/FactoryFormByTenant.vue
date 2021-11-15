<!--
* @Description: 平台端修改工厂信息表单
* @Date 2021/07/27 14:28
* @Author L.G.Y
-->
<template>
  <div v-if="formData">
    <el-row>
      <div class="orders-list-title">
        <h6>编辑工厂信息</h6>
      </div>
      <div class="titleCardClass">
        <el-form :model="formData" ref="factoryForm" :rules="rules" label-position="left" label-width="75px" hide-required-asterisk>
          <factory-basic-form :form-data="formData" />
          <factory-scale-form :form-data="formData" />
          <factory-capacity-form :form-data="formData" />
        </el-form>
      </div>
      <el-row type="flex" justify="center" style="margin-top: 20px">
        <el-button type="primary" @click="onModify">修改</el-button>
      </el-row>
    </el-row>
  </div>  
</template>

<script>
import FactoryBasicForm from '@/views/user/company/factory/form/FactoryBasicForm'
import FactoryScaleForm from '@/views/user/company/factory/form/FactoryScaleForm'
import FactoryCapacityForm from '@/views/user/company/factory/form/FactoryCapacityForm'

import { createNamespacedHelpers } from 'vuex';
const { mapMutations } = createNamespacedHelpers('FactoriesModule');

export default {
  name: 'FactoryFormByTenant',
  components: {
    FactoryBasicForm,
    FactoryScaleForm,
    FactoryCapacityForm
  },
  props: ['row'],
  methods: {
    ...mapMutations({
      setFactoryFormVisible: 'setFactoryFormVisible',
    }),
    async getDetail () {
      const url = this.apis().getFactory(this.row.uid);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      if (!result.contactAddress) {
        result['contactAddress'] = {
          id: null,
          fullname: '',
          cellphone: '',
          region: {
            isocode: '',
            name: ''
          },
          city: {
            code: '',
            name: ''
          },
          cityDistrict: {
            code: '',
            name: ''
          },
          line1: ''
        }
      }

      this.setFactoryFormVisible(true);
      this.$set(this, 'formData', result)
    },
    onModify () {
      this.$refs.factoryForm.validate(valid => {
        if (valid) {
          this._onModify()
        } else {
          this.$message.error('请先完善表单信息')
        }
      })
    },
    async _onModify () {
      const data = Object.assign({}, this.formData);
      if (data.productionMode === '' || data.productionMode == null) {
        this.$delete(data, 'productionMode');
      }
      const url = this.apis().updateFactoryByPlatform(this.row.uid);
      const result = await this.$http.put(url, data);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.$message.success('修改成功！');
      this.$emit('callback')
    }
  },
  data () {
    return {
      formData: null,
      rules: {
        'contactAddress.region': [
          {required: true, message: '请选择省', type: 'object', trigger: 'change'}
        ],
        'contactAddress.city': [
          {required: true, message: '请选择市', type: 'object', trigger: 'change'}
        ],
        'contactAddress.cityDistrict': [
          {required: true, message: '请选择区', type: 'object', trigger: 'change'}
        ],
        'contactAddress.line1': [
          {required: true, message: '请填写详细地址', trigger: 'blur'}
        ],
        // 'name': [
        //   {required: true, message: '请填写公司名称', trigger: 'blur'}
        // ],
        // 'contactPerson': [
        //   {required: true, message: '请填写联系人', trigger: 'blur'}
        // ],
        // 'contactPhone': [
        //   {validator: checkContactPhone, type: 'object', trigger: 'blur'}
        // ],
        // 'equipment': [
        //   {validator: cheackEquipment, type: 'object', trigger: 'change'}
        // ],
        // 'adeptAtCategories': [
        //   {required: true, message: '请选择品类', type: 'array', trigger: 'change'}
        // ],
        // 'categories': [
        //   {validator: checkCategories, type: 'object', trigger: 'change'}
        // ],
        // 'profilePicture': [
        //   {validator: checkProfilePicture, type: 'object', trigger: 'change'}
        // ],
        // 'duties': [
        //   {required: true, message: '请填写职务', trigger: 'blur'}
        // ],
        // 'populationScale': [
        //   {required: true, message: '请选择工厂人数', trigger: 'change'}
        // ],
        // 'cooperationModes': [
        //   {required: true, message: '请选择合作方式', trigger: 'change'}
        // ],
        // 'qualityLevels': [
        //   {required: true, message: '请选择质量等级', trigger: 'change'}
        // ]
      }
    }
  },
  created () {
    this.getDetail()
  }
}
</script>

<style scoped>
  .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }
</style>