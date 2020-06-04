<template>
  <div class="material-bill-top">
    <el-row type="flex" class="material-bill-top">
      <el-col :span="8">
        <el-form-item label="物料来源：" label-width="80">
          <el-select v-model="formData.materialsForm">
            <el-option value="来源1" label="来源1"></el-option>
            <el-option value="来源2" label="来源2"></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="10">
        <el-form-item label="供应商：">
          <el-input style="width: 194px;" :disabled="true"></el-input>
          <el-button @click="selectSupplier" size="mini">点击选择</el-button>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item>
          <label class="el-form-item__label">结算方式：{{formData.payPlan.payPlanType}}</label>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row type="flex" class="material-bill-top">
      <el-col :span="23">
        <el-table border :header-cell-style="{'text-align':'center'}" :cell-style="{'text-align':'center'}">
          <el-table-column label=""></el-table-column>
          <el-table-column label="采购数"></el-table-column>
          <el-table-column label="采购单价"></el-table-column>
          <el-table-column label="采购总价"></el-table-column>
        </el-table>
      </el-col>
    </el-row>
    <el-row type="flex" class="material-bill-top">
      <el-col :span="8">
        <el-row type="flex" style="margin-top: 20px">
          <el-col>
            <el-form-item>
              <label class="el-form-item__label">物料品质要求：{{formData.materialsQuanlity}}</label>
            </el-form-item>
          </el-col>
          <el-col>
            <images-upload :slot-data="formData.reportList" :limit="1"/>
            <h6>上传检测报告</h6>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="16">
        <el-row type="flex" style="margin-top: 53px" align="middle">
          <el-col :span="2">
            <h6>完成进度</h6>
          </el-col>
          <el-col :span="22">
            <el-steps :active="2" align-center finish-status="success">
              <el-step v-for="(item, index) in stepStatuses" :title="item.name"></el-step>
            </el-steps>
          </el-col>
        </el-row>
        <el-row type="flex" style="margin-top: 10px" justify="center">
          <el-button size="mini" style="width: 70px;" @click="onSumbit">完成</el-button>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import ImagesUpload from '../../../../../components/custom/ImagesUpload';
  export default {
    name: 'MaterialsBillMiddle',
    components: {ImagesUpload},
    props: ['formData'],
    methods: {
      selectSupplier () {
        this.$emit('selectSupplier');
      },
      onSumbit () {
        this.$emit('onSumbit');
      }
    },
    data () {
      return {
        stepStatuses: [{
          code: '1',
          name: '未开始'
        }, {
          code: '2',
          name: '已下单'
        }, {
          code: '3',
          name: '生产中'
        }, {
          code: '4',
          name: '已发货'
        }, {
          code: '5',
          name: '验收入库'
        }]
      }
    }
  }
</script>

<style scoped>
  .material-bill-top {
    margin-left: 10px;
  }

  .material-bill-container {
    border: solid #DCDFE6 1px;
    border-radius: 5px;
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
</style>
