<template>
  <div>
		<el-row type="flex" align="middle" v-if="form.isHaveDeposit">
			<el-col :span="6">
				<h6 class="payPlan-label">定金</h6>
			</el-col>
			<el-col :span="18">
				<el-row type="flex" align="middle" justify="start">
					<h6 class="basic-label">{{triggerEvent[form.deposit.event]}}后{{form.deposit.time}}天以内支付总额的{{Math.ceil(form.deposit.percent)}}%作为定金</h6>
				</el-row>
			</el-col>
		</el-row>
		<el-row type="flex" align="middle" v-if="form.payPlanType!='MONTHLY_SETTLEMENT'">
			<el-col :span="6">
				<h6 class="payPlan-label">第1期尾款</h6>
			</el-col>
			<el-col :span="18">
				<el-row type="flex" align="middle" justify="start">
					<h6 class="basic-label">{{triggerEvent[form.balance1.event]}}后时长{{form.balance1.time}}天以内
						<span v-if="form.payPlanType != 'PHASEONE'">支付总额的{{Math.ceil(form.balance1.percent)}}%</span>
						<span v-else>支付剩余全部款项</span>
					</h6>
				</el-row>
			</el-col>
		</el-row>
		<el-row type="flex" align="middle" v-if="form.payPlanType=='PHASETWO'">
			<el-col :span="6">
				<h6 class="payPlan-label">第2期尾款</h6>
			</el-col>
			<el-col :span="18">
				<el-row type="flex" align="middle" justify="start">
					<!-- <h6>{{triggerEvent[form.balance2.event]}}后时长{{form.balance2.time}}天以内付款{{Math.ceil(form.balance2.percent)}}%</h6> -->
					<h6 class="basic-label">{{triggerEvent[form.balance2.event]}}后时长{{form.balance2.time}}天以内
						<span v-if="form.payPlanType != 'PHASETWO'">支付总额的{{Math.ceil(form.balance2.percent)}}%</span>
						<span v-else>支付剩余全部款项</span>
					</h6>
				</el-row>
			</el-col>
		</el-row>
		<el-row type="flex" align="middle" v-if="form.payPlanType=='MONTHLY_SETTLEMENT'">
			<el-col :span="6">
				<h6 class="payPlan-label">月结</h6>
			</el-col>
			<el-col :span="18">
				<el-row type="flex" align="middle" justify="start">
					<h6 class="basic-label">{{triggerEvent[form.monthBalance.event]}}后次月{{form.monthBalance.time}}号以内支付剩余全部款项</h6>
				</el-row>
			</el-col>
		</el-row>
	</div>
</template>

<script>
	export default {
		name: 'PayPlanInfo',
		components: {},
		props: {
			form: {
				type: Object,
				required: true
			}
		},
		methods: {
		},
		data () {
			return {
				payPlanType: {
          'PHASEONE': '一期尾款',
          'PHASETWO': '二期尾款',
          'MONTHLY_SETTLEMENT': '月结'
        },
        triggerEvent: {
          'ORDER_CONFIRMED': '确认订单',
          'CONTRACT_SIGNED': '签署合同',
          'DELIVERY_CONFIRMED': '确认收货',
          'RECONCILIATION_CONFIRMED': '确认对账',
          'INVOICE_RECEIVED': '收到发票'
				}
			}
		},
		created () {
		}
	}
</script>

<style scoped>
  .info-input-prepend2 {
    display: inline-block;
    margin: 0 25px;
    width: 50px;
    font-size: 10px;
    color: rgba(0, 0, 0, 0.45);
    line-height: 25px;
  }

	.payPlan-label {
		margin-bottom: 0px;
		line-height: 35px;
		color: #606266;
	}

	.basic-label {
		line-height: 35px;
    margin-bottom: 0px;
	}

</style>
