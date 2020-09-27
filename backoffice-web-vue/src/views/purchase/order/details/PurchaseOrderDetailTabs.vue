<template>
  <div>
    <div class="over-tabs">
      <el-row type="flex">
        <template v-if="activeName === 'ACCEPTANCE'">
          <template v-if="isOnEdit">
            <el-button class="material-btn" @click="onEditSave">保存</el-button>
          </template>
          <template v-if="!isOnEdit && order.state === 'WAIT_TO_REV_MATERIALS'">
            <el-button class="material-btn" @click="onEdit">编辑</el-button>
            <el-button class="material-btn" @click="receiveComplete">收料完成</el-button>
          </template>
        </template>
        <template v-if="activeName === 'FINANCE'">
          <el-button class="material-btn" style="width: 120px" @click="createPaymentOrder">创建付款申请单</el-button>
        </template>
      </el-row>
    </div>
    <el-tabs type="border-card" v-model="activeName" @tab-click="handleClick">
      <el-tab-pane label="物料验收" name="ACCEPTANCE">
        <purchase-material-acceptance :order="order" :isOnEdit="isOnEdit" />
        <el-row type="flex" justify="end">
          <h6>变更时间：{{modifiedtime | formatDate}}</h6>
        </el-row>
      </el-tab-pane>
      <el-tab-pane label="财务信息" name="FINANCE">
        <el-table>
          <el-table-column label="付款次数"></el-table-column>
          <el-table-column label="付款方式"></el-table-column>
          <el-table-column label="付款金额"></el-table-column>
          <el-table-column label="付款内容"></el-table-column>
          <el-table-column label="付款时间"></el-table-column>
          <el-table-column label="付款凭证"></el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import PurchaseMaterialAcceptance from '../components/PurchaseMaterialAcceptance'

export default {
  name: 'PurchaseOrderDetailTabs',
  props: ['order'],
  components: {
    PurchaseMaterialAcceptance
  },
  computed: {
    modifiedtime: function () {
      return this.order.entries.map(item => item.modifiedtime).sort((o1, o2) => o2 - o1)[0];
    }
  },
  methods: {
    handleClick (tab, event) {
      this.activeName = tab.name;
    },
    onEdit () {
      this.editVisible = true;
      this.isOnEdit = true;
    },
    async onEditSave () {
      let form = {
        id: this.order.id,
        entries: this.order.entries.map(item => {
          return {
            id: item.id,
            receiveQuantity: item.receiveQuantity,
            remark: item.remark
          }
        })
      }

      const url = this.apis().updatePurchaseOrder();
      const result = await this.$http.post(url, form);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.$message.success('编辑物料验收信息成功！');
        this.$emit('getDetail');
        this.isOnEdit = false;
      } else if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }
    },
    async receiveComplete () {
      const url = this.apis().purchaseOrderComplete(this.order.id);
      const result = await this.$http.post(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.$message.success('收料完成！');
        this.$emit('getDetail');
        this.$emit('callback');
        return;
      } else if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }
    },
    createPaymentOrder () {
      this.$router.push({
        name: '创建付款申请单',
        params: {
          orderData: this.order,
          type: 'MATERIALS_COST'
        }
      });
    }
  },
  data () {
    return {
      activeName: 'ACCEPTANCE',
      isOnEdit: false
    }
  }
}
</script>

<style scoped>
  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 50px;
    margin-top: 2px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }
</style>