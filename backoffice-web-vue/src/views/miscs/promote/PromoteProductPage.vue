<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="12">
          <div class="orders-list-title">
            <h6>产品运营活动</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row>
        <el-tabs ref="tab" v-model="activeName" type="card" @tab-click="handleClick" :before-leave="tabBeforeLeave">
          <el-tab-pane label="顶部轮播(工厂)" name="FACTORY_CAROUSEL"/>
          <el-tab-pane label="顶部轮播(品牌)" name="BRAND_CAROUSEL"/>
          <el-tab-pane label="顶部轮播(看款下单)" name="SEE_PRODUCT_CAROUSEL"/>
          <el-tab-pane label="今日新款" name="TODAY_NEW"/>
          <el-tab-pane label="当季爆款" name="SEASON_HOT"/>
          <el-tab-pane label="直播专供" name="LIVE_BROADCAST_PROVIDE"/>
          <el-tab-pane label="为你推荐" name="RECOMMEND_FOR_YOU"/>
          <el-tab-pane label="中部轮播(看款下单)" name="BANNER"/>
        </el-tabs>
        <promote-product-carousel ref="carousel" v-if="activeName == 'SEE_PRODUCT_CAROUSEL'" @operationCount="operationCount" @returnCount="returnCount"/>
        <promote-product-factory-carousel v-if="activeName == 'FACTORY_CAROUSEL'" @operationCount="operationCount" @returnCount="returnCount"/>
        <promote-product-brand-carousel v-if="activeName == 'BRAND_CAROUSEL'" @operationCount="operationCount" @returnCount="returnCount"/>
        <promote-product-today ref="today" v-if="activeName == 'TODAY_NEW'" @onConfirmToday="onConfirmToday" :formData="formData"
                               @operationCount="operationCount" @returnCount="returnCount"/>
        <promote-product-season ref="season" v-if="activeName == 'SEASON_HOT'" :formData="formData" :slotData="promoteProductList"
                                @onProuductSelect="onProuductSelect" @onConfirm="onConfirm"
                                @operationCount="operationCount" @returnCount="returnCount"
                                @onListSearch="onListSearch" @onDelete="onDelete" @_moveNumber="_moveNumber"/>
        <promote-product-live ref="live" v-if="activeName == 'LIVE_BROADCAST_PROVIDE'" :formData="formData" :slotData="promoteProductList"
                              @onProuductSelect="onProuductSelect" @onConfirm="onConfirm"
                              @operationCount="operationCount" @returnCount="returnCount"
                              @onListSearch="onListSearch" @onDelete="onDelete" @_moveNumber="_moveNumber"/>
        <promote-product-for-you ref="forYou" v-if="activeName == 'RECOMMEND_FOR_YOU'" :formData="formData" :slotData="promoteProductList"
                                 @onProuductSelect="onProuductSelect" @onConfirm="onConfirm"
                                 @operationCount="operationCount" @returnCount="returnCount"
                                 @onListSearch="onListSearch" @onDelete="onDelete" @_moveNumber="_moveNumber"/>
        <promote-product-banner ref="banner" v-if="activeName == 'BANNER'" @operationCount="operationCount" @returnCount="returnCount"/>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="productSelectVisible" width="80%" :close-on-click-modal="false" class="purchase-dialog">
      <promote-product-select-dialog v-if="productSelectVisible" :page="page"
                                     @onAdvancedSearch="onAdvancedSearch"
                                     @onSearch="onSearch"
                                     @confirmPromoteProductList="confirmPromoteProductList"/>
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

  import PromoteProductCarousel from './details/PromoteProductCarousel';
  import PromoteProductToday from './details/PromoteProductToday';
  import PromoteProductSeason from './details/PromoteProductSeason';
  import PromoteProductSelectDialog from './dialog/PromoteProductSelectDialog';
  import PromoteProductLive from './details/PromoteProductLive';
  import PromoteProductForYou from './details/PromoteProductForYou';
  import PromoteProductBanner from './details/PromoteProductBanner';
  import PromoteProductFactoryCarousel from './details/PromoteProductFactoryCarousel';
  import PromoteProductBrandCarousel from './details/PromoteProductBrandCarousel';
  export default {
    name: 'PromoteProductPage',
    components: {
      PromoteProductBrandCarousel,
      PromoteProductFactoryCarousel,
      PromoteProductBanner,
      PromoteProductForYou,
      PromoteProductLive,
      PromoteProductCarousel,
      PromoteProductSelectDialog,
      PromoteProductSeason,
      PromoteProductToday
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
      onSearch (page, size) {
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
      onAdvancedSearch (page, size) {
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
      handleClick () {},
      getPageData (nval) {
        if (this.carouselEnum.indexOf(nval) < 0) {
          this.getProductPlate(nval);
        }
        // if (nval != 'SEE_PRODUCT_CAROUSEL' && nval != 'BANNER') {
        //   this.getProductPlate(nval);
        // }
      },
      tabBeforeLeave (nval, oval) {
        let flag
        if (this.carouselEnum.indexOf(this.activeName) > -1 || this.activeName === 'TODAY_NEW') {
          flag = this.leaveCount > 1
        } else {
          flag = this.leaveCount > 2;
        }
        // if (this.activeName === 'SEE_PRODUCT_CAROUSEL' || this.activeName === 'Factory_Carousel' || this.activeName === 'Brand_Carousel' || this.activeName === 'BANNER' || this.activeName === 'TODAY_NEW') {
        //   flag = this.leaveCount > 1;
        // } else {
        //   flag = this.leaveCount > 2;
        // }

        if (flag) {
          return this._judge(nval);
        } else {
          this.getPageData(nval);
          return true;
        }
      },
      _judge (nval) {
        return this.$confirm('是否切换标签 , 更改内容将不会被保存', '提示', {
          confirmButtonText: '离开页面',
          cancelButtonText: '留在页面',
          showClose: false,
          closeOnHashChange: false,
          type: 'warning'
        }).then(() => {
          this.getPageData(nval);
        })
      },
      async getProductPlate (activeName) {
        this.formData = {
          title: '',
          subtitle: '',
          picture: {},
          sequenceProducts: []
        };
        const type = activeName;
        const url = this.apis().getProductPlate(type);
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        result.data.sequenceProducts.sort(this.compare('sequence'));
        if (result.data != null) {
          this.formData = Object.assign({}, result.data);
        }
        if (this.carouselEnum.indexOf(activeName) < 0 && activeName != 'TODAY_NEW') {
          this.$store.state.PromoteProductModule.promoteProductList = Object.assign([], this.formData.sequenceProducts);
          this.promoteProductList = this.formData.sequenceProducts;
          this.originData = this.formData.sequenceProducts;
        }
        // if (activeName != 'SEE_PRODUCT_CAROUSEL' && activeName != 'TODAY_NEW') {
        //   this.$store.state.PromoteProductModule.promoteProductList = Object.assign([], this.formData.sequenceProducts);
        //   this.promoteProductList = this.formData.sequenceProducts;
        //   this.originData = this.formData.sequenceProducts;
        // }
        this.returnCount();
      },
      compare (property) {
        return function (a, b) {
          const value1 = a[property];
          const value2 = b[property];
          return value1 - value2;
        }
      },
      // 提交今日新款
      async onConfirmToday (submitData) {
        const url = this.apis().createProductPlate();
        const result = await this.$http.post(url, submitData);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('操作成功');
        this.getProductPlate(this.activeName);
        this.returnCount();
      },
      onProuductSelect () {
        this.queryFormData.approvalStatuses = 'approved';
        // this.onSearch();
        this.onAdvancedSearch();
        this.$store.state.PromoteProductModule.promoteProductList = this.promoteProductList;
        this.productSelectVisible = true;
      },
      confirmPromoteProductList () {
        let list = this.$store.state.PromoteProductModule.promoteProductList;
        let showList = [];
        for (let i = 0; i < list.length; i++) {
          showList[i] = {
            sequence: i + 1,
            product: list[i]
          }
        }
        this.promoteProductList = showList;
        this.originData = showList;
        this.$store.state.PromoteProductModule.promoteProductList = showList;
        this.productSelectVisible = false;
      },
      // 提交当季爆款,直播专供,为你推荐
      async onConfirm (titleData) {
        let productList = this.$store.state.PromoteProductModule.promoteProductList;
        let productData = [];
        let item;
        for (let i = 0; i < productList.length; i++) {
          item = {
            sequence: productList[i].sequence,
            product: {
              id: productList[i].product.id
            }
          }
          productData.push(item);
        }
        titleData.sequenceProducts = productData
        const url = this.apis().createProductPlate();
        const result = await this.$http.post(url, titleData);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('操作成功');
        this.getProductPlate(this.activeName);
      },
      onListSearch (keyword) {
        if (keyword.replace(/\s*/g, '').length == 0) {
          this.promoteProductList = this.originData;
          this.$store.state.PromoteProductModule.promoteProductList = this.promoteProductList;
        } else {
          const searchData = this.originData.filter(function (item) {
            return item.product.name.search(keyword) > -1 || item.product.skuID.search(keyword) > -1;
          })
          this.promoteProductList = searchData;
          this.$store.state.PromoteProductModule.promoteProductList = this.promoteProductList;
        }
      },
      onDelete (row, keyword) {
        const index = this.originData.findIndex((item) => item.id == row.id);
        this.originData.splice(index, 1);
        for (let i = 0; i < this.originData.length; i++) {
          this.originData[i].sequence = i + 1;
        }
        this.onListSearch(keyword)
        this.$message.success('删除商品成功');
      },
      _moveNumber (index, modifyText, keyword) {
        const modifyT = modifyText - this.originData.length >= 0 ? this.originData.length : modifyText;
        const item = this.originData.splice(index - 1, 1);
        this.originData.splice(modifyT - 1, 0, item[0]);
        for (let i = 0; i < this.originData.length; i++) {
          this.originData[i].sequence = i + 1;
        }
        this.onListSearch(keyword)
        this.$message.success('移动商品序号成功');
      },
      operationCount () {
        this.leaveCount++;
        console.log(this.leaveCount);
      },
      returnCount () {
        this.leaveCount = 0;
        console.log(this.leaveCount);
      }
    },
    data () {
      return {
        carouselType: 'CT004',
        activeName: 'FACTORY_CAROUSEL',
        SeeProductPlateType: this.$store.state.EnumsModule.SeeProductPlateType,
        productSelectVisible: false,
        formData: {
          title: '',
          subtitle: '',
          picture: {},
          sequenceProducts: []
        },
        promoteProductList: [],
        searchList: [],
        originData: [],
        leaveCount: 0,
        carouselEnum: [
          'SEE_PRODUCT_CAROUSEL',
          'BANNER',
          'FACTORY_CAROUSEL',
          'BRAND_CAROUSEL'
        ]
      }
    },
    created () {
      // this.onSearch();
    },
    beforeRouteLeave (to, from, next) {
      next(false);
      let flag
      if (this.carouselEnum.indexOf(this.activeName) > -1 || this.activeName === 'TODAY_NEW') {
        flag = this.leaveCount > 1;
      } else {
        flag = this.leaveCount > 2;
      }
      // if (this.activeName === 'SEE_PRODUCT_CAROUSEL'|| this.activeName === 'BANNER' || this.activeName === 'TODAY_NEW') {
      //   flag = this.leaveCount > 1;
      // } else {
      //   flag = this.leaveCount > 2;
      // }

      if (flag) {
        this.$confirm('是否离开此页面 , 更改内容将不会被保存', '提示', {
          confirmButtonText: '离开页面',
          cancelButtonText: '留在页面',
          type: 'warning',
          showClose: false,
          closeOnHashChange: false
        }).then(() => {
          next();
        }).catch(() => {
          throw new Error('取消成功！')
        })
      } else {
        next();
      }
    }
  }
</script>

<style scoped>
  .orders-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
