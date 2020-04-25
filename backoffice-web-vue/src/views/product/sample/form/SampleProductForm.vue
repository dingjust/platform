<template>
  <div>
    <el-dialog :visible.sync="dialogVisible" width="90%" class="purchase-dialog" :close-on-click-modal="false">
      <sample-accounting-sheet-form slot-data="slotData" />
    </el-dialog>
    <el-form ref="form" :model="slotData">
      <el-card class="box-card">
        <el-row class="info-title-row">
          <div class="info-title">
            <h6 class="info-title_text">基本信息</h6>
          </div>
        </el-row>
        <apparel-product-basic-form :slot-data="slotData" :read-only="false" :isRead="isRead">
        </apparel-product-basic-form>
        <el-divider></el-divider>
        <sample-product-colors-sizes-form :slot-data="slotData" :isRead="isRead" />
        <el-divider></el-divider>
        <apparel-product-images-form :slot-data="slotData" :read-only="readOnly" :isRead="isRead">
        </apparel-product-images-form>
        <sample-attach-orders-form :slot-data="slotData" />
        <el-row style="margin-top:20px;">
          <el-col :span="6"><el-button class="product-form-btn" @click="dialogVisible=true">创建成本核算单</el-button></el-col>          
        </el-row>
      </el-card>
      <el-row type="flex" justify="center" class="product-form-row">
        <el-button class="product-form-btn" @click="onUpdate()"
          v-if="this.slotData.code!=null&&this.slotData.code!=''&&!isRead">更新产品信息</el-button>
        <el-button class="product-form-btn" @click="onCreate()"
          v-if="(this.slotData.code==null||this.slotData.code=='')&&!isRead">确认创建样衣</el-button>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapMutations,
    mapActions
  } = createNamespacedHelpers('SampleProductsModule');

  import ApparelProductImagesForm from '@/views/product/apparel/form/ApparelProductImagesForm';
  import ApparelProductBasicForm from '@/views/product/apparel/form/ApparelProductBasicForm';
  import SampleProductColorsSizesForm from './SampleProductColorsSizesForm';
  import SampleAttachOrdersForm from './SampleAttachOrdersForm';
  import SampleAccountingSheetForm from './SampleAccountingSheetForm';


  export default {
    name: 'SampleProductForm',
    components: {
      SampleProductColorsSizesForm,
      ApparelProductImagesForm,
      ApparelProductBasicForm,
      SampleAttachOrdersForm,
      SampleAccountingSheetForm
    },
    props: ['readOnly', 'isRead'],
    computed: {
      ...mapGetters({
        slotData: 'newFormData'
      })
    },
    mounted() {},
    methods: {
      ...mapActions({
        resetFormData: 'resetFormData'
      }),
      onUpdate() {
        this.$refs['form'].validate(valid => {
          if (valid) {
            this._Update();
            return true;
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      async _Update() {
        this.formData = Object.assign({}, this.slotData);
        this.formData.category = {
          code: this.slotData.category[1]
        };
        this.slotData.variants = [];
        this.steppedPrices = [];
        var colorSizes = [];
        this.formData.colorSizes.forEach((item) => {
          var obj = {
            'colorCode': item[0].colorCode,
            'colorName': item[0].color,
            'sizes': []
          };
          if (item[0].previewImg != null && item[0].previewImg.length > 0) {
            obj.previewImg = item[0].previewImg[0];
          }
          item.forEach((item1) => {
            obj.sizes.push({
              'code': item1.sizeCode,
              'name': item1.size,
              'quality': item1.quality
            });
          });
          colorSizes.push(obj);
        });
        this.formData.variants = null;
        this.formData.colors = null;
        this.formData.sizes = null;
        this.formData.colorSizes = colorSizes;
        this.formData.belongTo = null;

        //////////////////
        delete this.formData.approvalStatus;

        ////////
        const url = this.apis().updateOfSampleProduct(this.slotData.code);
        const result = await this.$http.put(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('更新产品信息成功');
        this.$router.go(-1);
      },
      onCreate() {
        // if (this.slotData.images == null || this.slotData.images.length == 0) {
        //   this.$message.error('请上次产品主图');
        //   return;
        // }
        this.$refs['form'].validateField('category');
        this.$refs['form'].validate(valid => {
          if (valid) {
            this._Create();
            return true;
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      async _Create() {
        this.formData = Object.assign({}, this.slotData);
        this.formData.category = {
          code: this.slotData.category[1]
        };
        var colorSizes = [];
        this.formData.colorSizes.forEach((item) => {
          var obj = {
            'colorCode': item[0].colorCode,
            'colorName': item[0].color,
            'sizes': []
          };
          if (item[0].previewImg != null && item[0].previewImg.length > 0) {
            obj.previewImg = item[0].previewImg[0];
          }
          item.forEach((item1) => {
            obj.sizes.push({
              'code': item1.sizeCode,
              'name': item1.size,
              'quality': item1.quality
            });
          });
          colorSizes.push(obj);
        });
        this.formData.colorSizes = colorSizes;
        const url = this.apis().createSampleProduct();
        const result = await this.$http.post(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('样衣创建成功，产品编号： ' + result.code);
        // this.$set(this.slotData, 'code', result);
        this.$router.go(-1);
      },
    },
    data() {
      return {
        dialogVisible: false,
        formData: {}
      };
    },
    destroyed() {
      this.resetFormData();
    }
  };

</script>
<style scoped>
  .info-title {
    width: 100%;
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
    height: 14px;
  }

  .info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 0.85);
  }

  .info-title-row {
    margin-bottom: 20px;
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    /* margin-top: 5px; */
    width: 60px;
    font-size: 12px;
    font-weight: 500;
  }

  .info-input-prepend2 {
    display: inline-block;
    margin: 0 5px;
    width: 20px;
    font-size: 12px;
    color: rgba(0, 0, 0, 0.45);
  }

  .product-form-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 150px;
  }

  .product-form-row {
    margin-top: 20px;
  }

  .product-card-1 {
    margin-bottom: 10px;
  }

  .product-card-1_text {
    color: red;
  }

  /deep/ .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 0px;
  }

</style>
