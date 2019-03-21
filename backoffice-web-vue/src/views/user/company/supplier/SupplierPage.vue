<template>
  <div class="animated fadeIn content">
    <el-card>
      <template v-if="isBrand()">

        <brand-toolbar :hide-creation-button = true @onSearch="onSearch"/>
        <brand-list :page="page" @onDetails="onDetails" @onSearch="onSearch">
          <template slot="operations" slot-scope="props">
            <el-button type="text" icon="el-icon-edit" @click="onDetails(props.item)">明细</el-button>
            <el-button type="text" icon="el-icon-edit" @click="showPurchaseOrders(props.item)">生产订单</el-button>
          </template>
        </brand-list>
      </template>
      <template v-else-if="isFactory()">
        <factory-toolbar :hide-creation-button = true @onSearch="onSearch"/>
        <factory-list :page="page" @onDetails="onDetails" @onSearch="onSearch">
          <template slot="operations" slot-scope="props">
            <el-button type="text" icon="el-icon-edit" @click="onDetails(props.item)">明细</el-button>
            <el-button type="text" icon="el-icon-edit" @click="showPurchaseOrders(props.item)">生产订单</el-button>
          </template>
        </factory-list>
      </template>
      <template v-else>
        系统异常，请重新登录
      </template>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  const {mapGetters, mapActions} = createNamespacedHelpers('SuppliersModule');
  import FactoryToolbar from '@/views/user/company/factory/toolbar/FactoryToolbar';
  import FactoryList from '@/views/user/company/factory/list/FactoryList';
  import FactoryDetailsPage from '@/views/user/company/factory/details/FactoryDetailsPage';
  import BrandToolbar from '@/views/user/company/brand/toolbar/BrandToolbar';
  import BrandList from '@/views/user/company/brand/list/BrandList';
  import BrandDetailsPage from '@/views/user/company/brand/details/BrandDetailsPage';
  import PurchaseOrderPage from '@/views/order/purchase/PurchaseOrderPage';

  export default {

    name: 'MyCompanyPage',
    props: ['hideCreationButton'],
    components: {FactoryToolbar, FactoryList, FactoryDetailsPage, BrandToolbar, BrandList, BrandDetailsPage},
    computed: {
      ...mapGetters({
        page: 'page',
      }),
    },
    methods: {
      ...mapActions({
        search: 'search',
      }),
      onSearch(page, size) {
        if (this.isBrand()) {
          const keyword = this.$store.state.BrandsModule.keyword;
          const url = this.apis().getBrandSuppliers();
          this.search({url, keyword, page, size});
        } else if (this.isFactory()) {
          const keyword = this.$store.state.FactoriesModule.keyword;
          const url = this.apis().getFactoriesSuppliers();
          this.search({url, keyword, page, size});
        }
      },
      async onDetails(item) {

        if (this.isBrand()) {
          const url = this.apis().getFactory(item.uid);
          const result = await this.$http.get(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          console.log(result);
          this.fn.openSlider('品牌：' + item.name, BrandDetailsPage, result);
        } else if (this.isFactory()) {
          const url = this.apis().getBrand(item.uid);
          const result = await this.$http.get(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.fn.openSlider('工厂：' + item.name, FactoryDetailsPage, result);
        }
      },
      async showPurchaseOrders(item) {
        const url = this.apis().getPurchaseOrders();
        const result = await this.$http.post(url,{}, {page: 0, size: 10});
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        console.log(result);
        this.fn.openSlider('生产订单：' + item.name, PurchaseOrderPage, result);
      },
    },
    data() {
      return {
        keywordFromFactory: this.$store.state.FactoriesModule.keyword,
        keywordFromBrand: this.$store.state.BrandsModule.keyword
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
