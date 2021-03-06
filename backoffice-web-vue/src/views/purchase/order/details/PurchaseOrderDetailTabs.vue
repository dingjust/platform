<template>
  <div>
    <div class="over-tabs">
      <el-row type="flex">
        <template v-if="activeName === 'ACCEPTANCE'">
          <template v-if="isOnEdit">
            <el-button class="material-btn" @click="onEditSave">保存</el-button>
          </template>
          <template v-if="!isOnEdit && order.state === 'WAIT_TO_REV_MATERIALS' && isMerchandiser">
            <authorized :permission="['PURCHASE_ORDER_MODIFY']">
              <el-button class="material-btn" @click="onEdit">编辑</el-button>
            </authorized>
            <authorized :permission="['PURCHASE_ORDER_MODIFY']">
              <el-button class="material-btn" @click="receiveComplete">收料完成</el-button>
            </authorized>
          </template>
        </template>
        <template v-if="canCreatePayment">
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
        <el-table :data="paymentList">
          <el-table-column label="付款次数">
            <template slot-scope="scope">
              <span>{{scope.$index + 1}}</span>
            </template>
          </el-table-column>
          <el-table-column label="付款方式">
            <template slot-scope="scope">
              <span>{{getEnum('PaymentMethod', scope.row.paymentRecords.paymentMethod)}}</span>
            </template>
          </el-table-column>
          <el-table-column label="付款金额" prop="requestAmount"></el-table-column>
          <el-table-column label="付款内容" prop="paymentFor"></el-table-column>
          <el-table-column label="付款时间">
            <template slot-scope="scope">
              <span>{{scope.row.paymentRecords.payTime | timestampToTime}}</span>
            </template>
          </el-table-column>
          <el-table-column label="付款凭证">
            <template slot-scope="scope">
              <el-button type="text" @click="onVouchers(scope.row)">查看凭证</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>
    <el-dialog :visible.sync="dialogVisible" width="30%" append-to-body>
      <img width="100%" :src="dialogImageUrl" alt="">
    </el-dialog>
  </div>
</template>

<script>
import PurchaseMaterialAcceptance from '../components/PurchaseMaterialAcceptance'

export default {
  name: 'PurchaseOrderDetailTabs',
  props: ['order', 'paymentList'],
  components: {
    PurchaseMaterialAcceptance
  },
  computed: {
    canCreatePayment: function () {
      return this.activeName === 'FINANCE' && 
              this.order.state !== 'NOT_COMMITED' && 
              this.order.state !== 'AUDITING' && 
              this.order.state !== 'AUDIT_FAILED' &&
              this.isMerchandiser;
    },
    isMerchandiser: function () {
      return this.order.workOrder.task.merchandiser.uid === this.$store.getters.currentUser.uid;
    },
    modifiedtime: function () {
      return this.order.entries.map(item => item.modifiedtime).sort((o1, o2) => o2 - o1)[0];
    }
  },
  methods: {
    onVouchers(row) {
      this.dialogImageUrl = row.paymentRecords.paymentVouchers[0].url;
      this.dialogVisible = true;
    },
    handleClick (tab, event) {
      this.activeName = tab.name;
    },
    onEdit () {
      this.editVisible = true;
      this.isOnEdit = true;
    },
    onEditSave () {
      this.$confirm('是否进行保存操作?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onEditSave()
      });
    },
    async _onEditSave () {
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
        this.$emit('callback');
        this.isOnEdit = false;
      } else if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }
    },
    receiveComplete () {
      this.$confirm('是否进行收料完成操作?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._receiveComplete()
      });
    },
    async _receiveComplete () {
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
      dialogImageUrl: '',
      dialogVisible: false,
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