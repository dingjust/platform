<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="orders-list-title">
            <h6>订单列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <sales-order-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" />
      <el-tabs v-model="activeStatus" @tab-click="handleClick">
        <template v-for="(item, index) in statues">
          <el-tab-pane :name="item.code" :key="index">
            <span slot="label">
              <tab-label-bubble :label="item.name" :num="0" />
            </span>
            <sales-order-search-result-list :page="page" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"
                                            @cannelOrder="cannelOrder" @remindDelivery="remindDelivery"
                                            @confirmDelivery="confirmDelivery" @onDeliveryForm="onDeliveryForm"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
    <el-dialog :visible.sync="deliveryFormShow" width="75%"
               class="purchase-dialog" :close-on-click-modal="false">
      <delivery-form v-if="deliveryFormShow" @onSubmit="onDeliverySubmit" :slotData="deliveryData"/>
    </el-dialog>
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
    'SalesOrdersModule'
  );

  import SalesOrderToolbar from './toolbar/SalesOrderToolbar';
  import SalesOrderSearchResultList from './list/SalesOrderSearchResultList';
  import TabLabelBubble from '@/components/custom/TabLabelBubble';
  import DeliveryForm from "./form/DeliveryForm";

  export default {
    name: 'SalesOrderPage',
    components: {
      DeliveryForm,
      SalesOrderToolbar,
      SalesOrderSearchResultList,
      TabLabelBubble
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData',
        contentData: 'detailData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch',
        setDetailData: 'detailData'
      }),
      async onSearch (page, size) {
        const keyword = this.keyword;
        const statuses = this.statuses;
        const url = this.apis().getSalesOrderList();
        this.setIsAdvancedSearch(false);
        this.search({
          url,
          keyword,
          statuses,
          page,
          size
        });
      },
      onAdvancedSearch (page, size) {
        this.setIsAdvancedSearch(true);
        const query = this.queryFormData;
        const url = this.apis().getSalesOrderList();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
      },
      handleClick (tab, event) {
        console.log(tab.name);
        if (tab.name == 'ALL') {
          this.queryFormData.statuses = [];
          this.queryFormData.refunding = '';
          this.onSearch('');
        } else if (tab.name == 'PENDING_RETURN') {
          this.queryFormData.statuses = [];
          this.queryFormData.refunding = true;
          this.onAdvancedSearch();
        } else {
          this.queryFormData.statuses = [tab.name];
          this.queryFormData.refunding = false;
          this.onAdvancedSearch();
        }
      },
      async onDeliveryForm (row) {
        const url = this.apis().getSalesOrderDetails(row.code);
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.deliveryData = Object.assign({}, result);
        this.deliveryFormShow = true;
      },
      async onDeliverySubmit (formData) {
        const url = this.apis().updateConsignment(this.deliveryData.code);
        const result = await this.$http.post(url, formData);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.onAdvancedSearch();
        this.deliveryFormShow = false;
      },
      async cannelOrder (row) {
        const url = this.apis().cannelSalesOrder(row.code);
        const result = await this.$http.put(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('取消订单成功！')
        this.onAdvancedSearch();
      },
      async remindDelivery (row) {
        const url = this.apis().reminderSalesOrderDelivery(row.code);
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('提醒发货成功！')
      },
      async confirmDelivery (row) {
        const url = this.apis().confirmReceived(row.code);
        const result = await this.$http.put(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('确认收货成功！')
        this.onAdvancedSearch();
      }
    },
    data () {
      return {
        formData: this.$store.state.SalesOrdersModule.formData,
        activeStatus: 'ALL',
        statues: [{
          code: 'ALL',
          name: '全部'
        }],
        deliveryFormShow: false,
        deliveryData: {}
      };
    },
    created () {
      this.onSearch();
      this.$store.state.EnumsModule.salesOrderStatuses.forEach(element => {
        this.statues.push(element);
      });
    },
    mounted () {

    }
  };
</script>
<style>
  .report {
    margin-bottom: 10px;
  }
</style>
