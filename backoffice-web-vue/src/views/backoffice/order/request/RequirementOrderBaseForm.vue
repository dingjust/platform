<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="订单编码" prop="code">
            <el-input v-model="slotData.code" disabled placeholder="系统自动生成"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="商家" prop="belongTo">
            <el-select class="w-100" filterable remote reserve-keyword clearable
                       placeholder="请输入商家名称查询"
                       v-model="slotData.belongTo.uid"
                       :disabled="!belongToEditable"
                       :remote-method="onFilterCompanies">
              <el-option v-for="item in companies"
                         :key="item.uid"
                         :label="item.name"
                         :value="item.uid">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="是否已付定金" prop="depositPaid">
            <el-radio-group v-model="slotData.depositPaid">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="应付定金金额" prop="depositAmount">
            <el-input-number class="w-100" v-model="slotData.depositAmount"></el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="是否已付尾款" prop="retainagePaid">
            <el-radio-group v-model="slotData.retainagePaid">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="应付尾款金额" prop="retainageAmount">
            <el-input-number class="w-100" v-model="slotData.retainageAmount"></el-input-number>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'RequirementOrderBaseForm',
    props: ['slotData', 'readOnly', 'belongToEditable'],
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
      onFilterCompanies(query) {
        this.companies = [];
        if (query && query !== '') {
          setTimeout(() => {
            this.getCompanies(query);
          }, 200);
        }
      },
      async getCompanies(query) {
        const result = await this.$http.get('/djbrand/brand', {
          text: query.trim()
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.companies = result.content;
      }
    },
    data() {
      return {
        active: 0,
        companies: []
      }
    },
    created() {
      this.getCompanies('');
    }
  }
</script>
