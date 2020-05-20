<template>
  <div>
    <el-row class="progress-row">
      <el-row>
        <el-col>
          <h6>生产信息</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="progress-basic-row">
        <el-col :span="6">
          <el-form-item label="产品名">
            <el-input :disabled="true"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-button>点击选择</el-button>
        </el-col>
      </el-row>
    </el-row>
    <el-row class="info-basic-row" type="flex">
      <el-col :span="2" :offset="2">
        <img width="60px" height="60px"
             :src="formData.product.thumbnail!=null && order.product.thumbnail.length != 0 ?
             formData.product.thumbnail.url : 'static/img/nopicture.png'">
        </img>
      </el-col>
      <!-- 商品color/size表 -->
      <el-col :span="20">
        <el-row>
          <el-table :data="showData" border  :span-method="arraySpanMethod"
                    :header-cell-style="{'text-align':'center'}"
                    :cell-style="{'text-align':'center'}">
            <el-table-column label="属性" prop="colorName"></el-table-column>
            <template v-for="(item, index) in formData.product.sizes">
              <el-table-column :label="item.name" :prop="item.code"></el-table-column>
            </template>
            <el-table-column label="合计" prop="colorQuantity"></el-table-column>
          </el-table>
        </el-row>
        <el-row type="flex" justify="center" align="center" class="info-basic-row">
          <i class="iconfont icon_arrow" v-if="!showTable" @click="onClickShowTable">&#xe714;&nbsp;展开列表</i>
          <i class="iconfont icon_arrow" v-if="showTable" @click="onClickShowTable">&#xe713;&nbsp;收回列表</i>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ProgressOrderProductionInfoForm',
    props: {
      formData: {
        type: Object
      },
      isRead: {
        type: Boolean,
        default: false
      }
    },
    methods: {
      // 构建color/size表数据
      initColorSizeData () {
        let row = {};
        let rowCount = 0;
        let tableCount = 0;
        this.formData.product.colorSizes.forEach(val => {
          row.colorName = val.colorName;
          val.sizes.forEach(item => {
            row[item.code] = item.quantity
            rowCount += item.quantity;
            tableCount += item.quantity;
          })
          row.colorQuantity = rowCount;
          this.colorSizeData.push(row);
          row = {};
          rowCount = 0;
        })
        this.colorSizeData.push({
          colorName: '总计',
          colorQuantity: tableCount
        })
        this.showData = [this.colorSizeData[0]];
      },
      // 展开/收起列表行
      onClickShowTable () {
        this.showTable = !this.showTable;
        if (this.showTable) {
          this.showData = this.colorSizeData;
          return;
        }
        this.showData = [this.colorSizeData[0]];
      },
      arraySpanMethod({ row, column, rowIndex, columnIndex }) {
        if (rowIndex == this.colorSizeData.length - 1) {
          const length = this.formData.product.sizes.length + 1;
          if (columnIndex === 0) {
            return [1, length];
          } else if (columnIndex != length) {
            return [0, 0];
          }
        }
      }
    },
    data () {
      return {
        showData: [],
        colorSizeData: [],
        showTable: false
      }
    },
    created () {
      this.initColorSizeData();
    }
  }
</script>

<style scoped>
  .progress-row {
    padding-left: 10px;
    margin-top: 20px;
  }

  .progress-basic-row {
    padding-left: 20px;
  }

  .icon_arrow {
    font-family: "iconfont" !important;
    font-size: 12px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    font-style: normal;
    -webkit-font-smoothing: antialiased;
    -webkit-text-stroke-width: 0.2px;
    -moz-osx-font-smoothing: grayscale;
    cursor: pointer;
  }

  .info-basic-row {
    margin-top: 10px;
  }

  /deep/ .el-table--enable-row-hover .el-table__body tr:hover > td {
    background-color: #FFFFFF !important;
  }
</style>
