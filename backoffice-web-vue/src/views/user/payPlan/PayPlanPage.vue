<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="payPlanDetailsDialogVisible" width="60%" height="100%" class="purchase-dialog"
      append-to-body :close-on-click-modal="false">
      <pay-plan-details-page :itemData="itemData" />
    </el-dialog>
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col>
          <div class="payPlan-list-title">
            <h6>账务方案列表</h6>
          </div>
        </el-col>
        <el-col :span="2">
          <div>
            <authorized :authority="permission.factoryPayplanCreate">
               <el-button type="primary" class="toolbar-search_input" @click="onJumpTo">添加新方案</el-button>
            </authorized>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <pay-plan-toolbar @onSearch="onSearch" />
      <hr />
      <pay-plan-search-result-list :page="page" @onSearch="onSearch" @onDetails="onDetails" @onEdit="onEdit"
        @onDelete="onDelete" />
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import PayPlanToolbar from './toolbar/PayPlanToolbar';
  import PayPlanSearchResultList from './list/PayPlanSearchResultList';
  import PayPlanDetailsPage from './detail/PayPlanDetailsPage';

  const {
    mapGetters,
    mapMutations,
    mapActions
  } = createNamespacedHelpers('PayPlanModule');

  export default {
    name: 'PayPlanPage',
    components: {
      PayPlanDetailsPage,
      PayPlanSearchResultList,
      PayPlanToolbar
    },
    computed: {
      ...mapGetters({
        page: 'page'
      })
    },
    methods: {
      ...mapMutations({
        setEditFormData: 'setEditFormData'
      }),
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch(page, size) {
        const url = this.apis().getPayPlans();
        this.searchAdvanced({
          url,
          page,
          size
        });
      },
      onJumpTo() {
        this.$router.push('/account/setting/payPlan/create');
      },
      async onDetails(item) {
        const url = this.apis().getPayPlan(item.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.itemData = result;

        this.payPlanDetailsDialogVisible = true;
      },
      async onDelete(item) {
        const url = this.apis().deletePayPlan(item.id);
        var result = this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
        } else {
          this.onSearch();
        }
      },
      async onEdit(item) {
        const url = this.apis().getPayPlan(item.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setEditFormData(result);

        this.$router.push('/account/setting/payPlan/update');
      }
    },
    data() {
      return {
        itemData: {},
        payPlanDetailsDialogVisible: false
      };
    },
    created() {
      this.onSearch();
    }
  };

</script>

<style scoped>
  .payPlan-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
