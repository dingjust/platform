<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="dialogTableVisible" width="80%">
      <contract-details  :slotData="contractData" />
    </el-dialog>
    <!--<div class="report">-->
      <!--<contract-report />-->
    <!--</div>-->
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="orders-list-title">
            <h6>合同列表</h6>
          </div>
        </el-col>
      </el-row>
      <contract-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="(item, index) in contractStatues">
          <el-tab-pane :name="item">
            <span slot="label">
              <tab-label-bubble :label="item" :num="index" />
            </span>
            <contract-search-result-list :page="page" @onDetails="onDetails" @onSearch="onSearch" />
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
    "ContractModule"
  );

  import ContractToolbar from "./toolbar/ContractToolbar";
  import ContractSearchResultList from "./list/ContractSearchResultList";
  import ContractReport from "./components/ContractReport";
  import ContractDetails from "./components/ContractDetails";
  import TabLabelBubble from "./components/TabLabelBubble";

  // import PurchaseOrderDetailsPage from "./details/PurchaseOrderDetailsPage";

  export default {
    name: "ContractPage",
    components: {
      ContractToolbar,
      ContractSearchResultList,
      ContractReport,
      TabLabelBubble,
      ContractDetails,
    },
    provide:{
        onSearch: this.onSearch
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
      }),
      ...mapMutations({
      }),
      onSearch(page, size) {
        console.log(1111)
        const keyword = this.keyword;
        const statuses = this.state;
        console.log(statuses);
        const url = this.apis().getContractsList();
        this.search({
          url,
          keyword,
          statuses,
          page,
          size
        });
      },
      // onAdvancedSearch(page, size) {
      //   this.setIsAdvancedSearch(true);
      //   const query = this.queryFormData;
      //   const url = this.apis().getContracts();
      //   this.searchAdvanced({
      //     url,
      //     query,
      //     page,
      //     size
      //   });
      // },
      async onDetails(row) {
        const url = this.apis().getContractDetail(row.code);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        console.log(result);
        // this.fn.openSlider('生产订单：' + result.code, PurchaseOrderDetailsPage, result);
        this.contractData = result.data;
        this.dialogTableVisible = true;
      },
      onNew(formData) {
        // this.fn.openSlider('创建手工单', PurchaseOrderDetailsPage, formData);
      },
      handleClick(tab, event) {
        this.state = this.getEnumCode(tab.name);
        if (tab.name == 'ALL') {
          this.state = '';
          this.onSearch("");
        } else {
          this.onSearch('');
        }
      },
      getEnumCode (name) {
        if(name == '待签署'){
          return 'SIGN'
        }
        if(name == '已完成'){
          return 'COMPLETE'
        }
        if(name == '已作废'){
          return 'INVALID'
        }
      }
    },
    data() {
      return {
        formData: this.$store.state.PurchaseOrdersModule.formData,
        activeName: "全部",
        contractStatues: ["全部", "待签署", "已完成", "已作废"],
        dialogTableVisible:false,
        contractData:'',
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
