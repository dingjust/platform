<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="organization-list-title">
            <h6>角色管理</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <organization-role-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" />
      <organization-role-list :page="page" @onAdvancedSearch="onAdvancedSearch" />
    </el-card>
  </div>
</template>

<script>
  import { createNamespacedHelpers } from 'vuex';
  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'OrganizationRoleModule'
  );

  import OrganizationRoleToolbar from './toolbar/OrganizationRoleToolbar'
  import OrganizationRoleList from './list/OrganizationRoleList'
  export default {
    name: 'OrganizationRolePage',
    props: [],
    components: {
      OrganizationRoleToolbar,
      OrganizationRoleList
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
        const url = this.apis().getB2BCustomerRoleGroupList();
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch (page, size) {
        const query = this.queryFormData;
        const url = this.apis().getB2BCustomerRoleGroupList();
        this.searchAdvanced({url, query, page, size});
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