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
  import axios from 'axios';

  import FabricProductBaseForm from './FabricProductBaseForm';
  import FabricProductDetailsPage from './FabricProductDetailsPage';

  export default {
    name: 'FabricProductForm',
    props: ['slotData'],
    components: {FabricProductBaseForm, FabricProductDetailsPage},
    methods: {
      onSubmit() {
        let formData = Object.assign({}, this.slotData);
        this.$refs['fabricProductBaseForm'].validate(valid => {
          if (valid) {
            let request = axios.post;
            if (!this.isNewlyCreated) {
              request = axios.put;
            }

            request('/djfactory/fabricProduct', formData)
              .then(response => {
                const code = response.data;
                this.$message.success('创建成功，产品编码：' + code);

                this.$set(this.slotData, 'code', code);

                this.next(1);
              }).catch(error => {
                this.$message.error(error.response.data);
              }
            );

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
