<template>
  <div class="app-container">
    <upload-excel-component :on-success="handleSuccess" :before-upload="beforeUpload" />
    <el-table :data="tableData" border highlight-current-row style="width: 100%;margin-top:20px;">
      <el-table-column label="产品主图">
        <template slot-scope="scope">
          <images-upload class="product-images-form-upload" :slot-data="scope.row.images" :limit="5"
            :ref="'imgUp'+scope.$index" :key="'img'+scope.$index" />
        </template>
      </el-table-column>
      <!-- <el-table-column v-for="item of tableHeader" :key="item" :prop="item" :label="item" /> -->
      <el-table-column label="标题*" prop="标题*">
        <template slot-scope="scope">
          <el-row type="flex">
            <span>{{scope.row['标题*']}}</span>
            <i class="el-icon-error row-icon" v-if="scope.row['标题*']==null||scope.row['标题*']==''"></i>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="款号*" prop="款号*">
        <template slot-scope="scope">
          <el-row type="flex">
            <span>{{scope.row['款号*']}}</span>
            <i class="el-icon-error row-icon" v-if="scope.row['款号*']==null||scope.row['款号*']==''"></i>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="主品类*" prop="主品类*">
        <template slot-scope="scope">
          <el-row type="flex">
            <span>{{scope.row['主品类*']}}</span>
            <i class="el-icon-error row-icon" v-if="scope.row['主品类*']==null||scope.row['主品类*']==''"></i>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="子品类*" prop="子品类*">
        <template slot-scope="scope">
          <el-row type="flex">
            <span>{{scope.row['子品类*']}}</span>
            <i class="el-icon-error row-icon" v-if="submitData[scope.$index].category.code==null"></i>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="颜色*" prop="颜色*">
        <template slot-scope="scope">
          <el-row type="flex">
            <span>{{scope.row['颜色*']}}</span>
            <i class="el-icon-error row-icon" v-if="scope.row['颜色*']==null||scope.row['颜色*']==''"></i>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="尺码*" prop="尺码*">
        <template slot-scope="scope">
          <el-row type="flex">
            <span>{{scope.row['尺码*']}}</span>
            <i class="el-icon-error row-icon" v-if="scope.row['尺码*']==null||scope.row['尺码*']==''"></i>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <el-row type="flex" justify="center" style="margin-top:20px">
      <el-button @click="onCreate" class="material-btn">导入</el-button>
    </el-row>
  </div>
</template>

<script>
  import {
    UploadExcelComponent,
    ImagesUpload,
  } from '@/components/'

  import {
    getSizeCode,
    getColorCode,
    getCategoryCodeByCascadedName
  } from '@/store/modules/shared'

  export default {
    name: 'ProductImport',
    components: {
      UploadExcelComponent,
      ImagesUpload
    },
    computed: {
      submitData: function () {
        //解析提交数据
        return this.tableData.map(row => {
          let colorSizes = this.generateColorSizes(row['颜色*'], row['尺码*']);
          let category = getCategoryCodeByCascadedName(row['主品类*'], row['子品类*']);
          return {
            'images': row.images,
            'skuID': row['款号*'],
            'name': row['标题*'],
            'colorSizes': colorSizes,
            'category': {
              code: category
            }
          }
        });
      }
    },
    data() {
      return {
        tableData: [],
        tableHeader: [],
      }
    },
    methods: {
      beforeUpload(file) {
        const isLt1M = file.size / 1024 / 1024 < 5

        if (isLt1M) {
          return true
        }
        this.$message({
          message: '文件限制大小5M',
          type: 'warning'
        })
        return false
      },
      handleSuccess({
        results,
        header
      }) {
        console.log(results);
        console.log(header);
        let data = results.filter(row => {
            //过滤案例行和注明行
            let col1 = row[header[0]];
            if (col1 != null && col1 != "") {
              col1=col1.toString();
              return !(col1.includes('案例：') || col1.includes('注明：'));
            }
            return true;
          })
          .map(row => {
            let obj = Object.assign({}, row);
            obj['images'] = [];
            return obj;
          });
        this.$set(this, 'tableData', data);
        this.tableHeader = header;
      },
      //解析生成colorSizes数据
      generateColorSizes(colorStr, sizesStr) { //尺码处理
        let sizeStrArray = [];
        let colorStrArray = [];
        if (sizesStr != null) {
          sizeStrArray = sizesStr.split('/');
          sizeStrArray = sizeStrArray.map(str => {
            let code = getSizeCode(str);
            if (code != null) {
              return {
                code: code,
                name: str
              };
            }
            return {
              name: str.toUpperCase()
            };
          });
        }
        if (colorStr != null) { //颜色处理
          colorStrArray = colorStr.split('/');
          colorStrArray = colorStrArray.map(str => {
            let code = getColorCode(str);
            if (code != null) {
              return {
                colorCode: code,
                colorName: str,
                sizes: sizeStrArray
              };
            }
            return {
              colorName: str,
              sizes: sizeStrArray
            };
          });
        }
        return colorStrArray;
      },
      onCreate() {
        //校验是否有正在上传图片
        for (let i = 0; i < this.tableData.length; i++) {
          let refs = 'imgUp' + i;
          if (this.$refs[refs].isUploading()) {
            this.$message.warning('图片正在上传，请稍后再试！');
            break;
            return false;
          }
        }
        //校验表单数据
        this.submitData.forEach(item => {
          if (item.images == null || item.images.length < 1) {
            this.$message.error('请上传产品主图');
            throw Error('缺少图片');
            return false;
          }
          if (item.category.code == null || item.skuID == null || item.name == null || item.colorSizes.length ==
            0) {
            this.$message.error('表格数据有误，请修改表格后再上传');
            throw Error('表格数据有误，请修改表格后再上传');
            return false;
          }
        });
        this._Create();
      },
      async _Create() {
        const url = this.apis().muliteClothesCreate();
        const result = await this.$http.post(url, this.submitData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result['code'] == 1) {
          //统计成功个数
          let num = 0;
          for (let i = 0; i < result.data.length; i++) {
            if (result.data[i]) {
              num++;
            }
          }
          this.$message.success('共导入' + num + '个产品');
          this.$emit('onSuccess');
        }
      },
    }
  }

</script>
<style scoped>
  .product-images-form-upload>>>.el-upload--picture-card {
    width: 50px;
    height: 50px;
    line-height: 50px;
  }

  .product-images-form-upload>>>.el-upload-list--picture-card .el-upload-list__item {
    width: 50px;
    height: 50px;
  }

  .product-images-form-upload>>>.el-upload--picture-card i {
    margin-top: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  .row-icon {
    font-size: 15px;
    color: #ff1744;
    margin-top: 5px;
  }

</style>
