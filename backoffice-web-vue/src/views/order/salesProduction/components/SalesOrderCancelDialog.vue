<!-- 
 * @description: 销售订单取消申请弹窗
 * @fileName: SalesOrderCanceDialog.vue 
 * @author: yj 
 * @date: 2020-08-25 15:06:26
 * @version: V1.0.0 
!-->
<template>
  <div class="form-body">
    <el-row type="flex" justify="center">
      <h6>合作商申请取消订单</h6>
    </el-row>
    <el-table ref="multipleTable" :data="canbeCancelOrders" tooltip-effect="dark" style="width: 100%">
      <el-table-column label="订单号" prop="code" />
      <el-table-column prop="product.name" label="产品" />
      <el-table-column prop="product.skuID" label="货号" />
      <el-table-column prop="quantity" label="数量" />
    </el-table>
    <div class="form-box">
      <el-form label-position="top">
        <el-form-item label="取消的原因">
          <el-input type="textarea" readonly v-model="order.currentCancelApply.reason"></el-input>
        </el-form-item>
        <el-row type="flex" justify="space-around">
          <el-button @click="onSubmit(true)" class="material-btn">同意</el-button>
          <el-button @click="onSubmit(false)" class="material-btn">拒绝</el-button>
        </el-row>
      </el-form>
    </div>
  </div>
</template>

<script>
  export default {
    name: "SalesOrderCancelDialog",
    props: {
      order: {
        type: Object
      }
    },
    computed: {
      //可以取消的订单(待生产订单)
      canbeCancelOrders: function () {
        return this.order.taskOrderEntries.filter(entry => entry.canceling);
      }
    },
    methods: {
      onSubmit(val) {
        this.$confirm('是否确认' + (val ? '同意' : '拒绝') + '申请?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onSubmit(val);
        })
      },
      async _onSubmit(val) {
        const url = this.apis().outboundOrderCancelHandle();
        let submitForm = {
          'id': this.order.id,
          'agree': val,
        };
        const result = await this.$http.post(url, submitForm);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        if (result["code"] == 0) {
          this.$message.error(result["msg"]);
          return;
        }
        this.$message.success("操作成功");
        this.$emit('callback');
      },
    },
    data() {
      return {};
    },
  };

</script>
<style scoped>
  .form-box {
    padding: 20px 20px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 120px;
    height: 40px;
  }

</style>
