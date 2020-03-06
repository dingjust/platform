<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="orders-list-title">
            <h6>产品列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <apparel-product-toolbar @onNew="onNew" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" />
      <el-tabs v-model="activeName" @tab-click="handleTabClick">
        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">
          <apparel-product-list :page="page" @onDetails="onDetails" @onSearch="onSearch"
            @onBelongDetail="onBelongDetail" @onAdvancedSearch="onAdvancedSearch" @onShelf="onShelf"
            @onOffShelf="onOffShelf" @onDelete="onDelete" />
        </el-tab-pane>
      </el-tabs>
    </el-card>
    <el-dialog :visible.sync="apparelProductDetailsPageVisible" width="80%" :close-on-click-modal="false">
      <apparel-product-details-page v-if="apparelProductDetailsPageVisible" :formData="productData" :read-only="true" />
    </el-dialog>
    <el-dialog title="禁用" :visible.sync="apparelProductForbiddenPageVisible" width="30%" :close-on-click-modal="false">
      <apparel-product-forbidden-dialog v-if="apparelProductForbiddenPageVisible" @onCancel="onDeleteCancel"
        @onConfirm="onDeleteConfirm" />
    </el-dialog>
    <el-dialog title="下架" :visible.sync="apparelProductOffShelfPageVisible" width="30%" :close-on-click-modal="false">
      <apparel-product-off-shelf-dialog v-if="apparelProductOffShelfPageVisible" @onCancel="onOffShelfCancel"
        @onConfirm="onOffShelfConfirm" />
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
  } = createNamespacedHelpers('ApparelProductsModule');

  import ApparelProductToolbar from './toolbar/ApparelProductToolbar';
  import ApparelProductList from './list/ApparelProductList';
  import ApparelProductDetailsPage from './details/ApparelProductDetailsPage';
  import ApparelProductForbiddenDialog from './form/ApparelProductForbiddenDialog';
  import ApparelProductOffShelfDialog from './form/ApparelProductOffShelfDialog';
  import FactoryDetailsRead from '@/views/user/company/factory/details/FactoryDetailsRead';
  import BrandDetailsRead from '@/views/user/company/brand/details/BrandDetailsRead';

  export default {
    name: 'ApparelProductPage',
    components: {
      ApparelProductOffShelfDialog,
      ApparelProductForbiddenDialog,
      ApparelProductDetailsPage,
      ApparelProductToolbar,
      ApparelProductList,
      FactoryDetailsRead,
      BrandDetailsRead
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData'
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
        const url = this.apis().getApparelProducts();
        this.search({
          url,
          keyword,
          page,
          size
        });
      },
      onAdvancedSearch(page, size) {
        this.setAdvancedSearch(true);

        const query = this.queryFormData;
        const url = this.apis().getApparelProducts();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
      },
      async onDetails(item) {
        const url = this.apis().getApparelProduct(item.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (this.isTenant()) {
          this.productData = result;
          this.apparelProductDetailsPageVisible = true;
          return;
        }
        this.$router.push({
          name: '产品详情',
          params: {
            slotData: result
          }
        });
        // this.fn.openSlider('产品：' + item.code, ApparelProductDetailsPage, result);
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
        if (item.belongTo.type == 'BRAND') 
        {
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
      async onShelf(item) {
        const url = this.apis().onShelfProduct(item.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.onAdvancedSearch();
        // this.refresh();
      },
      onOffShelf(item) {
        this.$confirm('是否确认下架该产品', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          if (this.isTenant()) {
            this.platformOff(item);
          } else {
            this._onOffShelf(item);
          }
        });
      },
      async _onOffShelf(item) {
        const url = this.apis().offShelfProduct(item.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.onAdvancedSearch();
        // this.refresh();
      },
      async platformOff(item) {
        this.offShelfItem = Object.assign({}, item);
        this.apparelProductOffShelfPageVisible = true;
      },
      async onOffShelfConfirm(msg) {
        console.log(msg);
        const url = this.apis().platformOffShelfProduct(this.offShelfItem.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.offShelfItem = {};
        this.apparelProductOffShelfPageVisible = false;
        this.$message.success('产品下架成功');
        // this.refresh();
        this.onAdvancedSearch();
      },
      onDelete(item) {
        this.$confirm('是否确认删除产品', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          if (this.isTenant()) {
            this.platformDeleted(item);
          } else {
            this._onDelete(item);
          }
        });
      },
      async _onDelete(item) {
        const url = this.apis().deleteProduct(item.code);
        const result = await this.$http.delete(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('产品删除成功');
        // this.refresh();
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
        this.$message.success('产品删除成功');
        this.apparelProductForbiddenPageVisible = false;
        this.onAdvancedSearch();
        // this.refresh();
      },
      onNew(formData) {
        this.$router.push({
          name: '产品详情',
          params: {
            slotData: formData
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
      onOffShelfCancel() {
        this.apparelProductOffShelfPageVisible = false;
      },
      onDeleteCancel() {
        this.apparelProductForbiddenPageVisible = false;
      }
    },
    data() {
      return {
        statuses: [{
            code: '',
            name: '全部'
          },
          {
            code: 'approved',
            name: '已上架'
          },
          {
            code: 'unapproved',
            name: '已下架'
          }
        ],
        activeName: '',
        belongDetailsData: '',
        factoryDetailsPageVisible: false,
        brandDetailsPageVisible: false,
        apparelProductDetailsPageVisible: false,
        productData: {},
        apparelProductForbiddenPageVisible: false,
        apparelProductOffShelfPageVisible: false,
        forbiddenItem: {},
        offShelfItem: {}
      }
    },
    created() {
      this.onSearch();
      if (this.isTenant()) {
        this.statuses.push({
          code: 'deleted',
          name: '已删除'
        })
      }
    }
  };

</script>
<style scoped>
  .orders-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
