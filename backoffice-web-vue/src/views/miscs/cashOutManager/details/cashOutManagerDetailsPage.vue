<template>
  <div class="animated fadeIn">
    <el-row type="flex" justify="end" v-show="!(slotData.amountStatus == 'IN_REVIEW' || slotData.amountStatus == 'REVIEWED')">
      <el-button type="primary" icon="el-icon-edit" @click="onCompleted(slotData)">确认</el-button>
      <el-button type="danger" icon="el-icon-delete" @click="onRejected(slotData)">拒绝</el-button>
    </el-row>
    <div class="pt-2"></div>
    <cash-out-manager-form ref="form" :slot-data="slotData" :read-only="isNewlyCreated"/>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>账户账单</span>
      </div>
      <bill-manager-list :page="page" @onDetails="onDetails" @onSearch="onAdvancedSearch"/>
    </el-card>
    <div class="pt-2"></div>
    <!--<operation-course-form-toolbar :read-only="isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel" @onUpdate="onUpdate"/>-->
  </div>


</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('CashOutManagerModule');

  import CashOutManagerForm from '../form/cashOutManagerForm';
  import BillManagerList from '../../bill/list/BillManagerList';

  export default {
    name: 'CashOutManagerDetailsPage',
    props: ['slotData'],
    components: {CashOutManagerForm, BillManagerList},
    methods: {
      ...mapActions({
        refresh: 'refresh',
        searchAdvanced: 'searchAdvancedBills'
      }),
      onAdvancedSearch (page, size) {
        this.isAdvancedSearch = true;
        var query = {
          keyword: this.keyword,
          // flowSource: ['CASH_OUT'],
          // amountFlowType: ['OUTFLOW'],
          // amountStatus: ['IN_REVIEW', 'REVIEWED', 'REJECTED']
          company: this.slotData.company.uid
        };
        const url = this.apis().findBills();
        this.searchAdvanced({url, query, page, size});
      },
      async onDetails (item) {
        const url = this.apis().getBill(item.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
        }
        console.log(result);
        this.fn.openSlider('明细：' + item.code, cashOutManagerDetailsPage, result);
      },
      async onRejected (item) {
        const url = this.apis().rejectedCashOut(item.id);
        const result = await this.$http.delete(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('拒绝提现' + item.amount + '成功');
        this.onAdvancedSearch();
      },

      async onCompleted (item) {
        const url = this.apis().completedCashOut(item.id);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('确认提现' + item.amount + '成功');
        this.onAdvancedSearch();
      },
      onCancel () {
        this.fn.closeSlider();
      }
    },
    computed: {
      ...mapGetters({
        page: 'billsPage',
        keyword: 'keyword'
      }),
      isNewlyCreated: function () {
        return this.slotData.id == null;
      }
    },
    data () {
      return {updateDialogVisible: false}
    },
    created(){
      this.onAdvancedSearch();
    }
  }
</script>
