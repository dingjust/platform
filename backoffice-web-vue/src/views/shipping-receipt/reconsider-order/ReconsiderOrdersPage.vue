<template>
  <div>
    <reconsider-orders-toolbar :queryFormData="queryFormData" :ableToApply="ableToApply"
      @onAdvancedSearch="onAdvancedSearch" @onApply="onApply" />
    <el-row type="flex" justify="start">
      <h6 style="color: #F56C6C">注明：待复议中的发货订单，申请复议时间为5天，如5天内没有申请复议，则视为放弃复议，此发货单将不再接受复议</h6>
    </el-row>
    <!-- <div class="over-tabs"> -->
    <!-- <el-row type="flex" justify="end" v-show="canReconsider">
      <el-button v-show="activeName=='PENDING_RECONSIDER'" class="material-btn" @click="onReconsider">申请复议</el-button>
    </el-row> -->
    <!-- </div> -->
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="(map,states) in statusMap">
        <el-tab-pane :label="tabName(map)" :name="states" :key="states">
          <shipping-dynamic-table :page="page" :columns="map.columns" @onAdvancedSearch="onAdvancedSearch"
            @onSelect="onSelect" />
        </el-tab-pane>
      </template>
    </el-tabs>
  </div>
</template>

<script>
  import ReconsiderOrdersToolbar from "./toolbar/ReconsiderOrdersToolbar";
  import ReconsiderOrdersList from "./list/ReconsiderOrdersList";

  import {
    ShippingDynamicTable
  } from "../components/index";

  export default {
    name: "ReconsiderOrdersPage",
    props: {
      page: {
        type: Object,
        required: true
      },
      queryFormData: {
        type: Object,
        required: true
      },
      statusMap: {
        type: Object,
        required: true
      },
      currentState: {
        type: String,
        default: 'PENDING_RECONSIDER'
      },
      canReconsider: {
        type: Boolean,
        default: true
      },
      mode: {
        type: String,
        default: 'import'
      }
    },
    components: {
      ReconsiderOrdersToolbar,
      ReconsiderOrdersList,
      ShippingDynamicTable
    },
    computed: {
      ableToApply: function () {
        return this.activeName == "first";
      }
    },
    methods: {
      getStatusVal(state) {
        return this.getEnum("ShippingSheetState", state);
      },
      handleClick(tab, event) {
        this.$emit("handleClick", {
          states: this.statusMap[tab.name].states,
          searchUrl: this.statusMap[tab.name].url
        });
      },
      onSearch(page, size) {
        this.$emit("onSearch");
      },
      onAdvancedSearch(page, size) {
        this.$emit("onAdvancedSearch");
        this.shippingOrderStateCount();
        this.reconsiderOrderStateCount();
      },
      onApply() {},
      onDetail() {},
      onSelect(val) {
        this.selectedData = val;
      },
      //复议
      onReconsider() {
        if (this.selectedData != null && this.selectedData.id != null) {
          this.$router.push("/reconsiders/create/orders/" + this.selectedData.id);
        } else {
          this.$message("请选择发货单复议");
        }
      },
      tabName(map) {
        if (map.url == '/b2b/sheets/shipping' && this.stateCount.shipping.hasOwnProperty(map.states)) {
          return this.getEnum('ShippingSheetState', map.states) + '(' + this.stateCount.shipping[map.states] + ')';
        }
        if (map.url == '/b2b/sheets/reconsider' && this.stateCount.reconsider.hasOwnProperty(map.states)) {
          return this.getEnum('ShippingSheetState', map.states) + '(' + this.stateCount.reconsider[map.states] + ')';
        }
        return this.getEnum('ShippingSheetState', map.states);
      },
      // 查询发货单状态统计
      async shippingOrderStateCount() {
        let query = Object.assign({}, this.queryFormData);
        query.states = '';
        if (this.mode == 'import') {
          query['shipParty'] = this.$store.getters.currentUser.companyCode;
        } else {
          query['receiveParty'] = this.$store.getters.currentUser.companyCode;
        }

        const url = this.apis().shippingOrderStateCount();
        const result = await this.$http.post(url, query);
        if (result['errors']) {
          this.stateCount = {};
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.stateCount = {};
          this.$message.error(result.msg);
          return;
        }
        this.$set(this.stateCount, 'shipping', result.data);
      },
      // 查询复议单状态统计
      async reconsiderOrderStateCount() {
        let query = Object.assign({}, this.queryFormData);
        query.states = '';
        if (this.mode == 'import') {
          query['shipParty'] = this.$store.getters.currentUser.companyCode;
        } else {
          query['receiveParty'] = this.$store.getters.currentUser.companyCode;
        }

        const url = this.apis().reconsiderOrderStateCount();
        const result = await this.$http.post(url, query);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$set(this.stateCount, 'reconsider', result.data);
      }
    },
    created() {
      this.shippingOrderStateCount();
      this.reconsiderOrderStateCount();
    },
    data() {
      return {
        stateCount: {
          shipping: {},
          reconsider: {}
        },
        activeName: this.currentState,
        selectedData: ""
      };
    }
  };

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 30px;
    margin-top: 2px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #ffd5ce;
    color: #000;
    width: 120px;
    height: 35px;
  }

</style>
