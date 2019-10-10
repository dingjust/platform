<template>
  <div class="animated fadeIn factory-scale">
        <el-row>
          <div class="titleClass">
            <h6>工厂规模</h6>
          </div>
        </el-row>
        <div style="margin: 20px 20px 40px 40px">
          <el-row type="flex" align="middle" :gutter="10">
            <el-col :span="8">
              <el-form-item>
                <el-row type="flex" align="middle">
                  <el-col :span="6">
                    <h6 class="info-select-prepend">工厂人数</h6>
                  </el-col>
                  <el-col :span="18">
                    <el-select v-model="formData.populationScale" placeholder="请选择" size="mini">
                      <el-option
                        v-for="item in populationScales"
                        :key="item.code"
                        :label="item.name"
                        :value="item.code">
                      </el-option>
                    </el-select>
                  </el-col>
                </el-row>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item>
                <el-row type="flex" align="middle">
                  <el-col :span="6">
                    <h6 class="info-input-prepend">厂房数量</h6>
                  </el-col>
                  <el-col :span="18">
                    <el-input placeholder="请填写厂房数量"
                              v-model.number="formData.factoryBuildingsQuantity"
                              size="mini">
                    </el-input>
                  </el-col>
                  <el-col :span="2">
                    <span>m<sup>2</sup></span>
                  </el-col>
                </el-row>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item>
                <el-row type="flex" align="middle" >
                  <el-col :span="6">
                    <h6 class="info-select-prepend">产值规模</h6>
                  </el-col>
                  <el-col :span="18">
                    <el-select v-model="formData.scaleRange" placeholder="请选择" size="mini">
                      <el-option
                        v-for="item in scaleRanges"
                        :key="item.code"
                        :label="item.name"
                        :value="item.code">
                      </el-option>
                    </el-select>
                    <span>元</span>
                  </el-col>
                </el-row>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex" align="middle"  :gutter="10">
            <el-col :span="8">
              <el-form-item>
                <el-row type="flex" align="middle">
                  <el-col :span="6">
                    <h6 class="info-input-prepend">产线数量</h6>
                  </el-col>
                  <el-col :span="17">
                    <el-input placeholder="请填写产线数量" v-model.number="formData.productionLineQuantity" size="mini"></el-input>
                  </el-col>
                  <el-col :span="1">
                    <span>条</span>
                  </el-col>
                </el-row>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item>
                <el-row type="flex" align="middle">
                  <el-col :span="6">
                    <h6 class="info-select-prepend">生产模式</h6>
                  </el-col>
                  <el-col :span="18">
                    <el-select v-model="formData.productionMode" placeholder="请选择" size="mini">
                      <el-option
                        v-for="item in productionModes"
                        :key="item.code"
                        :label="item.name"
                        :value="item.code">
                      </el-option>
                    </el-select>
                  </el-col>
                </el-row>
              </el-form-item>
            </el-col>
          </el-row>
          <el-form-item>
            <el-row type="flex">
              <el-col :span="2">
                <h6 class="info-input-prepend">拥有设备<span style="color: red">*</span></h6>
              </el-col>
              <el-col :span="22">
                <enum-select  v-if="factoryFormVisible" :mapData="mapData" :mapSelectData="mapSelectData"></enum-select>
              </el-col>
            </el-row>
          </el-form-item>
        </div>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters} = createNamespacedHelpers('FactoriesModule');

  import EnumSelect from "../../../../../components/custom/EnumSelect";
  export default {
    name: 'FactoryScaleForm',
    props: ['formData'],
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
        mapData: {
          '裁剪部': this.$store.state.EnumsModule.CuttingDepartment,
          '生产车间': this.$store.state.EnumsModule.ProductionWorkshop,
          '尾部': this.$store.state.EnumsModule.LastDepartment
        },
        mapSelectData: {
          '裁剪部': this.formData.cuttingDepartment == null ? [] : this.formData.cuttingDepartment,
          '生产车间': this.formData.productionWorkshop == null ? [] : this.formData.productionWorkshop,
          '尾部': this.formData.lastDepartment == null ? [] : this.formData.lastDepartment
        },
      };
    },
    watch: {
      'formData.cuttingDepartment': function (n, o) {
        this.mapSelectData.裁剪部 = n;
      },
      'formData.productionWorkshop': function (n, o) {
        this.mapSelectData.生产车间 = n;
      },
      'formData.lastDepartment': function (n, o) {
        this.mapSelectData.尾部 = n;
      },
      'mapSelectData.裁剪部': function (n, o) {
        this.formData.cuttingDepartment = n;
      },
      'mapSelectData.生产车间': function (n, o) {
        this.formData.productionWorkshop = n;
      },
      'mapSelectData.尾部': function (n, o) {
        this.formData.lastDepartment = n;
      },
    },
    created () {
    }
  };
</script>

<style>
  .factory-scale .rowClass{
    margin-top:20px;
  }

  .factory-scale .titleClass{
    padding: 10px 0px 1px 10px;
    background-color: #DCDCDC;
  }

 .factory-scale .factory-upload {
    margin-left: 80px;
  }

  .factory-scale .factory-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .factory-scale .factory-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .factory-scale .info-input-prepend {
    display: inline-block;
    width: 88px;
    font-weight: bold;
    font-size: 10px;
  }

  .factory-scale .info-select-prepend {
    display: inline-block;
    width: 60px;
    font-weight: bold;
    font-size: 10px;
  }

  .factory-scale .el-input--mini .el-input__inner{
    width: 100%;
  }

</style>
