<template>
  <div class="animated fadeIn">
    <el-row>
      <el-col :span="4">
        <div class="title">
          <h6>退货单列表</h6>
        </div>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <return-orders-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" />
    <div>
      <div class="good-btn">
        <el-button class="check-btn" v-if="canClick" @click="onReceiptReturn">收退货</el-button>
      </div>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
            <return-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail" />
          </el-tab-pane>
        </template>
      </el-tabs>
    </div>
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
    'ReturnOrdersModule'
  );

  import ReturnOrdersToolbar from './toolbar/ReturnOrdersToolbar'
  import ReturnOrdersList from './list/ReturnOrdersList'

  export default {
    name: 'ReturnOrdersPage',
    props: {
      mode: {
        type: String,
        default: 'import'
      }
    },
    components: {
      ReturnOrdersToolbar,
      ReturnOrdersList
    },
    computed: {
      ...mapGetters({
        keyword: 'keyword',
        page: 'page',
        formData: 'formData'
      }),
      canClick: function () {
        // TODO 判断
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
        const url = this.apis().returnOrderList();
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
        const url = this.apis().returnOrderList();
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
        this.queryFormData.status = tab.name;
        this.onAdvancedSearch(0, 10);
      },
      onDetail(row) {
        // 退单详情
        this.$router.push('/returned/orders/' + row.id);
      },
      onReceiptReturn() {

      }
    },
    data() {
      return {
        activeName: '',
        currentUser: this.$store.getters.currentUser,
        statuses: [{
            code: '',
            name: '全部'
          },
          {
            code: '1',
            name: '退货待收'
          },
          {
            code: '2',
            name: '退货已收'
          }
        ],
        queryFormData: {
          keyword: '',
          productionLeaderName: '',
          operatorName: '',
          creationtimeStart: '',
          creationtimeEnd: '',
          status: ''
        }
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

  .good-btn {
    position: absolute;
    right: 20px;
    z-index: 999;
  }

  .check-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
  }

</style>
