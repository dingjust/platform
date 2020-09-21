<template>
  <div class="app-container">
    <upload-excel-component :on-success="handleSuccess" :before-upload="beforeUpload" />
    <el-table :data="tableData" border highlight-current-row style="width: 100%;margin-top:20px;">
      <el-table-column label="物料编号">
        <template slot="header">
          <span>物料编号<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['物料编号*']">{{scope.row['物料编号*']}}</span>
          <i v-else class="el-icon-error row-icon"></i>
        </template>
      </el-table-column>
      <el-table-column label="物料名称">
        <template slot="header">
          <span>物料名称<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['物料名称*']">{{scope.row['物料名称*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="物料类别">
        <template slot="header">
          <span>物料类别<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['物料类别*']">{{scope.row['物料类别*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="幅宽/型号">
        <template slot="header">
          <span>幅宽/型号<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['幅宽/型号*']">{{scope.row['幅宽/型号*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="克重/规格">
        <template slot-scope="scope">
          <span>{{scope.row['克重/规格']}}</span>
        </template>
      </el-table-column>
      <el-table-column label="物料单位">
        <template slot="header">
          <span>物料单位<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['物料单位*']">{{scope.row['物料单位*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="物料颜色">
        <template slot="header">
          <span>物料颜色<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['物料颜色*']">{{scope.row['物料颜色*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="单件用量">
        <template slot="header">
          <span>单件用量<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['单件用量*']">{{scope.row['单件用量*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="损耗">
        <template slot="header">
          <span>损耗<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['损耗*']">{{scope.row['损耗*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="预计用量">
        <template slot="header">
          <span>预计用量<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['预计用量*']">{{scope.row['预计用量*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="空差">
        <template slot="header">
          <span>空差<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['空差*']">{{scope.row['空差*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="订单数">
        <template slot="header">
          <span>订单数<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['订单数*']">{{scope.row['订单数*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="需求总量">
        <template slot="header">
          <span>需求总量<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['需求总量*']">{{scope.row['需求总量*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="供应商">
        <template slot-scope="scope">
          <span>{{scope.row['供应商']}}</span>
        </template>
      </el-table-column>
      <el-table-column label="物料单价">
        <template slot="header">
          <span>物料单价<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['物料单价*']">{{scope.row['物料单价*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="总金额">
        <template slot="header">
          <span>总金额<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['总金额*']">{{scope.row['总金额*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="到料时间">
        <template slot="header">
          <span>到料时间<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['到料时间*']">{{scope.row['到料时间*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="是否批色">
        <template slot-scope="scope">
          <span>{{scope.row['是否批色']}}</span>
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
  } from '@/components/'

  export default {
    name: 'MaterialsImport',
    components: {
      UploadExcelComponent,
    },
    data() {
      return {
        tableData: [],
        tableHeader: [],
      }
    },
    computed: {
      sumbitData: function () {
        return this.tableData.map(row => {
          return {
            name: row['物料名称*'],
            code: row['物料编号*'],
            materialsType: row['物料类别*'],
            modelName: row['幅宽/型号*'],
            specName: row['克重/规格'],
            unit: row['物料单位*'],
            colorName: row['物料颜色*'],
            unitQuantity: row['单件用量*'],
            estimatedLoss: row['损耗*'],
            estimatedUsage: row['预计用量*'],
            emptySent: row['空差*'],
            orderCount: row['订单数*'],
            requiredAmount: row['需求总量*'],
            cooperatorName: row['供应商'],
            price: row['物料单价*'],
            totalPrice: row['总金额*'],
            estimatedRecTime: new Date(row['到料时间*'].replace(/-|\./g, '/')).getTime(),
            auditColor: row['是否批色'].trim() === '是'
          }
        })
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
      handleSuccess({ results, header }) {
        let data = results.filter(row => {
          for (let key in row) {
            if (row[key]) {
              return true;
            }
          }
          return false;
        });
        let temp = data.shift();
        let item = {};
        let tableD = [];
        data.map(row => {
          for (let key in temp) {
            if (temp[key]) {
              item[temp[key]] = row[key];
            }
          }
          tableD.push(item);
          item = {};
        })
        this.$set(this, 'tableData', tableD);
        this.tableHeader = header;
      },
      onCreate () {
        this.tableData.forEach(row => {
          for (let key in row) {
            if (!row[key] && key !== '是否批色' && key !== '合作商' && key !== '克重/规格') {
              this.$message.error('表格数据有误，请修改表格后再上传');
              throw Error('表格数据有误，请修改表格后再上传');
              return;
            }
          }
        })
        this.$emit('onImport', this.sumbitData);
      }
    }
  }

</script>
<style scoped>
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
