<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <address-base-form ref="baseForm"
                         :slot-data="slotData"
                         :is-newly-created="isNewlyCreated">
      </address-base-form>
    </el-card>

    <div class="pt-2"></div>

    <el-row :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" size="mini" type="primary" @click="onSubmit">确定</el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" size="mini" @click="onCancel">取消</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import AddressBaseForm from './AddressBaseForm';

  export default {
    name: 'AddressForm',
    props: ['slotData', 'readOnly'],
    components: {AddressBaseForm},
    methods: {
      onSubmit() {
        const baseForm = this.$refs['baseForm'];
        baseForm.validate(valid => {
          if (!valid) {
            return false;
          }

          this._onSubmit();

          return true;
        });
      },
      async _onSubmit() {
        let request = this.$http.post;
        if (!this.isNewlyCreated) {
          request = this.$http.put;
        }

        const result = await request('/djbrand/system/address', this.slotData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('创建成功');
        // 刷新主体数据
        this.fn.closeSlider(true);
      },
      onCancel() {
        this.fn.closeSlider();
      },
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
      refresh() {
        this.onRegionChanged(this.slotData.deliveryAddress.region);
        this.onCityChanged(this.slotData.deliveryAddress.city);
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {}
    }
  }
</script>
