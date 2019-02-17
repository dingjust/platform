<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <el-steps finish-status="success" align-center :active="active">
        <el-step title="基本信息"></el-step>
        <el-step title="完成"></el-step>
      </el-steps>
      <div class="pt-2"></div>
      <div v-show="active === 0">
        <fabric-product-base-form ref="fabricProductBaseForm"
                                  :slot-data="slotData"
                                  :is-newly-created="isNewlyCreated">
        </fabric-product-base-form>
        <div class="pt-2"></div>
        <el-row :gutter="10">
          <el-col :span="12">
            <el-button class="btn-block" type="primary" size="mini" @click="onSubmit">保存</el-button>
          </el-col>
          <el-col :span="12">
            <el-button class="btn-block" size="mini" @click="onCancel">取消</el-button>
          </el-col>
        </el-row>
      </div>
      <div v-show="active === 1">
        <fabric-product-details-page ref="fabricProductDetailsPage"
                                     :slot-data="slotData"
                                     :is-newly-created="isNewlyCreated"
                                     :preview="true">
        </fabric-product-details-page>
        <div class="pt-2"></div>
        <el-row :gutter="10">
          <el-col :span="24">
            <el-button class="btn-block" type="primary" @click="onClose" size="mini">完成</el-button>
          </el-col>
        </el-row>
      </div>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('FactoryFabricProductsModule');

  import FabricProductBaseForm from './FabricProductBaseForm';
  import FabricProductDetailsPage from './FabricProductDetailsPage';

  export default {
    name: 'FabricProductForm',
    props: ['slotData'],
    components: {FabricProductBaseForm, FabricProductDetailsPage},
    methods: {
      ...mapActions({
        refresh: "refresh"
      }),
      onSubmit() {
        let formData = Object.assign({}, this.slotData);
        this.$refs['fabricProductBaseForm'].validate(valid => {
          if (valid) {
            this._onSubmit();

            return true;
          }

          return false;
        });
      },
      onCancel() {
        this.fn.closeSlider();
      },
      onClose() {
        this.fn.closeSlider(true);
      },
      next(active) {
        this.active = active;
      },
      async _onSubmit() {
        let formData = Object.assign({}, this.slotData);

        let request = this.$http.post;
        if (!this.isNewlyCreated) {
          request = this.$http.put;
        }

        const result = await request("/djfactory/fabricProduct", formData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('创建成功，产品编码：' + result);
        this.$set(this.slotData, 'code', result);
        this.next(1);
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {
        active: 0
      }
    }
  }
</script>
