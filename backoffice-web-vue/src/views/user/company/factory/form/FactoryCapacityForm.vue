<template>
  <div class="animated fadeIn factory-capacity">
        <el-row>
          <div class="titleClass">
            <h6>工厂能力</h6>
          </div>
        </el-row>
        <div style="margin: 20px 20px 40px 40px">
          <el-row type="flex" align="middle" :gutter="10">
            <el-col :span="8">
              <el-form-item>
                <el-row type="flex" align="middle">
                  <h6 class="info-input-prepend">设计</h6>
                  <el-select v-model="formData.design" @change="$forceUpdate()" size="mini" placeholder="请选择">
                    <el-option
                      v-for="item in factoryDesigns"
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
                  <h6 class="info-input-prepend">打板</h6>
                  <el-select v-model="formData.pattern" @change="$forceUpdate()" size="mini" placeholder="请选择">
                    <el-option
                      v-for="item in factoryPatterns"
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
                  <h6 class="info-input-prepend">覆盖范围</h6>
                  <el-input placeholder="请填写覆盖范围" v-model="formData.coverageArea" size="mini"></el-input>
                </el-row>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-form-item>
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">合作商</h6>
                <el-input placeholder="请填写合作商" v-model="formData.cooperativeBrand" size="mini"></el-input>
              </el-row>
            </el-form-item>
          </el-row>
            <el-form-item>
              <el-row type="flex">
                <el-col :span="2">
                  <h6 class="info-input-prepend">选择品类<span style="color: red">*</span></h6>
                </el-col>
                <el-col :span="22">
                  <!--<enum-select :mapData="mapData" :mapSelectData="mapSelectData"></enum-select>-->
                  <category-select :listData="categories" :selectDatas="formData.adeptAtCategories"></category-select>
                </el-col>
              </el-row>
            </el-form-item>
        </div>
  </div>
</template>

<script>
  import CategorySelect from "../../../../../components/custom/CategorySelect";
  export default {
    name: 'FactoryCapacityForm',
    props: ['formData'],
    components: {CategorySelect},
    computed: {
    },
    methods: {
      async getCategories () {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.categories = result;
      }
    },
    data () {
      return {
        categories: [],
        factoryDesigns: this.$store.state.EnumsModule.FactoryDesign,
        factoryPatterns: this.$store.state.EnumsModule.FactoryPattern,
      };
    },
    created () {
      this.getCategories()
    }
  };
</script>

<style>
  .factory-capacity .rowClass{
    margin-top:20px;
  }

  .factory-capacity .titleClass{
    padding: 10px 0px 1px 10px;
    background-color: #DCDCDC;
  }

 .factory-capacity .factory-upload {
    margin-left: 80px;
  }

  .factory-capacity .factory-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .factory-capacity .factory-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .factory-capacity .info-input-prepend {
    display: inline-block;
    width: 70px;
    font-weight: bold;
    font-size: 10px;
  }

  .factory-capacity .el-input--mini .el-input__inner{
    width: 255px;
  }

</style>
