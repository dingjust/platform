<template>
  <div class="animated fadeIn content">
    <el-card>
      <role-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <role-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('RolesModule');

  import RoleToolbar from './toolbar/RoleToolbar';
  import RoleList from './list/RoleList';
  import RoleDetailsPage from './details/RoleDetailsPage';

  export default {
    name: 'RolePage',
    components: {
      RoleToolbar,
      RoleList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.apis().getRoles();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getRole(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('角色：' + item.name, RoleDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建角色', RoleDetailsPage, formData);
      },
    },
    data() {
      return {};
    },
    created() {
      this.onSearch();
    }
  };
</script>
