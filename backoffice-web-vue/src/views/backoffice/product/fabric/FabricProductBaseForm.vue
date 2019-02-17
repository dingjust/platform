<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly"
             :rules="rules">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="产品编码" prop="code">
            <el-input v-model="slotData.code" disabled placeholder="系统自动生成"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="产品名称" prop="name">
            <el-input v-model="slotData.name"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="产品价格">
            <el-input-number class="w-100" v-model="slotData.price"
                             :precision="2"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="商家" prop="belongTo">
            <el-select class="w-100" filterable remote reserve-keyword clearable
                       placeholder="请输入商家名称查询"
                       v-model="slotData.belongTo.uid"
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
        <el-col :span="24">
          <el-form-item label="颜色" prop="colors">
            <el-checkbox-group v-model="slotData.colors">
              <el-checkbox v-for="item in colors" :label="item.code" :key="item.id">
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
  import axios from 'axios';

  export default {
    name: 'FabricProductBaseForm',
    props: ['slotData', 'readOnly', 'isNewlyCreated'],
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
      getColors() {
        axios.get('/djbackoffice/product/color/all')
          .then(response => {
            this.colors = response.data;
          })
          .catch(error => {
            this.$message.error(error.response.statusText);
          });
      },
      onFilterCompanies(query) {
        this.companies = [];
        if (query && query !== '') {
          setTimeout(() => {
            this.getCompanies(query);
          }, 200);
        }
      },
      getCompanies(query) {
        axios.get('/djfactory/factory', {
          params: {
            text: query.trim()
          }
        }).then(response => {
          this.companies = response.data.content;
        }).catch(error => {
          this.$message.error(error.response.data);
        });
      }
    },
    computed: {},
    created() {
      this.getColors();
      this.getCompanies();
      if (!this.isNewlyCreated) {
        return this.slotData.id === null;
      }
    },
    data() {
      return {
        rules: {
          name: [
            {required: true, message: '必填', trigger: 'blur'}
          ]
        },
        colors: [],
        companies: []
      }
    }
  }
</script>
