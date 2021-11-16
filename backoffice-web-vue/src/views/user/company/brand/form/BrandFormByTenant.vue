<!--
* @Description: 平台端修改品牌信息的表单
* @Date 2021/07/27 11:30
* @Author L.G.Y
-->
<template>
  <div v-if="formData">
    <el-row>
      <div class="orders-list-title">
        <h6>编辑品牌信息</h6>
      </div>
      <el-form :model="formData" ref="brandForm" label-position="left" label-width="75px" hide-required-asterisk :disabled="readOnly">
        <div class="titleCardClass">
          <brand-basic-info-form :formData="formData" :readOnly="readOnly"/>
          <brand-capacity-form :formData="formData" :readOnly="readOnly"/>
        </div>
      </el-form>
      <el-row type="flex" justify="center" style="margin-top: 20px" v-if="!readOnly">
        <el-button type="primary" @click="onModify">修改</el-button>
      </el-row>
    </el-row>
  </div>  
</template>

<script>
import BrandBasicInfoForm from '@/views/user/company/brand/form/BrandBasicInfoForm'
import BrandCapacityForm from '@/views/user/company/brand/form/BrandCapacityForm'

export default {
  name: 'BrandFormByTenant',
  components: { BrandBasicInfoForm, BrandCapacityForm },
  props: {
    row: {
      type: Object,
      default: () => {}
    },
    readOnly: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    async getDetail () {
      const url = this.apis().getBrand(this.row.uid);
      const result = await this.$http.get(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.duties == null || result.duties == undefined) {
        result.duties = '经理';
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

      this.$set(this, 'formData', result)
    },
    async onModify () {
      const data = Object.assign({}, this.formData);

      const url = this.apis().updateBrand(this.row.uid);
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
  .titleCardClass {
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }
</style>