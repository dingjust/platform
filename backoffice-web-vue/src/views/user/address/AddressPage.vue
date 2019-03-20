<template>
  <div class="animated fadeIn content">
    <el-card>
      <address-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <address-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('AddressesModule');

  import AddressToolbar from './toolbar/AddressToolbar';
  import AddressList from './list/AddressList';
  import AddressDetailsPage from './details/AddressDetailsPage';

  export default {
    name: 'AddressPage',
    components: {
      AddressToolbar,
      AddressList
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
        const url = this.apis().getAddresses();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getAddress(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('员工：' + item.name, AddressDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建员工', AddressDetailsPage, formData);
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
