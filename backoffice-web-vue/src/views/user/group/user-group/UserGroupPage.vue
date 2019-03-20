<template>
  <div class="animated fadeIn content">
    <el-card>
      <user-group-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <user-group-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('UserGroupsModule');

  import UserGroupToolbar from './toolbar/UserGroupToolbar';
  import UserGroupList from './list/UserGroupList';
  import UserGroupDetailsPage from './details/UserGroupDetailsPage';

  export default {
    name: 'UserGroupPage',
    components: {
      UserGroupToolbar,
      UserGroupList
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
        const url = this.apis().getUserGroups();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getUserGroup(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('员工：' + item.name, UserGroupDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建员工', UserGroupDetailsPage, formData);
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
