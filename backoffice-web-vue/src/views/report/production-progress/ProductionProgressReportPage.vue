<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="orders-list-title">
            <h6>生产进度</h6>
          </div>
        </el-col>
      </el-row>
      <production-progress-report-toolbar  @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" />
      <production-progress-report-list :page="page" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" />
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
    "ProductionProgressReportModule"
  );

  import ProductionProgressReportToolbar from "./toolbar/ProductionProgressReportToolbar";
  import ProductionProgressReportList from "./list/ProductionProgressReportList";
  import http from '@/common/js/http';

  export default {
    name: "ProductionProgressReportPage",
    components: {
      ProductionProgressReportList,
      ProductionProgressReportToolbar
    },
    computed: {
      ...mapGetters({
        page: "page",
        keyword: "keyword",
        queryFormData: "queryFormData",
        contentData: "detailData"
      })
    },
    methods: {
      ...mapActions({
        search: "search",
        searchAdvanced: "searchAdvanced",
      }),
      ...mapMutations({
        setIsAdvancedSearch: "isAdvancedSearch",
        setDetailData: 'detailData'
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
    },
    data() {
      return {
        contracts: [],
      };
    },
    created() {
      this.onSearch();
    },
    mounted() {

    }
  };

</script>
<style>
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
