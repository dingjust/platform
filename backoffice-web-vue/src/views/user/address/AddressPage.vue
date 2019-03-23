<template>
  <div class="animated fadeIn content">
    <el-card>
      <address-toolbar @onNew="onNew"/>
      <hr/>
      <address-list :results="results" @onSetDefault="onSetDefault" @onRemove="onRemove"/>
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
        results: 'results',
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        refresh: 'refresh'
      }),
      onSearch() {
        const url = this.apis().getAddresses();
        this.search({url});
      },
      onNew(formData) {
        this.fn.openSlider('新建地址', AddressDetailsPage, formData);
      },
      async onSetDefault(item) {
        const formData = Object.assign({}, item);
        formData['defaultAddress'] = true;

        const url = this.apis().updateAddress(item.id);
        const result = await this.$http.put(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('设置成功');

        this.refresh();
      },
      async onRemove(item) {
        const url = this.apis().removeAddress(item.id);
        const result = await this.$http.delete(url, item);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('地址删除成功');
        this.refresh();
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
