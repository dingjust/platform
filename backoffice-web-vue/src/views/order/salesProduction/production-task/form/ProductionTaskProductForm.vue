<template>
  <div class="animated fadeIn">
    <el-row class="basic-form-row_top" type="flex" align="middle">
      <h6 class="info-input-prepend_top" v-if="code==1">生产信息</h6>
      <h5 style="fontWeight: bold;" v-if="code==2">生产信息</h5>
    </el-row>
    <el-row type="flex" :gutter="20" justify="start">
      <el-col :span="8">
        <el-form-item label="产品名" label-width="80px">
          <el-input placeholder="系统自动生成" :disabled="true" size="mini"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="2">
        <el-button size="mini" style="margin-top: 2px" @click="appendSample">点击选择</el-button>
      </el-col>
    </el-row>
    <el-row class="basic-form-row" type="flex">
      <el-col :span="4">
        <images-upload-single :form-data="picture" :disabled="true"/>
      </el-col>
      <el-col :span="20">
        <el-table :data="formData" border style="width: 100%" show-summary :summary-method="getSummaries">
          <el-table-column prop="name" label="属性"></el-table-column>
          <template v-for="(item, index) in sizeList">
            <el-table-column :label="item" :prop="item"></el-table-column>
          </template>
          <el-table-column prop="sum" label="合计"></el-table-column>
        </el-table>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import ImagesUploadSingle from '../../../../../components/custom/ImagesUploadSingle';
  export default {
    name: 'ProductionTaskProductForm',
    components: {ImagesUploadSingle},
    props: ['code'],
    methods: {
      transformData () {
        let sum = 0;
        let flag = {};
        let index;
        this.tableData.forEach(val => {
          flag['name'] = val.name;
          val.size.forEach(item => {
            sum += item.quantity;
            flag[item.type] = item.quantity;
            index = this.sizeList.indexOf(item.type);
            if (index === -1) {
              this.sizeList.push(item.type);
            }
          })
          flag['sum'] = sum;
          this.formData.push(flag);
          sum = 0;
          flag = {};
        })
      },
      getSummaries (param) {
        const { columns, data } = param;
        const sums = [];
        columns.forEach((column, index) => {
          if (index === 0) {
            sums[index] = '总计';
            return;
          }
          var values;
          if (index === this.sizeList.length + 1) {
            values = data.map(item => item.sum)
          } else {
            sums[index] = '';
            return;
          }
          if (!values.every(value => isNaN(value))) {
            sums[index] = values.reduce((prev, curr) => {
              const value = Number(curr);
              if (!isNaN(value)) {
                return prev + curr;
              } else {
                return prev;
              }
            }, 0);
            sums[index] = sums[index];
            sums[index] += ' ';
          } else {
            sums[index] = '';
          }
        });

        return sums;
      },
      appendSample () {
        this.dialogVisible = true;
      }
    },
    data () {
      return {
        dialogVisible: false,
        sizeList: [],
        formData: [],
        sizeArr: [],
        picture: {},
        tableData: [{
          name: '白色',
          size: [{
            type: 'S',
            quantity: 11
          }, {
            type: 'L',
            quantity: 13
          }, {
            type: 'XL',
            quantity: 14
          }]
        }, {
          name: '红色',
          size: [{
            type: 'S',
            quantity: 22
          }, {
            type: 'M',
            quantity: 23
          }, {
            type: 'L',
            quantity: 24
          }, {
            type: 'XL',
            quantity: 25
          }]
        }, {
          name: '蓝色',
          size: [{
            type: 'S',
            quantity: 33
          }, {
            type: 'M',
            quantity: 34
          }, {
            type: 'L',
            quantity: 35
          }, {
            type: 'XL',
            quantity: 36
          }]
        }]
      }
    },
    created () {
      this.transformData();
    }
  }
</script>

<style scoped>
  .basic-form-row_top {
    padding-left: 8px;
    margin-bottom: 10px;
  }
  .basic-form-row {
    padding-left: 25px;
    margin-bottom: 10px;
  }

  .info-input-prepend_top {
    display: inline-block;
    margin: 0 5px;
    /*margin-top: 5px; */
    width: 60px;
    font-size: 14px;
    font-weight: 500;
    padding-top: 2px;
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

  /deep/ .el-table tbody tr:hover>td {
    background-color:#FFFFFF!important
  }

  /deep/ .el-table__footer-wrapper tbody td, .el-table__header-wrapper tbody td {
    background-color:#FFFFFF!important
  }
</style>
