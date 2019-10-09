<template>
  <div class="animated fadeIn factory-service">
      <el-row>
        <div class="titleClass">
          <h6>工厂服务</h6>
        </div>
      </el-row>
      <div style="margin: 20px 20px 40px 40px">
        <el-row type="flex" align="middle" :gutter="10">
          <el-col :span="8">
            <el-form-item>
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">免费打样</h6>
                <el-select v-model="formData.freeProofing" placeholder="请选择" size="mini">
                  <el-option
                    v-for="item in factoryFreeProofings"
                    :key="item.code"
                    :label="item.name"
                    :value="item.code">
                  </el-option>
                </el-select>
              </el-row>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item>
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">合作方式</h6>
                <el-select v-model="formData.cooperationModes" multiple placeholder="请选择" size="mini">
                  <el-option
                    v-for="item in cooperationModes"
                    :key="item.code"
                    :label="item.name"
                    :value="item.code">
                  </el-option>
                </el-select>
              </el-row>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item>
              <el-row type="flex" align="middle" >
                <h6 class="info-input-prepend">质量等级</h6>
                <el-select v-model="formData.qualityLevel" placeholder="请选择" size="mini">
                  <el-option
                    v-for="item in factoryQualityLevels"
                    :key="item.code"
                    :label="item.name"
                    :value="item.code">
                  </el-option>
                </el-select>
              </el-row>
            </el-form-item>
          </el-col>
        </el-row>
      </div>
  </div>
</template>

<script>
  export default {
    name: 'FactoryServiceForm',
    props: ['formData'],
    components: {},
    computed: {
    },
    methods: {
    },
    data () {
      return {
        factoryFreeProofings: this.$store.state.EnumsModule.FactoryFreeProofing,
        factoryServices: this.$store.state.EnumsModule.FactoryService,
        factoryQualityLevels: this.$store.state.EnumsModule.FactoryQualityLevel,
        cooperationModes: this.$store.state.EnumsModule.cooperationModes
      };
    },
    created () {
    }
  };
</script>

<style>
  .factory-service .rowClass{
    margin-top:20px;
  }

  .factory-service .titleClass{
    padding: 10px 0px 1px 10px;
    background-color: #DCDCDC;
  }

 .factory-service .factory-upload {
    margin-left: 80px;
  }

  .factory-service .factory-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .factory-service .factory-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .factory-service .info-input-prepend {
    display: inline-block;
    width: 70px;
    font-weight: bold;
    font-size: 10px;
  }

  .factory-service .el-input--mini .el-input__inner{
    width: 249px;
  }

</style>
