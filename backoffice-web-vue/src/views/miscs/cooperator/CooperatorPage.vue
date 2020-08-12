<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="cooperatorDetailsDialogVisible" @close="onDialogClose" width="80%" class="purchase-dialog"
      append-to-body :close-on-click-modal="false">
      <cooperator-details-page :itemData="itemData" @onSearch="onSearch" @onDetails="onDetails" @onDelete="onDelete"
        @onSearchOrders="onSearchOrders" />
    </el-dialog>
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col>
          <div class="cooperator-list-title1">
            <h6>合作商列表</h6>
          </div>
        </el-col>
        <el-col :span="2">
          <div>
            <Authorized :permission="['COMPANY_COOPERATOR_CREATE']">
                  <el-button type="primary" class="toolbar-search_input" @click="onJumpTo">添加合作商</el-button>
            </Authorized>
          </div>
        </el-col>
      </el-row>
      <cooperator-toolbar @onSearch="onSearch" @onDetail="onDetails" />
      <el-row type="flex" style="margin-bottom:10px">
        <h6 style="color:#9da0a8">类型：</h6>
        <template v-for="item in statues">
          <h6 :key="item.name" class="type-btn" :class="{'active':item.code==activeStatus}"
            @click="onStatusClick(item)">{{item.name}}</h6>
        </template>
      </el-row>
      <el-tabs v-model="activeCategory" @tab-click="handleClick" type="card">
        <template v-for="(item, index) in cooperatorCategories">
          <el-tab-pane :name="item.code" :key="'pane'+index" :label="item.name">
            <cooperator-search-result-list :page="page" @onSearch="onSearch" @onAdvancedSearch="onSearch"
              @onDetails="onDetails" @onDelete="onDelete" @onEdit="onEdit" />
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
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
  } = createNamespacedHelpers('CooperatorModule');
  import CooperatorToolbar from '@/views/miscs/cooperator/toolbar/CooperatorToolbar';
  import CooperatorSearchResultList from '@/views/miscs/cooperator/list/CooperatorSearchResultList';
  import TabLabelBubble from '@/components/custom/TabLabelBubble';
  import CooperatorDetailsPage from '@/views/miscs/cooperator/details/CooperatorDetailsPage';

  export default {
    name: 'CooperatorPage',
    props: [],
    components: {
      CooperatorDetailsPage,
      CooperatorToolbar,
      CooperatorSearchResultList,
      TabLabelBubble
    },
    computed: {
      ...mapGetters({
        page: 'page',
        ordersQueryFormData: 'ordersQueryFormData'
      })
    },
    methods: {
      ...mapMutations({
        setOrdersPageNumber: 'setOrdersPageNumber',
        setOrdersPageSize: 'setOrdersPageSize',
        setFormData: 'setFormData'
      }),
      ...mapActions({
        searchAdvanced: 'searchAdvanced',
        searchOrdersAdvanced: 'searchOrdersAdvanced',
        clearOrderPageData: 'clearOrderPageData',
        clearFormData:'clearFormData'
      }),
      onSearch(page, size) {
        const queryFormData = this.queryFormData;
        const url = this.apis().getCooperators();
        this.searchAdvanced({
          url,
          queryFormData,
          page,
          size
        });
      },
      async onDetails(item) {
        const url = this.apis().getCooperator(item.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.itemData = result;

        this.cooperatorDetailsDialogVisible = true;
        //查询合作过的订单
        this.onSearchOrders(0, 8);
      },
      async onSearchOrders(page, size) {
        if (page != null) {
          this.setOrdersPageNumber(page);
        }
        if (size != null) {
          this.setOrdersPageSize(size);
        }

        const url = this.apis().getPurchaseOrders();
        if (this.isFactory() && this.itemData.type === 'ONLINE') {
          this.ordersQueryFormData.purchasers = [this.itemData.partner.uid];
        } else if (this.isBrand() && this.itemData.type === 'ONLINE') {
          this.ordersQueryFormData.belongTos = [this.itemData.partner.uid];
        }
        this.searchOrdersAdvanced({
          url
        });
      },
      async onDelete(item) {
        const url = this.apis().deleteCooperator(item.id);
        var result = this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.onSearch();
      },
      handleClick(tab, event) {
        this.queryFormData.category = [tab.name];
        this.onSearch();
      },
      //线上线下类型类型选择
      onStatusClick(item) {
        this.activeStatus = item.code;
        if (item.code === 'ALL') {
          this.queryFormData.type = null;
        } else {
          this.queryFormData.type = [item.code];
        }
        this.onSearch();
      },
      onJumpTo() {
        //重置formData
        this.clearFormData();
        this.$router.push('/account/cooperator/cooperatorCreate');
      },
      onDialogClose() {
        this.clearOrderPageData();
      },
      async onEdit(item) {
        const url = this.apis().getCooperator(item.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setFormData(result);

        this.$router.push('/account/cooperator/cooperatorUpdate');
      }
    },
    data() {
      return {
        itemData: {},
        cooperatorDetailsDialogVisible: false,
        activeStatus: 'ALL',
        statues: [{
          code: 'ALL',
          name: '全部'
        }],
        activeCategory: 'SUPPLIER',
        cooperatorCategories: this.$store.state.EnumsModule.CooperatorCategory,
        queryFormData: {
          type: '',
          keyword: '',
          category:['SUPPLIER']
        },
      };
    },
    created() {
      this.$store.state.EnumsModule.CooperatorType.forEach(element => {
        this.statues.push(element);
      });
      this.onSearch();
    }
  };

</script>

<style scoped>
  .cooperator-list-title1 {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .type-btn {
    margin-right: 15px;
    color: #9da0a8;
  }

  .type-btn:hover {
    cursor: pointer;
  }

  .active {
    color: #ffd60c;
  }

</style>
