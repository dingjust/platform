<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col>
          <div class="contract-list-title">
            <h6>合同列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <contract-back-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
      <contract-back-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
    </el-card>
  </div>
</template>

<script>
import ContractBackToolbar from './toolbar/ContractBackToolbar'
import ContractBackList from './list/ContractBackList'

export default {
  name: 'ContractBackPage',
  components: {
    ContractBackToolbar,
    ContractBackList
  },
  data () {
    return {
      queryFormData: {
        title: '',
        creationtimeStart: '',
        creationtimeEnd: '',
        type: ''
      },
      page: {
        number: 0, // 当前页，从0开始
        size: 10, // 每页显示条数
        totalPages: 1, // 总页数
        totalElements: 0, // 总数目数
        content: [] // 当前页数据
      },
    }
  },
  methods: {
    async onAdvancedSearch (page, size) {
      const query = this.queryFormData;
      const url = this.apis().getAgreementList();
      
      const result = await this.$http.post(url, query, {
        page: page,
        size: size
      });

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      this.page = result;
    }
  },
  created () {
    this.onAdvancedSearch(0, 10);
  }
}
</script>

<style scoped>
  .contract-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>