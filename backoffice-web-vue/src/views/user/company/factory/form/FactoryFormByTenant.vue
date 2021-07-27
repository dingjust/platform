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
        <el-form :model="formData" ref="factoryForm" label-position="left" label-width="75px" hide-required-asterisk>
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

export default {
  name: 'FactoryFormByTenant',
  components: {
    FactoryBasicForm,
    FactoryScaleForm,
    FactoryCapacityForm
  },
  props: ['row'],
  methods: {
    async getDetail () {
      const url = this.apis().getFactory(this.row.uid);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      this.$set(this, 'formData', result)
    },
    async onModify () {
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
      formData: null
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