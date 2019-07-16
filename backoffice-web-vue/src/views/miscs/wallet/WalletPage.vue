<template>
  <div class="animated fadeIn content">
    <el-card>
      <wallet-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <wallet-list :page="page" @onDetails="onDetails" @onCanceled="onCanceled" @onSearch="onSearch"/>
    </el-card>

  <el-dialog title="提现" width="450px" :visible.sync="this.cashOutView" :before-close="handleClose"
             append-to-body>
    <el-input-number v-model="amount"></el-input-number>
    <div slot="footer" class="dialog-footer">
      <el-button @click="handleClose">取 消</el-button>
      <el-button type="primary" @click="cashOutApply()">确 定</el-button>
    </div>
  </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('WalletModule');

  import WalletToolbar from './toolbar/WalletToolbar';
  import WalletList from './list/WalletList';

  export default {
    name: 'WalletPage',
    components: {
      WalletToolbar,
      WalletList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword'
      })
    },
    methods: {
      ...mapActions({
        search: 'search'
      }),
      onSearch (page, size) {
        const keyword = this.keyword;
        const url = this.apis().findBills();
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch (page, size) {
        this.setIsAdvancedSearch(true);
        const query = this.queryFormData;
        const url = this.apis().findBills();
        this.searchAdvanced({url, query, page, size});
      },
      async onDetails (item) {
        const url = this.apis().getAmountFlowDetail(item.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

      // this.fn.openSlider('明细：' + item.name, WalletDetailsPage, result);
      },
      async onCanceled (item) {
        const url = this.apis().cashOutCanceled(item.id);
        const result = await this.$http.delete(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('删除问题' + item.name + '成功');
        this.onSearch();
      },

      onNew () {
        this.cashOutView = true;
      },
      handleClose (done) {
        this.cashOutView = false;
      },
      async cashOutApply () {
        const url = this.apis().cashOutApply(this.amount);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('申请提现' + this.amount + '成功');
        console.log(this.amount);
        this.cashOutView = false;
      }
    },
    data () {
      return {
        amount: 0,
        cashOutView: false
      };
    },
    created () {
      this.onSearch();
    }
  };
</script>
