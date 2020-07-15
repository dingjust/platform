<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="organization-list-title">
            <h6>组织架构</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row type="flex">
        <el-col :span="6">
          <el-tabs>
            <el-tab-pane label="组织架构">
              <organization-tree :treeData="deptList"/>
            </el-tab-pane>
          </el-tabs>
        </el-col>
        <el-col :span="18">

        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import { createNamespacedHelpers } from 'vuex';
  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'PersonnelModule'
  );

  import OrganizationTree from './tree/OrganizationTree'
  export default {
    name: 'PersonnelPage',
    props: [],
    components: {
      OrganizationTree
    },
    computed: {
      ...mapGetters({
        page: 'page',
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch (page, size) {
        const keyword = this.keyword;
        const url = this.apis().getB2BCustomers();
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch (page, size) {
        const query = this.queryFormData;
        const url = this.apis().getB2BCustomers();
        this.searchAdvanced({url, query, page, size});
      },
      async getDeptList () {
        const url = this.apis().getB2BCustomerDeptList();
        const result = await this.$http.post(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.deptList = [{
          id: 0,
          name: '全部',
          depth: 0,
          children: result.data 
        }];
      },
    },
    data () {
      return {
        queryFormData: {
          keyword: '',
          roleGroupName: '',
          deptName: ''
        },
        deptList: []
      }
    },
    created () {
      this.onSearch(0, 10);
      this.getDeptList();
    },
    destroyed () {

    }    
  }
</script>

<style scoped>
  .organization-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>