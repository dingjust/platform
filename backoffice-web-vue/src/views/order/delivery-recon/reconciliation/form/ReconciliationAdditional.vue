<!--
* @Description: 新对账单表单-> 备注以及对添加扣款项
* @Date 2021/03/04 16:22
* @Author L.G.Y
-->
<template>
  <div>
    <el-row type="flex" style="margin-top: 10px;">
      <h6 class="title-text">附加项</h6>
    </el-row>
    <el-row type="flex" style="margin-left: 23px;">
      <el-table :data="formData.additionalCharges">
        <el-table-column label="名称">
          <template slot-scope="scope">
            <el-form-item :prop="'additionalCharges.' + scope.$index + '.remarks'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-input v-model="scope.row.remarks"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="金额">
          <template slot-scope="scope">
            <el-form-item :prop="'additionalCharges.' + scope.$index + '.amount'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-input v-model="scope.row.amount"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button type="text" @click="onDelete(scope.$index)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-row>
    <el-row type="flex" style="margin: 5px 0 0 23px;">
      <el-button @click="onAdd"> + 添加附加项</el-button>
    </el-row>
    <el-row type="flex" style="margin-top: 10px">
      <h6 class="title-text">备注</h6>
    </el-row>
    <el-row type="flex" style="margin: 10px 0 0 23px;">
      <el-input type="textarea" :rows="3" placeholder="请输入内容" v-model="formData.remarks" />
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'ReconciliationAdditional',
  props: ['formData'],
  methods: {
    onAdd () {
      this.formData.additionalCharges.push({
        remarks: '',
        amount: ''
      })
    },
    onDelete (index) {
      this.formData.additionalCharges.splice(index, 1);
    }
  }
}
</script>

<style scoped>
  .title-text {
    font-size: 14px;
    color: #606266;
    margin: 0px;
  }
</style>