<template>
  <div>
    <el-dialog :visible.sync="dialogVisible" width="95%" class="purchase-dialog" :close-on-click-modal="false"
               append-to-body>
      <sample-accounting-sheet-form :slot-data="sampleAccountingSheet" @onSave="onAccountingSheetSave"
        :sampleSpecEntries="slotData.entries" v-if="hackSet" />
    </el-dialog>
    <el-dialog :visible.sync="viewDialogVisible" width="95%" class="purchase-dialog" :close-on-click-modal="false"
               append-to-body>
      <sample-accounting-sheet :slot-data="sampleAccountingSheet" :sampleSpecEntries="slotData.entries"
        v-if="hackSet" />
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
        <sample-attach-orders-form :entries.sync="slotData.entries" :medias.sync="slotData.medias"
          :productionProcessContent.sync="slotData.productionProcessContent" :productsColors="getClothesColors()" />
        <el-row style="margin-top:20px;" type="flex" align="center" :gutter="10">
          <el-col :span="4">
            <el-button class="product-form-btn" @click="onCreateAccountingSheet">创建成本核算单</el-button>
          </el-col>
          <el-col :span="2">
            <h6 style="padding-top:8px">核算单：</h6>
          </el-col>
          <el-col :span="18">
            <template v-for="(sheet,index) in slotData.costingSheets">
              <el-button :key="index" type="text" @click="onUpdateAccountingSheet(sheet,index)">
                {{sheet.id!=null?sheet.id:'成本核算单'+index+1}}
              </el-button>
            </template>
          </el-col>
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
  import SampleAccountingSheet from '../components/SampleAccountingSheet';


  export default {
    name: 'SampleProductForm',
    components: {
      SampleProductColorsSizesForm,
      ApparelProductImagesForm,
      ApparelProductBasicForm,
      SampleAttachOrdersForm,
      SampleAccountingSheetForm,
      SampleAccountingSheet
    },
    props: ['readOnly', 'isRead', 'isDialogOpen'],
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
            'id': item[0].id,
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
            'id': item[0].id,
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
        if (this.isDialogOpen) {
          this.$emit('closeDialog');
          return;
        }
        this.$router.go(-1);
      },
      onCreateAccountingSheet() {
        this.sampleAccountingSheet = {
          'isIncludeTax': true,
          'remarks': '',
          'totalPrice': 0,
          'materialsEntries': [],
          'specialProcessEntries': [],
          'laborCostEntries': []
        };
        this.hackSet = false;
        this.$nextTick(() => {
          this.hackSet = true;
        });
        this.dialogVisible = true;
      },
      onUpdateAccountingSheet(sheet, index) {
        this.sampleAccountingSheet = sheet;
        this.hackSet = false;
        this.$nextTick(() => {
          this.hackSet = true;
        });
        this.viewDialogVisible = true;
      },
      onAccountingSheetSave(sheet) {
        if (sheet.id != null) {
          var a = [];
          var entry = this.slotData.costingSheets.find(item => item.id == sheet.id);
          Object.assign(entry, sheet);
        } else if (sheet.key != null) {
          var entry = this.slotData.costingSheets.find(item => item.key == sheet.key);
          Object.assign(entry, sheet);
        } else {
          sheet['key'] = Date.now.toString;
          this.slotData.costingSheets.push(sheet);
        }
        this.dialogVisible = false;
      },
      getClothesColors() {
        var result = [];
        if (this.slotData.colorSizes != null && this.slotData.colorSizes.length > 0) {
          this.slotData.colorSizes.forEach(element => {
            let item = element[0];
            if (item != null) {
              result.push({
                'id': item.colorId,
                'code': item.colorCode,
                'name': item.color,
                'previewImg': item.previewImg
              });
            }
          });
        }
        return result;
      },
    },
    data() {
      return {
        dialogVisible: false,
        viewDialogVisible: false,
        formData: {},
        sampleAccountingSheet: {},
        hackSet: true
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
