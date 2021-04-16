<!--
* @Description: 成本单 工艺/其他费用 
* @Date 2021/03/01 10:44
* @Author L.G.Y
-->
<template>
  <div>
    <el-row type="flex" justify="start">
      <h6 class="additional-title">工艺/其他费用</h6>
    </el-row>
    <el-row type="flex" align="middle">
      <el-form ref="form" :model="formData" style="width: 100%">
        <el-table :data="formData.customRows" stripe>
          <el-table-column label="类别" prop="customCategoryName">
            <template slot-scope="scope">
              <el-form-item label="" :prop="'customRows.' + scope.$index + '.customCategoryName'" 
                            :rules="{validator: validateItem, trigger: 'change'}">
                <el-select v-model="scope.row.customCategoryName">
                  <el-option v-for="typeName in additionType" :label="typeName" :value="typeName" :key="typeName" />
                </el-select>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="名称" prop="name">
            <template slot-scope="scope">
              <el-form-item label="" :prop="'customRows.' + scope.$index + '.name'" :rules="{required: true, message: '不能为空', trigger: 'change'}">
                <el-autocomplete class="inline-input"
                                  v-model="scope.row.name"
                                  :fetch-suggestions="querySearch"
                                  :popper-class="scope.row.customCategoryName === '其他费用' ? 'hide-popper' : ''"
                                  placeholder="请输入内容">
                </el-autocomplete>
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
  data () {
    return {
      additionType: ['特殊工艺', '其他费用'],
      specialProcess: [
        { value: '加工费' },
        { value: '绣花' },
        { value: '洗水' },
        { value: '印花' },
        { value: '缩水' },
        { value: '复合' },
        { value: '打条' },
        { value: '钉珠' },
        { value: '烫钻' },
        { value: '打揽' },
        { value: '手工' },
        { value: '纸朴' },
        { value: '布朴' },
        { value: '压褶' },
        { value: '版费' },
        { value: '猪鼻扣' }
      ]
    }
  },
  methods: {
    validateItem (rule, value, callback) {
      if (!value || value === '') {
        callback(new Error('请选择类型！'));
      } else {
        callback();
      }
    },
    querySearch(queryString, cb) {
      cb(this.specialProcess);
    },
    onAdd () {
      this.formData.customRows.push({
        name: '',
        customCategoryName: '',
        price: '',
        unit: '件'
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

<style>
  .additional-title_scoped {
    font-size: 14px;
    color: #606266;
  }

  .hide-popper {
    display: none;
  }
</style>