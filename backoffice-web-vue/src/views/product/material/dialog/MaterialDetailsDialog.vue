<template>
  <div class="animated fadeIn">
    <el-row type="flex" justify="space-between" align="middle">
      <div class="material-list-title">
        <h6>{{isCreate && !formData.id ? '添加物料' : '物料详情'}}</h6>
      </div>
      <el-button class="material-btn" v-if="!isCreate" @click="editMaterial">编辑物料</el-button>
    </el-row>
    <div class="pt-4"></div>
    <el-form :model="formData" ref="form" :rules="rules" label-width="80px" label-position="right"> 
      <el-row type="flex" style="padding-left: 20px">
        <el-col :span="8">
          <el-form-item label="物料类型" prop="materialsType">
            <el-select v-model="formData.materialsType" placeholder="请选择" :disabled="!isCreate">
              <el-option
                v-for="item in materialsType"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>    
        </el-col>
      </el-row>
      <el-row type="flex" style="padding-left: 20px" align="middle">
        <el-col :span="2">
          <label class="el-form-item__label pic-label" >上传图片</label>
        </el-col>
        <el-col :span="22">
          <images-upload class="product-images-form-upload" :slot-data="formData.images" :limit="5" :disabled="!isCreate">
            <template slot="picBtn" v-if="isCreate">
              <h6>大小不超过5M/张，且最多5张主图</h6>
            </template>
          </images-upload>
        </el-col>
      </el-row>
      <el-row type="flex" style="padding-left: 20px">
        <el-col>
          <label class="el-form-item__label">基本信息</label>
        </el-col>
      </el-row>
      <el-row type="flex" style="padding-left: 20px" :gutter="10">
        <el-col :span="8">
          <el-form-item label="物料名称" prop="name">
            <el-input v-model="formData.name" placeholder="输入物料名称" maxlength="40" show-word-limit :disabled="!isCreate"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="物料编号" prop="code">
            <el-input v-model="formData.code" placeholder="物料编号由系统自动生产" :disabled="true"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="物料单位" prop="materialsUnit">
            <el-select v-model="formData.materialsUnit" placeholder="请选择" :disabled="!isCreate">
              <el-option
                v-for="item in materialsUnit"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row type="flex" style="padding-left: 20px" :gutter="10">
        <el-col :span="8">
          <el-form-item label="物料幅宽">
            <el-input v-model="formData.materialWidth" placeholder="输入物料幅宽" :disabled="!isCreate"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="物料成分">
            <el-input v-model="formData.materialComposition" placeholder="输入物料成分" :disabled="!isCreate"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row type="flex" style="padding-left: 20px">
        <el-divider></el-divider>
      </el-row>
      <el-row type="flex" style="padding-left: 20px">
        <el-col :span="2">
          <label class="el-form-item__label pic-label" >物料规格</label>
        </el-col>
        <el-col :span="22">
          <!---------------------------------- 颜色 --------------------------------------------------------------->
          <div class="border-container" v-if="isCreate">
            <el-row type="flex" style="margin-bottom: 18px">
              <h6>颜色</h6>&nbsp;&nbsp;<h6>最多支持30个颜色</h6>
            </el-row>
            <el-checkbox-group v-model="formData.colors" :max="colorsMax">
              <template v-for="color in colors">
                <el-checkbox class="size-tag" :label="color.name" :key="color.id" 
                  @change="((val,$event)=>colorHanleClick(val,color))" style="margin-bottom: 35px">
                  <el-row  type="flex" style="float: left;margin-bottom: -13px;" >
                    <div :style="{width: '13px',height: '13px',backgroundColor: color.colorCode==null?'#': color.colorCode,marginRight: '5px',align:'middle'}">
                    </div>
                    <h6>{{color.name}}</h6>
                  </el-row>
                </el-checkbox>
              </template>
            </el-checkbox-group>
            <el-row type="flex" v-for="(color,index) in customColors" v-if="index%4 == 0">
              <template v-for="(customColor) in customColors.slice(index,index+4)" >
                <el-col :span="6">
                  <el-row type="flex" style="margin-bottom: 20px;margin-right: 10px">
                    <el-input v-model="customColor.name" @change="editCustomColor(customColor)" :disabled="colorDisabled(customColor)"></el-input>
                    <el-button type="text" @click="removeCustomColor(customColor)" :disabled="colorDisabled(customColor)"> 删除</el-button>
                  </el-row>
                </el-col>
              </template>
              <el-row type="flex" v-if="Math.floor(index/4) == Math.floor(customColors.length/4)">
                <el-button style="margin-right: 11px;margin-bottom: 20px" @click="appendCustomColor">+ 添加自定义颜色</el-button>
              </el-row>
            </el-row>
            <el-row type="flex" v-if="customColors.length%4 == 0">
              <el-button style="margin-right: 11px;margin-bottom: 20px" @click="appendCustomColor">+ 添加自定义颜色</el-button>
            </el-row>
          </div>
          <!---------------------------------- 规格/克重 --------------------------------------------------------------->
          <div class="border-container" style="margin-top: 10px" v-if="isCreate">
            <el-row type="flex" style="margin-bottom: 18px">
              <h6>规格/克重</h6>&nbsp;&nbsp;<h6>最多支持30个规格</h6>
            </el-row>
            <el-row type="flex" align="middle" v-for="(specItem,index) in formData.specs" v-if="index % 4 == 0">
              <template  v-for="(spec) in formData.specs.slice(index, index+4)">
                <el-col :span="6">
                  <el-row type="flex" style="margin-bottom: 20px;margin-right: 10px">
                    <el-input ref="input" v-model="spec.name" @change="editSpec(spec)" :disabled="specDisabled(spec)"></el-input>
                    <el-button type="text" @click="removeSpec(spec)" :disabled="specDisabled(spec)">删除</el-button>
                  </el-row>
                </el-col>
              </template>
            </el-row>
            <el-row type="flex">
              <el-button style="margin-right: 11px;margin-bottom: 20px" @click="appendSpec">+ 添加自定义规格</el-button>
            </el-row>
          </div>
          <!---------------------------------- 尺寸/型号 --------------------------------------------------------------->
          <div class="border-container" style="margin-top: 10px" v-if="isCreate">
            <el-row type="flex" style="margin-bottom: 18px">
              <h6>尺寸/型号</h6>&nbsp;&nbsp;<h6>最多支持30个规格</h6>
            </el-row>
            <el-row type="flex" align="middle" v-for="(modelItem,index) in formData.models" v-if="index % 4 == 0">
              <template  v-for="(model) in formData.models.slice(index, index+4)">
                <el-col :span="6">
                  <el-row type="flex" style="margin-bottom: 20px;margin-right: 10px">
                    <el-input ref="input" v-model="model.name" @change="editModel(model)" :disabled="modelDisabled(model)"></el-input>
                    <el-button type="text" @click="removeModel(model)" :disabled="modelDisabled(model)">删除</el-button>
                  </el-row>
                </el-col>
              </template>
            </el-row>
            <el-row type="flex">
              <el-button style="margin-right: 11px;margin-bottom: 20px" @click="appendModel">+ 添加自定义规格</el-button>
            </el-row>
          </div>
          <div class="border-container" style="margin-top: 10px">
            <el-form-item prop="variants" label-width="0px">
              <material-style-details-form ref="materielForm" :formData="formData" :isCreate="isCreate"
                                            :specsData="selectSpecs" :colorsData="selectColors" :modelsData="selectModels"/>
            </el-form-item>
          </div>
        </el-col>
      </el-row>
    </el-form>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-button v-if="isCreate" size="medium" class="material-btn" @click="onSubmit">{{formData.id ? '保存' : '创建物料'}}</el-button>
    </el-row>
  </div>
</template>

<script>
  import { createNamespacedHelpers } from 'vuex';

  const { mapActions } = createNamespacedHelpers('MaterialModule');

  import ImagesUpload from '../../../../components/custom/ImagesUpload';
  import MaterialStyleDetailsForm from '../form/MaterialStyleDetailsForm';
  export default {
    name: 'MaterialDetailsPage',
    components: {MaterialStyleDetailsForm, ImagesUpload},
    props: {
    },
    computed: {
    },
    methods: {
      ...mapActions({
        resetFormData: 'resetFormData'
      }),
      specDisabled (spec) {
        return this.formData.variants.findIndex(item => item.spec.name === spec.name) > -1;
      },
      modelDisabled (model) {
        return this.formData.variants.findIndex(item => item.model.name === model.name) > -1;
      },
      colorDisabled (color) {
        return this.formData.variants.findIndex(item => item.color.name === color.name) > -1;
      },
      editMaterial () {
        // this.getAllColors();
        this.selectColors = Object.assign([], this.formData.colors);
        this.customColors = this.formData.colors.filter(val => val.customize);
        this.formData.colors = this.formData.colors.map((color) => color.name);
        this.isCreate = true;
        this.returnCount();
      },
      async getAllColors () {
        const url = this.apis().getAllColors();
        this.colors = await this.$http.get(url);
      },
      colorHanleClick (val, color) {
        var index = this.selectColors.findIndex((v) => v.name === color.name);
        if (index < 0) {
          this.$set(color, 'key', Number(Math.random().toString().substr(3, 3) + Date.now()).toString(36));
          if (color.previewImg == null) {
            color.previewImg = [];
          }
          this.selectColors.push(color);
        } else {
          const flag = this.formData.variants.some(val => {
            return val.color.name == color.name;
          })
          if (flag) {
            this.formData.colors.push(color.name);
            this.$message.error('此颜色已被使用，若想删除请取消使用后继续操作');
            return;
          }
          this.selectColors.splice(index, 1);
        }
      },
      getColorSizes () {
        var colors = [];
        for (let i = 0; i < this.selectColors.length; i++) {
          var arr = [];
          for (let j = 0; j < this.selectSizes.length; j++) {
            let obj = {
              'colorCode': this.selectColors[i].code,
              'color': this.selectColors[i].name,
              'previewImg': this.selectColors[i].previewImg,
              'size': this.selectSizes[j].name,
              'sizeCode': this.selectSizes[j].code,
              'quality': this.selectSizes[j].quality
            }
            let key = obj.color + obj.size;
            if (this.colorSizeQualityMap[key] != null) {
              obj.quality = this.colorSizeQualityMap[key];
            } else {
              obj.quality = this.selectSizes[j].quality;
            }
            arr.push(obj);
          }
          colors.push(arr);
        }
        return colors;
      },
      appendCustomColor () {
        if ((this.formData.colors.length + this.customColors.length) >= 30) {
          this.$message.error('支持颜色已到达上限');
          return;
        }
        this.customColors.push({
          name: null,
          previewImg: [],
          key: Number(Math.random().toString().substr(3, 3) + Date.now()).toString(36)
        });
        this.colorsMax = this.colorsMax - 1;
      },
      removeCustomColor (color) {
        const flag = this.formData.variants.some(val => {
          return val.color.name == color.name;
        })
        if (flag && color.name != null && color.name.replace(/^\s*|\s*$/g, '').length > 0) {
          this.$message.error('此颜色已被使用，若想删除请取消使用后继续操作');
          return;
        }

        this.$confirm('正在执行删除操作, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          let index = this.customColors.indexOf(color);
          if (index > -1) {
            this.customColors.splice(index, 1);
            let index1 = this.selectColors.indexOf(color);
            if (index1 > -1) {
              this.selectColors.splice(index1, 1);
            }
          }
          this.colorsMax = this.colorsMax + 1;
        })
      },
      editCustomColor (color) {
        if (color.name != null && color.name !== '') {
          let index = this.selectColors.indexOf(color);
          if (index > -1) {
            this.selectColors[index].name = color.name;
            this.selectColors[index].code = null;
            this.formData.colorSizes = this.getColorSizes();
          } else {
            this.selectColors.push(color);
          }
        }
      },
      editSpec (spec) {
        if (spec.name.replace(/(^s*)|(s*$)/g, '').length > 0) {
          const index = this.selectSpecs.findIndex(item => item.key === spec.key);
          if (index > -1) {
            this.selectSpecs[index].name = spec.name;
            this.selectSpecs[index].code = null;
          } else {
            this.selectSpecs.push(spec);
          }
        }
      },
      appendSpec () {
        if (this.formData.specs.length >= 30) {
          this.$message.error('支持规格已到达上限');
          return;
        }
        let flag = true;
        if (this.formData.specs.length != 0) {
          flag = this.formData.specs[this.formData.specs.length - 1].name.replace(/(^s*)|(s*$)/g, '').length > 0;
        }
        if (!flag) {
          this.formData.specs.splice(this.formData.specs.length - 1, 1);
        }
        this.specInputShow = true;
        const spec = {
          name: '',
          code: '',
          key: Number(Math.random().toString().substr(3, 3) + Date.now()).toString(36)
        }
        this.formData.specs.push(spec);
      },
      removeSpec (spec) {
        const flag = this.formData.variants.some(val => {
          return val.spec.name == spec.name;
        })
        if (flag) {
          this.$message.error('此规格已被使用，若想删除请取消使用后继续操作');
          return;
        }
        const formIndex = this.formData.specs.indexOf(spec);
        if (formIndex === 0 && this.formData.specs.length === 1) {
          return;
        }
        this.$confirm('正在执行删除操作, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.formData.specs.splice(formIndex, 1);
          const selectIndex = this.selectSpecs.indexOf(spec);
          this.selectSpecs.splice(selectIndex, 1);
        });
      },
      editModel (model) {
        if (model.name.replace(/(^s*)|(s*$)/g, '').length > 0) {
          const index = this.selectModels.findIndex(item => item.key === model.key);
          if (index > -1) {
            this.selectModels[index].name = model.name;
            this.selectModels[index].code = null;
          } else {
            this.selectModels.push(model);
          }
        }
      },
      appendModel () {
        if (this.formData.models.length >= 30) {
          this.$message.error('支持尺寸已到达上限');
          return;
        }
        let flag = true;
        if (this.formData.models.length != 0) {
          flag = this.formData.models[this.formData.models.length - 1].name.replace(/(^s*)|(s*$)/g, '').length > 0;
        }
        if (!flag) {
          this.formData.models.splice(this.formData.models.length - 1, 1);
        }
        const model = {
          name: '',
          code: '',
          key: Number(Math.random().toString().substr(3, 3) + Date.now()).toString(36)
        }
        this.formData.models.push(model);
      },
      removeModel (model) {
        const flag = this.formData.variants.some(val => {
          return val.model.name == model.name;
        })
        if (flag) {
          this.$message.error('此尺寸已被使用，若想删除请取消使用后继续操作');
          return;
        }
        const formIndex = this.formData.models.indexOf(model);
        if (formIndex === 0 && this.formData.models.length === 1) {
          return;
        }
        this.$confirm('正在执行删除操作, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.formData.models.splice(formIndex, 1);
          const selectIndex = this.selectModels.indexOf(model);
          this.selectModels.splice(selectIndex, 1);
        });
      },
      onSubmit () {
        this.$refs['form'].validate(valid => {
          if (valid) {
            this._onSubmit();
          } else {
            this.$message.error('请完善表单信息');
          }
        });
      },
      async _onSubmit () {
        // const flag = this.$refs.materielForm.modifyFlag;
        // if (flag) {
        //   this.$message.error('请先保存正在编辑的信息');
        //   return;
        // }
        const arr = this.formData.variants.filter(val => val.spec == '' || val.color == '');
        if (arr.length > 0) {
          this.$message.error('请先为正在编辑的物料选择规格/颜色');
          return;
        }
        const formData = {
          id: this.formData.id != null ? this.formData.id : null,
          name: this.formData.name,
          code: this.formData.code,
          materialsType: this.formData.materialsType,
          materialsUnit: this.formData.materialsUnit,
          images: this.formData.images,
          colors: this.selectColors,
          specs: this.selectSpecs,
          variants: this.formData.variants
        }
        const url = this.apis().saveMaterials();
        const result = await this.$http.post(url, formData);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }

        this.$message.success(this.formData.id != null ? '编辑物料成功' : '创建物料成功');
        this.saveAndEdit = true;
        await this.$router.push({
          name: '物料管理'
        });
      },
      validateField (name) {
        this.$refs.form.validateField(name);
      },
      operationCount () {
        this.leaveCount++;
      },
      returnCount () {
        this.leaveCount = 0;
      }
    },
    data () {
      var checkImages = (rule, value, callback) => {
        if (value == null || value.length === 0) {
          return callback(new Error('请上传至少一张物料主图'));
        } else {
          callback();
        }
      };
      return {
        rules: {
          'name': [
            { required: true, message: '请输入物料标题', trigger: 'blur' }
          ],
          'materialsType': [
            { required: true, message: '请选择物料类型', trigger: 'change' }
          ],
          'materialsUnit': [
            { required: true, message: '请选择物料单位', trigger: 'change' }
          ],
          'images': [
            { validator: checkImages, type: 'object', trigger: 'blur' }
          ]
        },
        materialsType: this.$store.state.EnumsModule.MaterialsType,
        materialsUnit: this.$store.state.EnumsModule.MaterialsUnit,
        isCreate: true,
        formData: '',
        value: '',
        images: [],
        sizes: [],
        colors: [],
        selectColors: [],
        selectSizes: [],
        customColors: [],
        customSizes: [],
        colorSizeQualityMap: {},
        specInputShow: false,
        colorsMax: 30,
        codeSelect: 100,
        leaveCount: 0,
        saveAndEdit: false,
        selectSpecs: [],
        selectModels: []
      }
    },
    watch: {
      selectColors: function () {
        this.formData.colorSizes = this.getColorSizes();
      },
      'formData.images': function (n, o) {
        if (this.leaveCount <= 1) {
          return;
        }
        this.validateField('images');
      },
      formData: {
        handler (val) {
          if (val) {
            this.operationCount();
          }
        },
        deep: true
      }
    },
    created () {
      this.getAllColors();
      this.formData = this.$store.state.MaterialModule.formData;
      this.isCreate = this.$store.state.MaterialModule.isCreate;
      if (!this.isCreate) {
        this.selectSpecs = Object.assign([], this.formData.specs);
        this.formData.colors.forEach(val => {
          this.$set(val, 'key', val.code);
        })
        this.formData.specs.forEach(val => {
          this.$set(val, 'key', val.code);
        })
        this.formData.variants.forEach(val => {
          this.$set(val.color, 'key', val.color.code);
          this.$set(val.spec, 'key', val.spec.code);
        })
      }
      this.returnCount();
    },
    destroyed () {
      this.resetFormData();
    },
    beforeRouteLeave (to, from, next) {
      next(false);
      let flag = this.leaveCount > 1;

      if (flag && !this.saveAndEdit) {
        this.$confirm('是否离开此页面 , 更改内容将不会被保存', '提示', {
          confirmButtonText: '离开页面',
          cancelButtonText: '留在页面',
          type: 'warning',
          showClose: false,
          closeOnHashChange: false
        }).then(() => {
          next();
        }).catch(() => {
          throw new Error('取消成功！')
        })
      } else {
        next();
      }
    }
  }
</script>

<style scoped>
  .material-list-title {
    border-left: 2px solid #ffd60c;
    height: 18px;
    padding-left: 10px;
  }

  .pic-label {
    padding-left: 12px;
    padding-bottom: 30px;
  }

  .el-divider--horizontal{
    margin: 0px 0px 24px 12px;
  } 

  .basic-form-row {
    padding-left: 40px;
    /*margin-bottom: 20px;*/
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    /*margin-top: 5px; */
    width: 60px;
    font-size: 12px;
    font-weight: 500;
    padding-top: 9px;
  }

  .info-image-prepend {
    display: inline-block;
    margin: 0 5px;
    /* margin-top: 5px; */
    width: 60px;
    font-size: 12px;
    font-weight: 500;
    padding-bottom: 90px;
  }

  /deep/ .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  /deep/ .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .border-container{
    border: 1px solid #DCDFE6;
    padding:10px;
    background-color: #F5F5F5;
  }

  .border-container{
    border: 1px solid #DCDFE6;
    padding:10px;
  }

  .size-tag {
    width: 80px;
    /*margin-left: 0px;*/
  }

  .spec_text {
    padding-top: 16px;
    padding-right: 15px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }
</style>
