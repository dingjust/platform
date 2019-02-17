<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="订单编码" prop="code">
            <el-input v-model="slotData.code" disabled placeholder="系统自动生成"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
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
    </el-form>
  </div>
</template>

<script>
  import {OrderMixin} from '@/mixins';
  import axios from 'axios';

  export default {
    name: 'OrderBaseForm',
    props: ['slotData', 'readOnly'],
    mixins: [OrderMixin],
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
      getCompanies(query) {
        axios.get('/djbrand/brand', {
          params: {
            text: query.trim()
          }
        }).then(response => {
          this.companies = response.data.content;
          console.log(this.companies);
        }).catch(error => {
          this.$message.error(error.response.data);
        });
      }
    },
    computed: {},
    data() {
      return {
        companies: []
      }
    },
    created() {
      this.getCompanies('');
    }
  }
</script>
