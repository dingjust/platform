<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="sales-plan-form-title">
            <h6>生产任务列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <production-task-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"
        @createOutboundOrder="createOutboundOrder" @createProductionOrder="createProductionOrder"/>
      <el-tabs v-model="activeStatus" @tab-click="handleClick">
        <template v-for="(item, index) in statues">
          <el-tab-pane :name="item.code" :key="index" :label="item.name">
            <production-task-list :page="page" @onSearch="onSearch"
                                  @onAdvancedSearch="onAdvancedSearch" @getSelectTaskList="getSelectTaskList"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
<!--    <el-dialog :visible.sync="outboundOrderTypeSelect" width="60%" class="purchase-dialog" append-to-body-->
<!--      :close-on-click-modal="false">-->
<!--      <outbound-order-type-select-form v-if="outboundOrderTypeSelect" :formData="formData" />-->
<!--    </el-dialog>-->
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'ProductionTasksModule'
  );

  import ProductionTaskToolbar from './toolbar/ProdcutionTaskToolbar';
  import ProductionTaskList from './list/ProductionTaskList';
  import OutboundOrderTypeSelectForm from '../outbound-order/form/OutboundOrderTypeSelectForm';
  export default {
    name: 'ProductionTaskPage',
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData',
        contentData: 'detailData'
      })
    },
    components: {
      OutboundOrderTypeSelectForm,
      ProductionTaskList,
      ProductionTaskToolbar
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
        clearQueryFormData: 'clearQueryFormData'
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch',
        setDetailData: 'detailData'
      }),
      handleClick(tab, event) {
        if (tab.name == 'ALL') {
          this.queryFormData.state = '';
          this.onAdvancedSearch();
        } else {
          this.queryFormData.state = tab.name;
          this.onAdvancedSearch();
        }
      },
      onSearch(page, size) {
        const keyword = this.keyword;
        const status = this.status;
        const url = this.apis().getProductionTaskList();
        this.setIsAdvancedSearch(false);
        this.search({
          url,
          keyword,
          status,
          page,
          size
        });
      },
      onAdvancedSearch(page, size) {
        this.setIsAdvancedSearch(true);
        const query = this.queryFormData;
        const url = this.apis().getProductionTaskList();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
      },
      getSelectTaskList (val) {
        this.selectTaskList = val;
      },
      createOutboundOrder () {
        // if (this.selectTaskList.length <= 0) {
        //   this.$message.warning('请先选择生产任务');
        //   return;
        // }
        // let row = {};
        // let entries = [];
        // this.selectTaskList.forEach(item => {
        //   row = {
        //     productionTask: {id: item.id},
        //     billPrice: '',
        //     expectedDeliveryDate: '',
        //     shippingAddress: item.productionEntry.shippingAddress,
        //     product: {
        //       id: item.productionEntry.product.id,
        //       name: item.productionEntry.product.name,
        //       thumbnail: item.productionEntry.product.thumbnail
        //     },
        //     colorSizeEntries: item.productionEntry.colorSizeEntries
        //   }
        //   entries.push(row);
        //   row = {};
        // })
        // this.formData.entries = entries;
        // this.outboundOrderTypeSelect = true;
        this.$router.push({
          name: '创建外发订单',
          params: {
            formData: this.formData
          }
        });
      },
      createProductionOrder () {
        this.$router.push('/sales/create/productionOrder');
      }
    },
    data () {
      return {
        activeStatus: 'ALL',
        outboundOrderTypeSelect: false,
        selectTaskList: [],
        formData: this.$store.state.OutboundOrderModule.formData,
        statues: [{
          code: 'ALL',
          name: '全部'
        }],
      }
    },
    created() {
      this.$store.state.EnumsModule.ProductionState.forEach(element => {
        this.statues.push(element);
      });
      this.onSearch();
    },
    destroyed() {
      this.clearQueryFormData();
    }
  }
</script>

<style scoped>
  .sales-plan-form-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
