<template>
  <div class="animated fadeIn content">
    <el-card>
      <address-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <address-list :page="page" @onSetDefault="onSetDefault" @onSearch="onSearch"/>
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
        refresh: 'refresh'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.apis().getAddresses();
        this.search({url, keyword, page, size});
      },
      async onSetDefault(item) {
        const url = this.apis().updateAddress(item.id);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.refresh();
      },
      onNew(formData) {
        this.fn.openSlider('新建地址', AddressDetailsPage, formData);
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
