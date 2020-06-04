<template>
  <div class="material-bill-top">
    <el-row type="flex" class="material-bill-top">
      <el-col :span="6">
        <label class="el-form-item__label">关联单号：{{formData.orderCode}}</label>
      </el-col>
      <el-col :span="6">
        <label class="el-form-item__label">关联款号：{{formData.skuID}}</label>
      </el-col>
      <el-col :span="6">
        <label class="el-form-item__label">对应采购单：{{formData.purchaseOrderCode}}</label>
      </el-col>
      <el-col :span="6">
        <label class="el-form-item__label">完成时间：{{formData.completionTime | timestampToTime}}</label>
      </el-col>
    </el-row>
    <div class="material-bill-container">
      <el-row type="flex" class="material-bill-top">
        <el-col :span="5">
          <label class="el-form-item__label">物料编号：{{formData.materialsCode}}</label>
        </el-col>
        <el-col :span="5">
          <label class="el-form-item__label">物料名称：{{formData.materialsName}}</label>
        </el-col>
        <el-col :span="5">
          <label class="el-form-item__label">规格：{{formData.spec.name}}</label>
        </el-col>
        <el-col :span="5">
          <label class="el-form-item__label">单位：{{getEnum('MaterialsUnit', formData.materialsUnit)}}</label>
        </el-col>
        <el-col :span="5">
          <label class="el-form-item__label">物料属性：{{getEnum('MaterialsType', formData.materialsType)}}</label>
        </el-col>
      </el-row>
      <el-row type="flex" class="material-bill-top">
        <el-col :span="5">
          <label class="el-form-item__label">是否含税：{{formData.taxIncluded ? '是' : '否'}}</label>
        </el-col>
        <el-col :span="5">
          <label class="el-form-item__label">单位用量：{{formData.unitQuantity}}</label>
        </el-col>
        <el-col :span="5">
          <label class="el-form-item__label">损耗：{{formData.lossRate}}</label>
        </el-col>
        <el-col :span="5">
          <label class="el-form-item__label">单位实际用量：{{formData.realityQuantity}}</label>
        </el-col>
        <el-col :span="5">
          <label class="el-form-item__label">完成时间：{{formData.completionTime | timestampToTime}}</label>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'MaterialsBillTop',
    props: ['formData']
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
</style>
