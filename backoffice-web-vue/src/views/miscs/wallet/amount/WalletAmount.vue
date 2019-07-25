<template>
  <el-form ref="form" label-position="top" :model="walletData">
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card shadow="hover">
          总金额：<span>{{sum}}</span>
        </el-card>
        <!--<el-form-item label="总金额">-->
          <!--<el-input type="text" :rows="2" :value="sum"></el-input>-->
        <!--</el-form-item>-->
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          可提现金额：<span>{{walletData.canCashOut}}</span>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          提现中金额：<span>{{walletData.cashOuting}}</span>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          未结算金额：<span>{{walletData.auditing}}</span>
        </el-card>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapMutations, mapGetters} = createNamespacedHelpers('WalletModule');

  export default {
    name: 'WalletAmount',
    components: {},
    props: ['walletData'],
    computed: {
      ...mapGetters({
        // walletData: 'walletData'
      }),
      sum: function () {
        return this.walletData.auditing + this.walletData.canCashOut + this.walletData.cashOuting;
      }
    },
    methods: {
      ...mapMutations({

      }),
    },
    data () {
      return {
      }
    },
  }
</script>
