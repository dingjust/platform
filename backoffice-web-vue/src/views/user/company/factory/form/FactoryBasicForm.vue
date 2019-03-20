<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="工厂名称" prop="name">
            <el-input v-model="slotData.name"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="联系人" prop="contactPerson">
            <el-input v-model="slotData.contactPerson"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="手机号" prop="contactPhone">
            <el-input v-model="slotData.contactPhone"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="经营地址" prop="address">
            <el-input v-model="slotData.address"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="邮箱" prop="email">
            <el-input v-model="slotData.email"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="座机" prop="phone">
            <el-input v-model="slotData.phone"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="合作品牌" prop="cooperativeBrand">
            <el-input v-model="slotData.cooperativeBrand"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="开发能力" prop="developmentCapacity">
            <el-radio-group v-model="slotData.developmentCapacity">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="月均产能" prop="monthlyCapacityRange">
            <el-select v-model="slotData.monthlyCapacityRange" class="w-100">
              <el-option v-for="item in monthlyCapacityRanges" :key="item.code" :label="item.name"
                         :value="item.code"></el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="产值规模" prop="scaleRange">
            <el-select v-model="slotData.scaleRange" class="w-100">
              <el-option v-for="item in scaleRanges" :key="item.code" :label="item.name" :value="item.code"></el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="合作方式" prop="cooperationModes">
            <el-select v-model="slotData.cooperationModes" class="w-100" multiple>
              <el-option v-for="item in cooperationModes" :key="item.code" :label="item.name"
                         :value="item.code"></el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="车位数量" prop="latheQuantity">
            <el-input-number class="w-100" v-model="slotData.latheQuantity" :min="0"></el-input-number>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="优势品类" prop="adeptAtCategories">
            <el-checkbox-group v-model="slotData.adeptAtCategories">
              <el-checkbox v-for="item in adeptAtCategories" :label="item.code" :key="item.code">
                {{item.name}}
              </el-checkbox>
            </el-checkbox-group>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'FactoryBasicForm',
    props: ['slotData', 'readOnly'],
    methods: {
      async getCategories() {
        const url = this.apis().getMajorCategories();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.adeptAtCategories = result;
      }
    },
    data() {
      return {
        adeptAtCategories: [],
        rules: {
          name: [{required: true, message: '必填', trigger: 'blur'}],
          address: [{required: true, message: '必填', trigger: 'blur'}],
          email: [
            {
              message: '邮箱格式不正确',
              trigger: 'blur',
              pattern: /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/
            }
          ],
          contactPhone: [
            {required: false, message: '手机号码不正确', trigger: 'blur', pattern: 11 && /^((13|14|15|17|18)[0-9]{1}\d{8})$/}
          ],
        },
        cooperationModes: this.$store.state.EnumsModule.cooperationModes,
        scaleRanges: this.$store.state.EnumsModule.scaleRanges,
        monthlyCapacityRanges: this.$store.state.EnumsModule.monthlyCapacityRanges,
      };
    },
    created() {
      this.getCategories();
    }
  };
</script>
