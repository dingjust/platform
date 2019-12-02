<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="2">
          <div class="orders-list-title">
            <h6>收货</h6>
          </div>
        </el-col>
        <!-- <el-col :span="4"> -->
          <el-button >导出</el-button>
        <!-- </el-col> -->
      </el-row>
      <!-- <purchase-order-toolbar @onNew="onNew" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" />
      <el-tabs v-model="activeStatus" @tab-click="handleClick">
        <template v-for="(item, index) in statues">
          <el-tab-pane :name="item.code" :key="index">
            <span slot="label">
              <tab-label-bubble :label="item.name" :num="0" />
            </span>
            <purchase-order-search-result-list :page="page" @onDetails="onDetails" @onSearch="onSearch"
              @onAdvancedSearch="onAdvancedSearch" />
          </el-tab-pane>
        </template>
      </el-tabs> -->
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
    "ReceiptReportModule"
  );

  import http from '@/common/js/http';

  export default {
    name: "PurchaseOrderPage",
    components: {

    },
    computed: {
      // ...mapGetters({
      //   page: "page",
      //   keyword: "keyword",
      //   queryFormData: "queryFormData",
      //   contentData:"detailData"
      // })
    },
    methods: {
      // ...mapActions({
      //   search: "search",
      //   searchAdvanced: "searchAdvanced",        
      // }),
      // ...mapMutations({
      //   setIsAdvancedSearch: "isAdvancedSearch",
      //   setDetailData:'detailData'
      // }),
      // onSearch(page, size) {
      //   const keyword = this.keyword;
      //   const statuses = this.statuses;
      //   const url = this.apis().getPurchaseOrders();
      //   this.setIsAdvancedSearch(false);
      //   this.search({
      //     url,
      //     keyword,
      //     statuses,
      //     page,
      //     size
      //   });
      // },
      // onAdvancedSearch(page, size) {
      //   this.setIsAdvancedSearch(true);
      //   const query = this.queryFormData;
      //   const url = this.apis().getPurchaseOrders();
      //   this.searchAdvanced({
      //     url,
      //     query,
      //     page,
      //     size
      //   });
      // },
    },
    data() {
      return {        
        // formData: this.$store.state.PurchaseOrdersModule.formData,        
      };
    },
    created() {
      // this.onSearch();
    },
    mounted() {

    }
  };

</script>
<style scoped>
  .report {
    margin-bottom: 10px;
  }

  .orders-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .purchase-dialog .el-dialog {
    border-radius: 10px !important;
  }

  .purchase-dialog-header {
    padding: 0px !important;
  }

  .purchase-dialog .el-dialog__header {
    padding: 0px !important;
  }

</style>
