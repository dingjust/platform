<template>
  <div class="animated fadeIn factory-scale-form">
        <el-row>
          <div class="titleClass">
            <h6>工厂规模</h6>
          </div>
        </el-row>
        <div style="margin: 20px 20px 40px 40px">
          <el-row type="flex" align="middle" :gutter="20">
            <el-col :span="8">
              <el-form-item prop="populationScale">
                <template slot="label">
                  <h6 class="titleTextClass">工厂人数<span style="color: red">*</span></h6>
                </template>
                <el-select v-model="formData.populationScale" placeholder="请选择" size="mini" style="width: 100%;">
                  <el-option
                    v-for="item in populationScales"
                    :key="item.code"
                    :label="item.name"
                    :value="item.code">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item prop="factoryBuildingsQuantity">
                <template slot="label">
                  <h6 class="titleTextClass">厂房面积</h6>
                </template>
                <el-row type="flex">
                  <el-input style="margin-top: 2px" placeholder="请填写厂房面积" type="text"
                            v-model.number="formData.factoryBuildingsQuantity"
                            size="mini">
                    <span slot="append">m&sup2</span>
                  </el-input>
<!--                  <span>m<sup>2</sup></span>-->
                </el-row>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item prop="scaleRange">
                <template slot="label">
                  <h6 class="titleTextClass">产值规模</h6>
                </template>
                <el-row type="flex">
                  <el-select v-model="formData.scaleRange" placeholder="请选择" size="mini" style="width: 100%;">
<!--                    <template slot = "prefix">-->
<!--                      <span style="margin-left: 100%">元</span>-->
<!--                    </template>-->
                    <el-option
                      v-for="item in scaleRanges"
                      :key="item.code"
                      :label="item.name"
                      :value="item.code">
                    </el-option>
                  </el-select>
<!--                  <span>元</span>-->
                </el-row>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex" align="middle"  :gutter="20">
            <el-col :span="8">
              <el-form-item prop="productionLineQuantity">
                <template slot="label">
                  <h6 class="titleTextClass">产线数量</h6>
                </template>
                <el-row type="flex">
                  <el-input placeholder="请填写产线数量" v-model.number="formData.productionLineQuantity" size="mini"><span slot="append">条</span></el-input>
                </el-row>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item prop="productionMode">
                <template slot="label">
                  <h6 class="titleTextClass">生产模式</h6>
                </template>
                <el-select v-model="formData.productionMode" placeholder="请选择" size="mini" style="width: 100%;">
                  <el-option
                    v-for="item in productionModes"
                    :key="item.code"
                    :label="item.name"
                    :value="item.code">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item>
                <template slot="label">
                  <h6 class="titleTextClass">月均产能</h6>
                </template>
                <el-select v-model="formData.monthlyCapacityRange" placeholder="请选择" size="mini" style="width: 100%;">
                  <el-option v-for="item in monthlyCapacityRanges" :key="item.code" :label="item.name"
                             :value="item.code"></el-option>
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>
          <el-form-item prop="equipment">
            <template slot="label">
              <h6 class="titleTextClass">拥有设备<span style="color: red">*</span></h6>
            </template>
            <enum-select v-if="factoryFormVisible" :mapData="mapData" :mapSelectData="mapSelectData" :readOnly="readOnly"></enum-select>
          </el-form-item>
        </div>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters} = createNamespacedHelpers('FactoriesModule');

  import EnumSelect from '../../../../../components/custom/EnumSelect';
  export default {
    name: 'FactoryScaleForm',
    props: ['formData', 'readOnly'],
    components: {EnumSelect},
    computed: {
      ...mapGetters({
        factoryFormVisible: 'factoryFormVisible'
      })
    },
    methods: {
    },
    data () {
      return {
        populationScales: this.$store.state.EnumsModule.populationScales,
        scaleRanges: this.$store.state.EnumsModule.scaleRanges,
        productionModes: this.$store.state.EnumsModule.ProductionModes,
        factoryPatterns: this.$store.state.EnumsModule.FactoryPattern,
        monthlyCapacityRanges: this.$store.state.EnumsModule.monthlyCapacityRanges,
        mapData: {
          '裁剪部': this.$store.state.EnumsModule.CuttingDepartment,
          '生产车间': this.$store.state.EnumsModule.ProductionWorkshop,
          '尾部': this.$store.state.EnumsModule.LastDepartment
        },
        mapSelectData: {
          '裁剪部': (this.formData.cuttingDepartment == null || this.formData.cuttingDepartment === undefined) ? [] : this.formData.cuttingDepartment,
          '生产车间': (this.formData.productionWorkshop == null || this.formData.productionWorkshop === undefined) ? [] : this.formData.productionWorkshop,
          '尾部': (this.formData.lastDepartment == null || this.formData.lastDepartment === undefined) ? [] : this.formData.lastDepartment
        }
      };
    },
    watch: {
      'formData.cuttingDepartment': function (n, o) {
        console.log(n);
        if (n === null || n === undefined) {
          this.mapSelectData.裁剪部 = [];
        }else {
          this.mapSelectData.裁剪部 = n;
        }

        this.$emit('validateField', 'equipment');
      },
      'formData.productionWorkshop': function (n, o) {
        if (n === null || n === undefined) {
          this.mapSelectData.生产车间 = [];
        } else {
          this.mapSelectData.生产车间 = n;
        }

        this.$emit('validateField', 'equipment');
      },
      'formData.lastDepartment': function (n, o) {
        if (n === null || n === undefined) {
          this.mapSelectData.尾部 = [];
        } else {
          this.mapSelectData.尾部 = n;
        }

        this.$emit('validateField', 'equipment');
      },
      'mapSelectData.裁剪部': function (n, o) {
        console.log(n);
        if (n === null || n === undefined) {
          this.formData.cuttingDepartment = [];
        } else {
          this.formData.cuttingDepartment = n;
        }
      },
      'mapSelectData.生产车间': function (n, o) {
        if (n === null || n === undefined) {
          this.formData.productionWorkshop = [];
        } else {
          this.formData.productionWorkshop = n;
        }
      },
      'mapSelectData.尾部': function (n, o) {
        if (n === null || n === undefined) {
          this.formData.lastDepartment = [];
        } else {
          this.formData.lastDepartment = n;
        }
      }
    },
    created () {
    }
  };
</script>

<style>
  .factory-scale-form .rowClass{
    margin-top:20px;
  }

  .factory-scale-form .titleClass{
    padding: 10px 0px 1px 10px;
    background-color: #DCDCDC;
  }

 .factory-scale-form .factory-upload {
    margin-left: 80px;
  }

  .factory-scale-form .factory-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .factory-scale-form .factory-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .factory-scale-form .info-input-prepend {
    display: inline-block;
    width: 88px;
    font-weight: bold;
    font-size: 10px;
  }

  .factory-scale-form .info-select-prepend {
    display: inline-block;
    width: 60px;
    font-weight: bold;
    font-size: 10px;
  }

  .factory-scale-form .titleTextClass{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-size: 12px;
    /*font-weight: bold;*/
  }

  .factory-scale-form .el-input--mini .el-input__inner{
    width: 100%;
  }

</style>
