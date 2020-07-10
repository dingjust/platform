<template>
  <div class="receipt-orders-page">
    <el-row>
      <el-col :span="4">
        <div class="title">
          <h6>收货单列表</h6>
        </div>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <receipt-orders-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" />
    <el-row type="flex" justify="space-between" align="middle">
      <el-col :span="22">
        <h6 style="color: #F56C6C;margin-bottom: 0px">{{this.tips}}</h6>
      </el-col>
      <el-col :span="2">
        <el-button class="check-btn" v-if="canCheck" @click="isStockIn">入库</el-button>
      </el-col>
    </el-row>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="item in statuses">
        <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
          <receipt-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail" />
        </el-tab-pane>
      </template>
    </el-tabs>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'ReceiptOrdersModule'
  );

  import ReceiptOrdersToolbar from './toolbar/ReceiptOrdersToolbar'
  import ReceiptOrdersList from './list/ReceiptOrdersList'

  export default {
    name: 'ReceiptOrdersPage',
    props: {
      mode: {
        type: String,
        default: 'import'
      }
    },
    components: {
      ReceiptOrdersToolbar,
      ReceiptOrdersList
    },
    computed: {
      ...mapGetters({
        keyword: 'keyword',
        page: 'page',
        formData: 'formData'
      }),
      canCheck: function () {
        // TODO 判断是否是发货方
        return true;
      }
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.apis().receiptOrderList();
        const mode = this.mode;
        const companyCode = this.currentUser.companyCode;
        this.search({
          url,
          keyword,
          page,
          size,
          mode,
          companyCode
        });
      },
      onAdvancedSearch(page, size) {
        const query = this.queryFormData;
        const url = this.apis().receiptOrderList();
        const mode = this.mode;
        const companyCode = this.currentUser.companyCode;
        this.searchAdvanced({
          url,
          query,
          page,
          size,
          mode,
          companyCode
        });
      },
      handleClick(tab, event) {
        this.queryFormData.states = tab.name;
        this.onAdvancedSearch(0, 10);
      },
      onDetail(row) {
        // TODO 发货单详情
        this.$router.push('/receipt/orders/' + row.id);
      },
      isStockIn () {
        // TODO 入库
      }
    },
    data() {
      return {
        activeName: '',
        currentUser: this.$store.getters.currentUser,
        statuses: [{
            code: '',
            name: '全部'
          }
        ],
        queryFormData: {
          keyword: '',
          cooperatorName: '',
          merchandiserName: '',
          createdDateFrom: '',
          createdDateTo: '',
          states: ''
        },
        tips: '注明：核验时间为收货单创建之日起5天内完成，若5天内没有操作收货单核验，收货单将自动完成核验。核验后的收货单不能修改。'
      }
    },
    created() {
      this.onSearch();
    },
    destroyed() {

    }
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .check-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
  }

  .receipt-orders-page>>>.el-form-item {
    margin-bottom: 0px;
  }

</style>
