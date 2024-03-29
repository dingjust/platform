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
      <apparel-product-toolbar @onNew="onNew" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" 
                               :queryFormData="queryFormData" :dataQuery="dataQuery" @onResetQuery="onResetQuery"/>
      <div>
        <div class="batch-opera-btn" v-if="activeName === 'approved' || activeName === 'unapproved'">
          <el-button v-if="isSelect === false" @click="isSelect = true">批量操作</el-button>
          <template v-else>
            <el-button type="text" @click="isSelect = false">取消</el-button>
            <el-button v-if="activeName === 'unapproved'" type="text" @click="batchOn">批量上架</el-button>
            <el-button v-if="activeName === 'approved'" type="text" @click="batchOff">批量下架</el-button>
          </template>
        </div>
        <el-tabs v-model="activeName" @tab-click="handleTabClick">
          <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">
            <apparel-product-list ref="list" :page="page" @onDetails="onDetails" @onSearch="onSearch"
              @onBelongDetail="onBelongDetail" @onAdvancedSearch="onAdvancedSearch" @onShelf="onShelf"
              @onOffShelf="onOffShelf" @onDelete="onDelete" :code="status.code" :isSelection="isSelection"/>
          </el-tab-pane>
        </el-tabs>
      </div>
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
        newFormData: 'newFormData'
      }),
      isSelection () {
        return this.isSelect && (this.activeName === 'approved' || this.activeName === 'unapproved')
      }
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
        // if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
        //   this.onResetQuery();
        // }
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
        Object.assign(this.newFormData,result);
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
      onShelf(item) {
        this.$confirm('是否确认下架该产品', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onShelf(item)
        });
      },
      async _onShelf(item) {
        let url;
        if (this.isTenant()) {
          url = this.apis().platformOnShelffProduct(item.code)
        } else {
          url = this.apis().onShelfProduct(item.code);
        }
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('编号为' + item.code + '的产品上架成功');
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
        this.$message.success('编号为' + item.code + '的产品下架成功');
        this.onAdvancedSearch();
        // this.refresh();
      },
      async platformOff(item) {
        this.offShelfItem = Object.assign({}, item);
        this.apparelProductOffShelfPageVisible = true;
      },
      async onOffShelfConfirm(msg) {
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
      onNew() {
        this.$router.push({
          name: '产品详情',
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
      onOffShelfCancel() {
        this.apparelProductOffShelfPageVisible = false;
      },
      onDeleteCancel() {
        this.apparelProductForbiddenPageVisible = false;
      },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      },
      batchOn () {
        this.$confirm('是否执行批量上架?', '', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          this._batchOn()
        });
      },
      checkOn (row) {
        if (row.productType == null || row.productType.length <= 0 || row.productType.indexOf('FUTURE_GOODS') > -1) {
          if (row.steppedPrices == null || row.steppedPrices.length <= 0 || row.basicProduction == null ||
            row.productionIncrement == null || row.productionDays == null) {
            return (row.code + '：价格设置资料未完善，不可上架')
          }
          let flag = false;
          row.steppedPrices.some((p) => {
            if (p.minimumQuantity == null || p.price == null) {
              flag = true;
              return true;
            }
          });
          if (flag) {
            return (row.code + '：价格设置资料未完善，不可上架');
          }
        }

        if (row.productType != null && (row.productType.indexOf('SPOT_GOODS') > -1 || row.productType.indexOf(
            'TAIL_GOODS') > -1)) {
          if (row.spotSteppedPrices == null || row.spotSteppedPrices.length <= 0) {
            return (row.code + '：现货/库存尾货价格设置资料未完善，不可上架');
          }
          let flag = false;
          row.spotSteppedPrices.some((p) => {
            if (p.minimumQuantity == null || p.price == null) {
              flag = true;
              return true;
            }
          });
          if (flag) {
            return (row.code + '：现货/库存尾货价格设置资料未完善，不可上架');
          }
          var totalQuality = this.totalQuality(row.colorSizes);
          row.spotSteppedPrices.sort(function (a, b) {
            return a.minimumQuantity - b.minimumQuantity;
          });
          if (totalQuality < row.spotSteppedPrices[0].minimumQuantity) {
            return (row.code + '：库存总数量小于现货/库存最小起订量，不可上架');
          }
        }
      },
      totalQuality(colorSizes) {
        var total = 0;
        colorSizes.forEach((colorSize) => {
          if (colorSize.sizes != null) {
            colorSize.sizes.forEach((size) => {
              if (size.quality != null) {
                total += size.quality;
              }
            });
          }
        });
        return total;
      },
      async _batchOn () {
        const refList = this.$refs.list.find(item => item.code === this.activeName);

        let arrs = refList.multipleSelection.map(item => this.checkOn(item)).filter(val => val != undefined)
        if (arrs.length > 0) {
          this.$message({
            dangerouslyUseHTMLString: true,
            message: arrs.join('<br/>'),
            type: 'error'
          });
          return
        }

        const codes = refList.multipleSelection.map(item => item.code)

        let url = this.apis().batchOnShelfProduct()
        if (this.isTenant()) {
          url = this.apis().platformBatchOnShelffProduct()
        }
        const result = await this.$http.put(url, {}, {
          codes: codes.toString()
        })

        if (result.code === 1) {
          if (result.data) {
            let msgs = []
            for (const key in result.data) {
              if (Object.hasOwnProperty.call(result.data, key)) {
                msgs.push(key + ':' + result.data[key]);
              }
            }

            this.$message({
              dangerouslyUseHTMLString: true,
              message: msgs.join('<br/>'),
              type: 'error'
            });
          } else {
            this.$message.success('操作成功！')
          }
        } else if (result.code === 0) {
          this.$message.error(result.msg)
        } else if (result['errors']) {
          this.$message.error(result['errors'][0].message)
        } else {
          this.$message.error('操作失败')
        }

        this.onAdvancedSearch()
      },
      batchOff () {
        this.$confirm('是否执行批量下架?', '', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          this._batchOff()
        });
      },
      async _batchOff () {
        const refList = this.$refs.list.find(item => item.code === this.activeName);
        const codes = refList.multipleSelection.map(item => item.code)

        let url = this.apis().batchOffShelfProduct()
        if (this.isTenant()) {
          url = this.apis().platformBatchOffShelfProduct()
        }
        const result = await this.$http.put(url, {}, {
          codes: codes.toString()
        })

        if (result.code === 1) {
          this.$message.success('操作成功！')
        } else if (result.code === 0) {
          this.$message.error(result.msg)
        } else if (result['errors']) {
          this.$message.error(result['errors'][0].message)
        } else {
          this.$message.error('操作失败')
        }

        this.onAdvancedSearch()
      }
    },
    data() {
      return {
        statuses: [{
            code: 'approved',
            name: '已上架'
          }, {
            code: 'unapproved',
            name: '已下架'
          },  {
            code: '',
            name: '全部'
          }
        ],
        activeName: 'approved',
        belongDetailsData: '',
        factoryDetailsPageVisible: false,
        brandDetailsPageVisible: false,
        apparelProductDetailsPageVisible: false,
        productData: {},
        apparelProductForbiddenPageVisible: false,
        apparelProductOffShelfPageVisible: false,
        forbiddenItem: {},
        offShelfItem: {},
        formData: this.$store.state.ApparelProductsModule.newFormData,
        queryFormData: {
          keyword: '',
          code: '',
          skuID: '',
          name: '',
          approvalStatuses: 'approved',
          categories: [],
          belongToName: ''
        },
        dataQuery: {},
        isSelect: false
      }
    },
    created() {
      // this.dataQuery = this.getDataPerQuery('PRODUCTION_PRODUCT');
      // this.onResetQuery();
      this.onAdvancedSearch();
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

  .batch-opera-btn {
    position: absolute;
    right: 21px;
    z-index: 999;
  }
</style>
