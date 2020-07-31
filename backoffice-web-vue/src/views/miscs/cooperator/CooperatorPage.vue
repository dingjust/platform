<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="cooperatorDetailsDialogVisible" @close="onDialogClose" width="80%"
               class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <cooperator-details-page :itemData="itemData"
                               @onSearch="onSearch"
                               @onDetails="onDetails"
                               @onDelete="onDelete"
                               @onSearchOrders="onSearchOrders"
      />
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
            <el-button type="primary" class="toolbar-search_input" @click="onJumpTo">添加合作商</el-button>
          </div>
        </el-col>
      </el-row>
      <cooperator-toolbar @onSearch="onSearch" @onDetail="onDetails"/>
      <el-row>
        <!--<el-col :span="1">-->
        <!--<div>-->
        <!--<h6>类型：</h6>-->
        <!--</div>-->
        <!--</el-col>-->
        <el-tabs v-model="activeStatus" @tab-click="handleClick">
          <template v-for="(item, index) in statues">
            <el-tab-pane :name="item.code">
            <span slot="label">
              <tab-label-bubble :label="item.name" :num="0" />
            </span>
              <cooperator-search-result-list :page="page" @onSearch="onSearch" @onAdvancedSearch="onSearch"
              @onDetails="onDetails" @onDelete="onDelete" @onEdit="onEdit"/>
            </el-tab-pane>
          </template>
        </el-tabs>
      </el-row>

    </el-card>
  </div>

</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  const {mapGetters, mapActions, mapMutations} = createNamespacedHelpers('CooperatorModule');
  import CooperatorToolbar from '@/views/miscs/cooperator/toolbar/CooperatorToolbar';
  import CooperatorSearchResultList from '@/views/miscs/cooperator/list/CooperatorSearchResultList';
  import TabLabelBubble from '@/components/custom/TabLabelBubble';
  import CooperatorDetailsPage from '@/views/miscs/cooperator/details/CooperatorDetailsPage';

  export default {
    name: 'CooperatorPage',
    props: [],
    components: {CooperatorDetailsPage, CooperatorToolbar, CooperatorSearchResultList, TabLabelBubble},
    computed: {
      ...mapGetters({
        page: 'page',
        queryFormData: 'queryFormData',
        ordersQueryFormData: 'ordersQueryFormData'
      })
    },
    methods: {
      ...mapMutations({
        setOrdersPageNumber: 'setOrdersPageNumber',
        setOrdersPageSize: 'setOrdersPageSize',
        setEditFormData: 'setEditFormData'
      }),
      ...mapActions({
        searchAdvanced: 'searchAdvanced',
        searchOrdersAdvanced: 'searchOrdersAdvanced',
        clearOrderPageData: 'clearOrderPageData'
      }),
      onSearch (page, size) {
        const queryFormData = this.queryFormData;

        const url = this.apis().getCooperators();
        this.searchAdvanced({url, queryFormData, page, size});
      },
      async onDetails (item) {
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
      async onSearchOrders (page, size) {
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

        this.searchOrdersAdvanced({url});
        // if (result['errors']) {
        //   this.$message.error(result['errors'][0].message);
        // }
      },
      async onDelete (item) {
        const url = this.apis().deleteCooperator(item.id);
        var result = this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.onSearch();
      },
      handleClick (tab, event) {
        // console.log(tab.name);
        if (tab.name === 'ALL') {
          this.queryFormData.type = null;
        } else {
          this.queryFormData.type = [tab.name];
        }
        this.onSearch();
      },
      onJumpTo () {
        this.$router.push('/account/cooperator/cooperatorCreate');
      },
      onDialogClose(){
        this.clearOrderPageData();
      },
      async onEdit(item){
        const url = this.apis().getCooperator(item.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setEditFormData(result);

        this.$router.push('/account/cooperator/cooperatorUpdate');
      }
    },
    data () {
      return {
        itemData: {},
        cooperatorDetailsDialogVisible: false,
        activeStatus: 'ALL',
        statues: [{
          code: 'ALL',
          name: '全部'
        }]
      };
    },
    created () {
      this.$store.state.EnumsModule.CooperatorType.forEach(element => {
        this.statues.push(element);
      });
      // Bus.$on('my-event', args => {
      //   this.dialogDetailVisible = !this.dialogDetailVisible;
      // }),

      this.onSearch();
    }
  };
</script>

<style scoped>
  .cooperator-list-title1 {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
