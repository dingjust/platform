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
      <el-container style="height:100%">
        <el-aside width="30%">
          <el-tabs>
            <el-tab-pane label="组织架构">
              <div style="overflow-y: auto;'">
                <organization-tree :treeData="deptList" @refreshDept="getDeptList"/>
              </div>
            </el-tab-pane>
          </el-tabs>
        </el-aside>
        <el-main width="70%" class="info-main-body">
          <organization-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" />
          <organization-list :page="page" @onAdvancedSearch="onAdvancedSearch" />
        </el-main>
      </el-container>
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

  import OrganizationToolbar from './toolbar/OrganizationToolbar'
  import OrganizationList from './list/OrganizationList'
  import OrganizationTree from './tree/OrganizationTree'
  export default {
    name: 'PersonnelPage',
    props: [],
    components: {
      OrganizationTree,
      OrganizationToolbar,
      OrganizationList
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
      }
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
      this.onAdvancedSearch(0, 10);
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

  .main-container {
    margin: 5px 0px 0px 10px;
  }

  .info-main-body {
    padding-top: 5px;
    width: 100%;
    border-left: 2px solid rgba(0, 0, 0, 0.09);
  }
</style>