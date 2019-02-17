<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <el-steps finish-status="success" align-center :active="active">
        <el-step title="基本信息"></el-step>
        <el-step title="多媒体上传"></el-step>
        <el-step title="完成"></el-step>
      </el-steps>
      <div class="pt-2"></div>
      <div v-show="active === 0">
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>基本信息</span>
          </div>
          <product-base-form ref="productBaseForm"
                             :slot-data="slotData"
                             :is-newly-created="isNewlyCreated">
          </product-base-form>
        </el-card>
        <div class="pt-2"></div>
        <el-card class="box-card">
          <div slot="header" class="clearfix">
            <span>产品颜色/尺码</span>
          </div>
          <product-variants-form ref="productVariantsForm"
                                 :slot-data="slotData"
                                 :is-newly-created="isNewlyCreated">
          </product-variants-form>
        </el-card>
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
        <product-media-upload-forms ref="productMediaUploadForm"
                                    :slot-data="slotData"
                                    :is-newly-created="isNewlyCreated">
        </product-media-upload-forms>
        <product-medias-form ref="productMediasForm"
                             :slot-data="slotData">
        </product-medias-form>
        <div class="pt-2"></div>
        <el-row :gutter="10">
          <el-col :span="12">
            <el-button class="btn-block" type="primary" size="mini" @click="onMediaUpload">上传</el-button>
          </el-col>
          <el-col :span="12">
            <el-button class="btn-block" size="mini" @click="next(2)">下一步</el-button>
          </el-col>
        </el-row>
      </div>
      <div v-show="active === 2">
        <product-details-page ref="productDetailsPage"
                              :slot-data="slotData"
                              :is-newly-created="isNewlyCreated"
                              :preview="true">
        </product-details-page>
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

  import ProductBaseForm from './ProductBaseForm';
  import ProductMediaUploadForms from './ProductMediaUploadForms';
  import ProductSpecificationForm from './ProductSpecificationForm';
  import ProductVariantsForm from './ProductVariantsForm';
  import ProductMediasForm from './ProductMediasForm';
  import ProductDetailsPage from './ProductDetailsPage';

  export default {
    name: 'ProductForm',
    props: ['slotData'],
    components: {
      ProductVariantsForm,
      ProductBaseForm,
      ProductMediaUploadForms,
      ProductSpecificationForm,
      ProductDetailsPage,
      ProductMediasForm
    },
    methods: {
      onSubmit() {
        let formData = Object.assign({}, this.slotData);
        let staircasePrices = formData.staircasePrices;
        // 按最大值排序
        staircasePrices.sort(function (a, b) {
          if (a.maxQuantity > b.maxQuantity) {
            return 1;
          }
          if (a.maxQuantity < b.maxQuantity) {
            return -1;
          }

          return 0;
        });
        // console.log(JSON.stringify(staircasePrices));

        const len = staircasePrices.length;
        if (len > 1) {
          for (let i = 0; i < len - 1; i++) {
            if (staircasePrices[i].maxQuantity > staircasePrices[i + 1].minQuantity) {
              this.$message.error('阶梯价格定义不符合规则【不允许有重叠价格区间】');
              return false;
            }
          }
        }

        this.$refs['productBaseForm'].validate(valid => {
          if (valid) {
            if (formData.price <= 0) {
              this.$message.error('供货价必须大于0');
              return false;
            }

            let request = axios.post;
            if (!this.isNewlyCreated) {
              request = axios.put;
            }

            let form = this.$refs['productVariantsForm'];

            const _entries = form.getValue();
            for (let i = 0; i < _entries.length; i++) {
              formData.variants.push({
                color: _entries[i].color.code,
                size: _entries[i].size.code
              })
            }

            request('/djbrand/product', formData)
              .then(response => {
                const product = response.data;
                this.$message.success('创建成功，产品编码：' + product.code);

                this.$set(this.slotData, 'id', product.id);
                this.$set(this.slotData, 'code', product.code);

                this.next(1);

                this.$refs['productDetailsPage'].refresh();
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
      onMediaUpload() {
        this.$refs['productMediaUploadForm'].onSubmit();
        setTimeout(() => {
          this.$refs['productMediasForm'].refresh()
        }, 2000);
      },
      onInventoryUpdate() {
        let form = this.$refs['productVariantsForm'];

        let formData = {
          code: this.slotData.code,
          variants: []
        };

        const _entries = form.getValue();
        for (let i = 0; i < _entries.length; i++) {
          formData.variants.push({
            color: _entries[i].color.code,
            size: _entries[i].size.code
          })
        }

        axios.put('/djbrand/product/variants', formData)
          .then(() => {
            this.$message({
              type: 'success',
              message: '更新颜色/尺码成功，产品编码：' + formData.code
            });

            this.$refs['productDetailsPage'].refresh();

            this.next(3);
          }).catch(error => {
          this.$message.error(error.response.data);
        });
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
      };
    }
  };
</script>
