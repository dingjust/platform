<template>
  <div class="animated fadeIn content">
    <el-card>
      <b2-b-customer-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <b2-b-customer-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('B2BCustomersModule');

  import B2BCustomerToolbar from './toolbar/B2BCustomerToolbar';
  import B2BCustomerList from './list/B2BCustomerList';
  import B2BCustomerDetailsPage from './details/B2BCustomerDetailsPage';

  export default {
    name: 'B2BCustomerPage',
    components: {
      B2BCustomerToolbar,
      B2BCustomerList
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
        const url = this.apis().getB2BCustomers();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getB2BCustomer(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('员工：' + item.name, B2BCustomerDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建员工', B2BCustomerDetailsPage, formData);
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
