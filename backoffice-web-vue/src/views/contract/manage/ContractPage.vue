<template>
  <div class="animated fadeIn content">
    <div class="report">
      <contract-report />
    </div>
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="orders-list-title">
            <h6>合同列表</h6>
          </div>
        </el-col>
      </el-row>
      <contract-toolbar @onNew="onNew" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" />
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="(item, index) in contractStatues">
          <el-tab-pane :name="item">
            <span slot="label">
              <tab-label-bubble :label="item" :num="index" />
            </span>
            <contract-search-result-list :page="page" @onDetails="onDetails" @onSearch="onSearch"
              @onAdvancedSearch="onAdvancedSearch" />
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from "vuex";

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    "PurchaseOrdersModule"
  );

  import ContractToolbar from "./toolbar/ContractToolbar";
  import ContractSearchResultList from "./list/ContractSearchResultList";
  import ContractReport from "./components/ContractReport";
  import TabLabelBubble from "@/components/custom/TabLabelBubble";
  // import PurchaseOrderDetailsPage from "./details/PurchaseOrderDetailsPage";

  export default {
    name: "PurchaseOrderPage",
    components: {
      ContractToolbar,
      ContractSearchResultList,
      ContractReport,
      TabLabelBubble
    },
    computed: {
      ...mapGetters({
        page: "page",
        keyword: "keyword",
        queryFormData: "queryFormData"
      })
    },
    methods: {
      ...mapActions({
        search: "search",
        searchAdvanced: "searchAdvanced"
      }),
      ...mapMutations({
        setIsAdvancedSearch: "isAdvancedSearch"
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const statuses = this.statuses;
        const url = this.apis().getPurchaseOrders();
        this.setIsAdvancedSearch(false);
        this.search({
          url,
          keyword,
          statuses,
          page,
          size
        });
      },
      onAdvancedSearch(page, size) {
        this.setIsAdvancedSearch(true);
        const query = this.queryFormData;
        const url = this.apis().getPurchaseOrders();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
      },
      async onDetails(row) {
        const url = this.apis().getPurchaseOrder(row.code);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        // this.fn.openSlider('生产订单：' + result.code, PurchaseOrderDetailsPage, result);
      },
      onNew(formData) {
        // this.fn.openSlider('创建手工单', PurchaseOrderDetailsPage, formData);
      },
      handleClick(tab, event) {
        console.log(tab, event);
      }
    },
    data() {
      return {
        formData: this.$store.state.PurchaseOrdersModule.formData,
        activeName: "全部",
        contractStatues: ["全部", "待签署", "待回签", "已完成", "已作废"]
      };
    },
    created() {
      this.onSearch("");
    }
  };

</script>
<style>
  .report {
    margin-bottom: 10px;
  }

  .el-tabs__active-bar {
    background-color: #ffd60c;
    color: #ffd60c;
  }

  .el-tabs__item.is-active {
    color: #ffd60c;
  }

  .el-tabs__item:hover {
    color: #ffd60c;
  }

  .orders-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
