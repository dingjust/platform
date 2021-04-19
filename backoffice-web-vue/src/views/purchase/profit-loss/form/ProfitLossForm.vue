<!--
* @Description: 盈亏分析表
* @Date 2021/03/18 16:57
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="cost-order-title">
          <h6>{{ this.id ? '编辑' : '创建'}}盈亏分析</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <el-form ref="form" :model="formData" :inline="true" style="margin-left: 20px" @submit.native.prevent
               :hide-required-asterisk="true" label-width="100px" label-position="left">
        <profit-loss-form-top :formData="formData"/>
        <h6 v-if="this.id" style="color: #F56C6C">* {{tips}}</h6>
        <template v-for="item in formData.tasks">
          <profit-loss-task-table ref="taskTable" :task="item" :key="item.id" :taskRows="taskRows" :tips="tips"/>
        </template>
        <profit-loss-remarks :formData="formData"/>
      </el-form>
      <el-row type="flex" justify="center" style="margin-top: 20px">
        <el-button v-if="this.id" class="create-btn" @click="onCreate">编辑</el-button>
        <el-button v-else class="create-btn" @click="onCreate">创建</el-button>
      </el-row>
    </el-card>
  </div>
</template>

<script>
import ProfitLossFormTop from './ProfitLossFormTop'
import ProfitLossTaskTable from './ProfitLossTaskTable'
import ProfitLossRemarks from './ProfitLossRemarks'

export default {
  name: 'ProfitLossForm',
  props: ['id'],
  components: {
    ProfitLossFormTop,
    ProfitLossTaskTable,
    ProfitLossRemarks
  },
  data () {
    return {
      formData: {
        code: '',
        salesProductionOrder: {
          id: null,
          code: '',
        },
        tasks: [],
        entries: [],
        explain: '',
        remarks: ''
      },
      taskRows: [],
      tips: '已进行采购的信息无法修改'
    }
  },
  methods: {
    async getDetail () {
      const id = this.id;

      const url = this.apis().getProfitLoss(id);
      const result = await this.$http.get(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.initData(result.data);

      this.getSalesProductionOrderDetails(result.data.salesProductionOrder.id);
    },
    async getSalesProductionOrderDetails (id) {
      const url = this.apis().getSalesProductionOrderDetails(id);
      const result = await this.$http.get(url);

      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }

      if (result.code === 1) {
        this.formData.salesProductionOrder = {
          id: result.data.id,
          code: result.data.code,
        }

        this.formData.tasks = result.data.taskOrderEntries;
      }
    },
    initData (data) {
      this.formData.id = data.id;
      this.formData.code = data.code;
      this.formData.explain = data.explain;
      this.formData.remarks = data.remarks;

      const ids = new Set(data.entries.map(item => item.productionTaskOrderId));

      ids.forEach(item => {
        this.taskRows.push(data.entries.filter(val => val.productionTaskOrderId === item)); 
      })
    },
    onCreate () {
      this.$refs.form.validate((valid) => {
        if (valid) {
          const taskTable = this.$refs.taskTable;
          let flag = taskTable.some(item => item.todoColor !== '');

          if (flag) {
            this.$message.warning('存在工单产品未进行盈亏分析，请先进行盈亏分析！');
            return;
          }

          if (taskTable.some(item => item.plRows.some(val => !val.costOrder.product))) {
            this.$message.warning('存在数据行未选择成本单，请先进行处理！');
            return;
          }

          // 数据处理
          let entries = [];
          taskTable.forEach(item => {
            entries = entries.concat(item.plRows.filter(v => v.colors.length > 0).map(val => {
              // 所有成本单类型都为 PRODUCT,不然会报 未知类型
              val.costOrder.type = 'PRODUCT';

              return {
                id: val.id ? val.id : null,
                productionTaskOrderId: val.productionTaskOrderId,
                colors: val.colors,
                costOrder: val.costOrder,
                additionalCharges: val.additionalCharges,
                purchaseTaskId: val.purchaseTaskId ? val.purchaseTaskId : null
              }
            }))
          })

          const data = {
            id: this.formData.id ? this.formData.id : null,
            salesProductionOrder: this.formData.salesProductionOrder,
            entries: entries,
            remarks: this.formData.remarks,
            explain: this.formData.explain
          }
          
          if (this.id) {
            this._onEdit(data);
          } else {
            this._onCreate(data);
          }
        } else {
          this.$message.error('请先完善表单信息！');
        }
      })
    },
    async _onCreate (data) {
      const url = this.apis().createProfitLoss();
      const result = await this.$http.post(url, data);

      if (result.code === 1) {
        this.$message.success('创建盈亏分析表成功！');
        this.$router.push('/purchase/profitloss/' + result.msg);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('创建盈亏分析表失败！');
      }
    },
    async _onEdit (data) {
      const url = this.apis().updateProfitLoss();
      const result = await this.$http.put(url, data);

      if (result.code === 1) {
        this.$message.success('编辑盈亏分析表成功！');
        this.$router.push('/purchase/profitloss/' + this.id);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('编辑盈亏分析表失败！');
      }
    }
  },
  created () {
    if (this.id) {
      this.getDetail();
    }
    if (this.$route.params.formData) {
      this.formData.salesProductionOrder.id = this.$route.params.formData.id;
      this.formData.salesProductionOrder.code = this.$route.params.formData.code;

      this.formData.tasks = this.$route.params.formData.taskOrderEntries;
    }
  }
}
</script>

<style scoped>
  .cost-order-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }
</style>