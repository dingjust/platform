<template>
  <div class="animated fadeIn factory-scale-form">
    <el-row>
      <div class="titleClass">
        <h6>工厂规模</h6>
      </div>
    </el-row>
    <div style="margin: 20px 20px 40px 40px">
      <el-row class="info-row" type="flex" justify="start" align="bottom" :gutter="30">
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">工厂人数</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <h6 class="info-data">{{getEnum('populationScales',formData.populationScale)}}</h6>
        </el-col>
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">厂房面积</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <h6 class="info-data">{{formData.factoryBuildingsQuantity}}<span slot="append">m&sup2</span>
          </h6>
        </el-col>
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">产值规模</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <h6 class="info-data">{{getEnum('scaleRanges',formData.scaleRange)}}</h6>
        </el-col>
      </el-row>
      <el-row class="info-row" type="flex" justify="start" align="bottom" :gutter="30">
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">产线数量</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <h6 class="info-data">{{formData.productionLineQuantity}}</h6>
        </el-col>
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">生产模式</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <h6 class="info-data">{{getEnum('ProductionModes',formData.productionMode)}}
          </h6>
        </el-col>
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">月均产能</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <h6 class="info-data">{{getEnum('monthlyCapacityRanges',formData.monthlyCapacityRange)}}</h6>
        </el-col>
      </el-row>
      <el-row class="info-row" type="flex" justify="start" :gutter="30">
        <el-col :span="2">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">拥有设备<span style="color: red">*</span></h6>
          </el-row>
        </el-col>
        <el-col :span="18">
          <template v-for="(values, key) in mapData">
            <template v-if="mapSelectData[key].length>0">
              <el-row type="flex" align="middle" style="padding-top:10px" :key="key">
                <el-badge :value="mapSelectData[key].length" class="item">
                  <h6>{{key}}</h6>
                </el-badge>
              </el-row>
              <el-divider :key="key"></el-divider>
              <template v-for="val of values">
                <el-tag v-if="mapSelectData[key].indexOf(val.code)>-1" class="elTagClass" color="#FFD60C" size="medium"
                  style="color:black;" :key="val.code">
                  {{val.name}}
                </el-tag>
              </template>
            </template>
          </template>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters
  } = createNamespacedHelpers('FactoriesModule');

  import EnumSelect from '../../../../../components/custom/EnumSelect';
  export default {
    name: 'FactoryScale',
    props: ['formData'],
    components: {
      EnumSelect
    },
    methods: {

    },
    data() {
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
          '裁剪部': this.formData.cuttingDepartment == null ? [] : this.formData.cuttingDepartment,
          '生产车间': this.formData.productionWorkshop == null ? [] : this.formData.productionWorkshop,
          '尾部': this.formData.lastDepartment == null ? [] : this.formData.lastDepartment
        }
      };
    },
    watch: {

    },
    created() {

    }
  };

</script>

<style>
  .factory-scale-form .rowClass {
    margin-top: 20px;
  }

  .factory-scale-form .titleClass {
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

  .factory-scale-form .titleTextClass {
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-size: 12px;
    /*font-weight: bold;*/
  }

  .factory-scale-form .el-input--mini .el-input__inner {
    width: 100%;
  }

  .info-data {
    font-size: 12px;
    padding-top: 5px;
    /* padding-bottom: 2px; */
  }

  .info-row {
    margin-bottom: 10px;
  }

</style>
