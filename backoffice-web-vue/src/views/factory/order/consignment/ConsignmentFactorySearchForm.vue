<template>
  <div class="animated fadeIn">
    <div class="pt-2"></div>
    <el-form ref="form" :model="slotData">
      <el-form-item label="">
        <el-select class="w-100"
                   placeholder="请输入工厂编码/名称查询"
                   filterable
                   remote
                   reserve-keyword
                   clearable
                   v-model="slotData.assignedTo.uid"
                   :remote-method="onFilter"
                   @change="onSelected">
          <el-option
            v-for="item in companies"
            :key="item.uid"
            :label="item.name"
            :value="item.uid">
          </el-option>
        </el-select>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    name: 'ConsignmentFactorySearchForm',
    props: ['slotData'],
    components: {},
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
      onFilter(query) {
        this.companies = [];
        if (query !== '') {
          axios.get('/djfactory/b2bFactory', {
            params: {
              name: query
            }
          }).then(response => {
            this.companies = response.data.content;
          }).catch(error => {
            console.log(JSON.stringify(error));
            this.$message.error(error.response.data);
          }).finally(() => {
            this.loading = false;
          });
        }
      },
      onSelected(current) {
        const slotData = this.slotData;
        this.companies.filter(value => {
          return current === value.uid;
        }).forEach(company => {
          this.showDetails = true;
          this.company = company;
          this.$set(slotData, 'assignedTo', company);
        });
      }
    },
    computed: {},
    data() {
      return {
        text: '',
        showDetails: false,
        company: {},
        companies: [],
        loading: false
      }
    }
  }
</script>
