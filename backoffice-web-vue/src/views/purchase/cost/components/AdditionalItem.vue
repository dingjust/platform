<!--
* @Description: 成本单附加项 -> 特殊工艺，加工费等
* @Date 2021/03/01 10:44
* @Author L.G.Y
-->
<template>
  <div>
    <el-row type="flex" justify="start">
      <h6 class="additional-title">附加项</h6>
    </el-row>
    <el-row type="flex" align="middle">
      <el-form ref="form" :model="formData" style="width: 100%">
        <el-table :data="formData.customRows" stripe>
          <el-table-column label="类别" prop="customCategoryName">
            <template slot-scope="scope">
              <el-form-item label="" :prop="'customRows.' + scope.$index + '.customCategoryName'" :rules="{required: false, message: '不能为空', trigger: 'blur'}">
                <el-input v-model="scope.row.customCategoryName"></el-input>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="名称" prop="name">
            <template slot-scope="scope">
              <el-form-item label="" :prop="'customRows.' + scope.$index + '.name'" :rules="{required: true, message: '不能为空', trigger: 'blur'}">
                <el-input v-model="scope.row.name"></el-input>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="单位" prop="unit">
            <template slot-scope="scope">
              <el-form-item label="" :prop="'customRows.' + scope.$index + '.unit'" :rules="{required: true, message: '不能为空', trigger: 'blur'}">
                <el-input v-model="scope.row.unit"></el-input>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="单价" prop="price">
            <template slot-scope="scope">
              <el-form-item label="" :prop="'customRows.' + scope.$index + '.price'" :rules="{required: true, message: '不能为空', trigger: 'blur'}">
                <el-input v-model="scope.row.price" placeholder="请输入" @blur="onBlur(scope.row,'price')"
                  v-number-input.float="{ decimal:2 }"></el-input>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="操作" min-width="60" width="60">
            <template slot-scope="scope">
              <el-button type="text" @click="onDelete(scope.$index)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-form>
    </el-row>
    <el-row type="flex" style="margin-top: 10px">
      <el-button @click="onAdd"> + 添加附加项</el-button>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'AdditionalItem',
  props: ['formData'],
  methods: {
    onAdd () {
      this.formData.customRows.push({
        name: '',
        code: '',
        unit: '',
        materialsType: '',
        customCategoryName: '',
        unitQuantity: '',
        specName: '',
        colorName: '',
        modelName: '',
        emptySent: '',
        requiredAmount: '',
        estimatedLoss: '',
        estimatedUsage: '',
        orderCount: '',
        auditColor: '',
        estimatedRecTime: '',
        cooperatorName: '',
        price: '',
        totalPrice: ''
      })
    },
    onDelete (index) {
      this.formData.customRows.splice(index, 1);
    },
    onBlur(row, attribute) {
      var reg = /\.$/;
      if (reg.test(row[attribute])) {
        this.$set(row, attribute, parseFloat(row[attribute] + '0'));
      }
    }
  }
}
</script>

<style scoped>
  .additional-title {
    font-size: 14px;
    color: #606266;
  }
</style>