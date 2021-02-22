<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="organization-list-title">
            <h6>组织架构</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-container>
        <el-aside width="30%">
          <el-tabs>
            <el-tab-pane label="组织架构">
              <organization-tree :treeData="deptList" @refreshDept="getDeptList" 
                                 @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData" />
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
        deptList: 'deptList'
      })
    },
    methods: {
      ...mapActions({
        searchAdvanced: 'searchAdvanced',
        searchDeptList: 'searchDeptList'
      }),
      onAdvancedSearch (page, size) {
        const query = this.queryFormData;
        const url = this.apis().getB2BCustomers();
        this.searchAdvanced({url, query, page, size});
      },
      getDeptList () {
        this.searchDeptList();
      }
    },
    data () {
      return {
        queryFormData: {
          keyword: '',
          roleGroupName: '',
          deptName: ''
        }
      }
    },
    created () {
      this.onAdvancedSearch(0, 10);
      this.getDeptList();
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
    padding: 5px 0px 0px 20px;
    /* width: 100%; */
    border-left: 2px solid rgba(0, 0, 0, 0.09);
  }
</style>