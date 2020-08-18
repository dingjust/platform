<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="orders-list-title">
            <h6>样衣列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <sample-product-toolbar @onNew="onNew" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" 
                              :queryFormData="queryFormData" :dataQuery="dataQuery" @onResetQuery="onResetQuery"/>
      <el-tabs v-model="activeName" @tab-click="handleTabClick">
        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">
          <sample-product-list :page="page" @onDetails="onDetails" @onSearch="onSearch" @onBelongDetail="onBelongDetail"
            @onAdvancedSearch="onAdvancedSearch" @onDelete="onDelete" />
        </el-tab-pane>
      </el-tabs>
    </el-card>
    <el-dialog :visible.sync="sampleProductDetailsPageVisible" width="80%" :close-on-click-modal="false">
      <sample-product-details-page v-if="sampleProductDetailsPageVisible" :formData="productData" :read-only="true" />
    </el-dialog>
    <el-dialog :visible.sync="factoryDetailsPageVisible" width="80%" class="purchase-dialog"
      :close-on-click-modal="false">
      <factory-details-read v-if="factoryDetailsPageVisible" :slotData="belongDetailsData"></factory-details-read>
    </el-dialog>
    <el-dialog :visible.sync="brandDetailsPageVisible" width="80%" class="purchase-dialog"
      :close-on-click-modal="false">
      <brand-details-read v-if="brandDetailsPageVisible" :slotData="belongDetailsData">
      </brand-details-read>
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapMutations,
    mapActions
  } = createNamespacedHelpers('SampleProductsModule');

  import SampleProductToolbar from './toolbar/SampleProductToolbar';
  import SampleProductList from './list/SampleProductList';
  import SampleProductDetailsPage from './details/SampleProductDetailsPage';
  import FactoryDetailsRead from '@/views/user/company/factory/details/FactoryDetailsRead';
  import BrandDetailsRead from '@/views/user/company/brand/details/BrandDetailsRead';

  export default {
    name: 'SampleProductsPage',
    components: {
      SampleProductDetailsPage,
      SampleProductToolbar,
      SampleProductList,
      FactoryDetailsRead,
      BrandDetailsRead
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        // queryFormData: 'queryFormData',
        newFormData: 'newFormData',
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
        refresh: 'refresh'
      }),
      ...mapMutations({
        setAdvancedSearch: 'isAdvancedSearch'
      }),
      onSearch(page, size) {
        this.setAdvancedSearch(false);
        const keyword = this.keyword;
        const url = this.apis().getSampleProducts();
        this.search({
          url,
          keyword,
          page,
          size
        });
      },
      onAdvancedSearch(page, size) {
        this.setAdvancedSearch(true);
        if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
          this.onResetQuery();
        }
        const query = this.queryFormData;
        const url = this.apis().getSampleProducts();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
      },
      async onDetails(item) {
        const url = this.apis().getSampleProduct(item.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (this.isTenant()) {
          this.productData = result;
          this.sampleProductDetailsPageVisible = true;
          return;
        }
        Object.assign(this.newFormData, result);
        this.$router.push({
          name: '样衣详情',
          params: {
            slotData: result
          }
        });
      },
      async onBelongDetail(item) {
        //工厂
        if (item.belongTo.type == 'FACTORY') {
          let url = this.apis().getFactory(item.belongTo.uid);
          if (this.isTenant()) {
            url += '?sort=creationtime,desc';
          }
          const result = await this.$http.get(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.belongDetailsData = result;
          this.factoryDetailsPageVisible = true;
        } else
        if (item.belongTo.type == 'BRAND') {
          //品牌
          let url = this.apis().getBrand(item.belongTo.uid);
          if (this.isTenant()) {
            url += '?sort=creationtime,desc';
          }
          const result = await this.$http.get(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          if (result.duties == null || result.duties == undefined) {
            result.duties = '经理';
          }
          this.belongDetailsData = result;
          this.brandDetailsPageVisible = true;
        } else {
          return;
        }
      },
      onDelete(item) {
        this.$confirm('是否确认删除产品', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          // if (this.isTenant()) {
          //   this.platformDeleted(item);
          // } else {
            this._onDelete(item);
          // }
        });
      },
      async _onDelete(item) {
        const url = this.apis().deleteSampleProduct(item.code);
        const result = await this.$http.delete(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('样衣删除成功');
        this.onAdvancedSearch();
      },
      platformDeleted(item) {
        this.forbiddenItem = Object.assign({}, item);
        this.apparelProductForbiddenPageVisible = true;
      },
      async onDeleteConfirm(msg) {
        console.log(msg);
        const url = this.apis().platformDeletedShelfProduct(this.forbiddenItem.code);
        const result = await this.$http.delete(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.forbiddenItem = {};
        this.$message.success('样衣删除成功');
        this.apparelProductForbiddenPageVisible = false;
        this.onAdvancedSearch();
        // this.refresh();
      },
      onNew() {
        this.$router.push({
          name: '样衣详情',
          params: {
            slotData: this.formData
          }
        });
        // this.fn.openSlider('创建产品', ApparelProductDetailsPage, formData);
      },
      handleTabClick(tab) {
        if (tab.name !== '') {
          this.queryFormData.approvalStatuses = tab.name;
        } else {
          this.queryFormData.approvalStatuses = [];
        }
        this.onAdvancedSearch();
      },
      onDeleteCancel() {
        this.apparelProductForbiddenPageVisible = false;
      },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      }
    },
    data() {
      return {
        statuses: [{
          code: '',
          name: '全部'
        }, ],
        activeName: '',
        belongDetailsData: '',
        factoryDetailsPageVisible: false,
        brandDetailsPageVisible: false,
        sampleProductDetailsPageVisible: false,
        productData: {},
        apparelProductForbiddenPageVisible: false,
        apparelProductOffShelfPageVisible: false,
        forbiddenItem: {},
        offShelfItem: {},
        formData: this.$store.state.SampleProductsModule.newFormData,
        queryFormData: {
          code: '',
          skuID: '',
          name: '',
          approvalStatuses: '',
          categories: [],
          belongToName: ''
        },
        dataQuery: {}
      }
    },
    created() {
      this.dataQuery = this.getDataPerQuery('SAMPLE_CLOTHES_PRODUCT');
      this.onResetQuery();
      this.onAdvancedSearch();
    }
  };

</script>
<style scoped>
  .orders-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
