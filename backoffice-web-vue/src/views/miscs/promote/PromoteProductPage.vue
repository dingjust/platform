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
        <el-tabs ref="tab" v-model="activeName" type="card" @tab-click="handleClick">
          <el-tab-pane label="看款轮播" name="carousel"/>
          <el-tab-pane label="今日新款" name="TODAY_NEW"/>
          <el-tab-pane label="当季爆款" name="SEASON_HOT"/>
          <el-tab-pane label="直播专供" name="LIVE_BROADCAST_PROVIDE"/>
          <el-tab-pane label="为你推荐" name="RECOMMEND_FOR_YOU"/>
        </el-tabs>
        <promote-product-carousel ref="carousel" v-if="activeName == 'carousel'"/>
        <promote-product-today ref="today" v-if="activeName == 'TODAY_NEW'" @onConfirmToday="onConfirmToday" :formData="formData"/>
        <promote-product-season ref="season" v-if="activeName == 'SEASON_HOT'" :formData="formData" :slotData="promoteProductList"
                                @onProuductSelect="onProuductSelect" @onConfirm="onConfirm"/>
        <promote-product-live ref="live" v-if="activeName == 'LIVE_BROADCAST_PROVIDE'" :formData="formData" :slotData="promoteProductList"
                              @onProuductSelect="onProuductSelect" @onConfirm="onConfirm"/>
        <promote-product-for-you ref="forYou" v-if="activeName == 'RECOMMEND_FOR_YOU'" :formData="formData" :slotData="promoteProductList"
                                 @onProuductSelect="onProuductSelect" @onConfirm="onConfirm"/>
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
  export default {
    name: 'PromoteProductPage',
    components: {
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
      handleClick (tab, event) {
        if (tab.name != 'carousel') {
          this.getProductPlate(tab.name);
        }
      },
      // tabBeforeLeave (nval, oval) {
      //   switch (this.activeName) {
      //     case 'carousel':
      //       if (this.$refs.carousel.count > 0) {
      //         return this._judge(nval);
      //       }
      //       break;
      //     case 'TODAY_NEW':
      //       if (this.$refs.today.count > 0) return this._judge(nval);
      //       break;
      //     case 'SEASON_HOT':
      //       if (this.$refs.season.count > 0) {
      //         return this._judge(nval);
      //       }
      //       break;
      //     case 'LIVE_BROADCAST_PROVIDE':
      //       if (this.$refs.live.count > 0) return this._judge(nval);
      //       break;
      //     case 'RECOMMEND_FOR_YOU':
      //       if (this.$refs.forYou.count > 0) return this._judge(nval);
      //       break;
      //     default :
      //       return true;
      //   }
      // },
      // _judge (nval) {
      //   return this.$confirm('是否切换标签 , 更改内容将不会被保存', '提示', {
      //     confirmButtonText: '离开页面',
      //     cancelButtonText: '留在页面',
      //     showClose: false,
      //     closeOnHashChange: false,
      //     type: 'warning'
      //   }).then(() => {
      //     this.getPageData(nval);
      //   })
      // },
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
        if (result.data != null) {
          this.formData = Object.assign({}, result.data);
        }
        if (activeName != 'carousel' && activeName != 'TODAY_NEW') {
          let productList = [];
          this.formData.sequenceProducts.forEach(item => {
            productList.push(item.product);
          })
          this.$store.state.PromoteProductModule.promoteProductList = Object.assign([], productList);
          this.promoteProductList = productList;
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
      },
      onProuductSelect () {
        this.productSelectVisible = true;
      },
      confirmPromoteProductList () {
        this.promoteProductList = this.$store.state.PromoteProductModule.promoteProductList;
        this.productSelectVisible = false;
      },
      // 提交当季爆款,直播专供,为你推荐
      async onConfirm (titleData) {
        let productList = this.$store.state.PromoteProductModule.promoteProductList;
        let productData = [];
        let item;
        for (let i = 0; i < productList.length; i++) {
          item = {
            sequence: i + 1,
            product: {
              id: productList[i].id
            }
          }
          productData.push(item);
        }
        titleData.sequenceProducts = productData;
        const url = this.apis().createProductPlate();
        const result = await this.$http.post(url, titleData);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('操作成功');
        this.getProductPlate(this.activeName);
      }
    },
    data () {
      return {
        carouselType: 'CT004',
        activeName: 'carousel',
        SeeProductPlateType: this.$store.state.EnumsModule.SeeProductPlateType,
        productSelectVisible: false,
        carouselData: [],
        promoteProductSeasonList: [],
        promoteProductLiveList: [],
        promoteProductForYouList: [],
        tipDialogVisible: false,
        status: false,
        isTabsLeave: false,
        toTab: '',
        seasonFormData: this.$store.state.PromoteProductModule.formData,
        liveFormData: {},
        forYouFormData: {},
        formData: {
          title: '',
          subtitle: '',
          picture: {},
          sequenceProducts: []
        },
        promoteProductList: []
      }
    },
    created () {
      this.onAdvancedSearch();
    }
    // beforeRouteLeave (to, from, next) {
    //   next(false);
    //   let flag;
    //   switch (this.activeName) {
    //     case 'carousel':
    //       flag = this.$refs.carousel.count > 0;
    //       break;
    //     case 'today':
    //       flag = this.$refs.today.count > 0;
    //       break;
    //     case 'season':
    //       flag = this.$refs.season.count > 0;
    //       break;
    //     case 'live':
    //       flag = this.$refs.live.count > 0;
    //       break;
    //     case 'forYou':
    //       flag = this.$refs.forYou.count > 0;
    //       break;
    //     default :
    //       flag = false;
    //   }
    //
    //   if (flag) {
    //     this.$confirm('是否离开此页面 , 更改内容将不会被保存', '提示', {
    //       confirmButtonText: '离开页面',
    //       cancelButtonText: '留在页面',
    //       type: 'warning',
    //       showClose: false,
    //       closeOnHashChange: false
    //     }).then(() => {
    //       next();
    //     }).catch(() => {
    //       throw new Error('取消成功！')
    //     })
    //   } else {
    //     next();
    //   }
    // }
  }
</script>

<style scoped>
  .orders-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
