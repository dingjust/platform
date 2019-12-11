<template>
  <div class="animated fadeIn">
    <el-row class="cancel-info-title-row">
      <div class="cancel-info-title">
        <h6 class="cancel-info-title_text">取消订单</h6>
      </div>
    </el-row>
    <el-row type="flex" justify="center" class="cancel-info-title-row">
      <el-col :span="20">
        <h6 class="cancel-info-title_text">{{slotData.creator.name}} 申请取消订单，是否同意取消订单</h6>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center">
      <el-col :span="20">
        <h6>取消原因：</h6>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center">
      <el-col :span="20">
        <span>{{slotData.cannelMsg}}</span>
      </el-col>
    </el-row>
    <el-row class="cancel-button" type="flex" justify="center" align="middle" :gutter="100">
      <el-col :span="6">
        <el-button class="btn-block" size="mini" @click="onCancel">
          拒绝
        </el-button>
      </el-col>
      <el-col :span="6">
        <el-button class="btn-block" size="mini" type="primary" @click="onSubmit">
          同意
        </el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
    export default {
      name: 'PurchaseOrderCannelMsgDialog',
      props: ['slotData'],
      methods: {
        onCancel () {
          this.$confirm('是否拒绝订单的取消申请?', '取消订单', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            this.changeCannelStatus();
          });
        },
        async changeCannelStatus () {
          let formData = {
            'cannelStatus': 'NOT_CANNEL'
          };
          const url = this.apis().changeCannelStatus(this.slotData.code);
          const result = await this.$http.put(url, formData);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.$message.success('已拒绝取消申请');
          this.$emit('closeCannelMsgVisible');
          this.$emit('onSearch');
        },
        onSubmit () {
          this.$confirm('是否确认取消订单?', '取消订单', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            this.cancel();
          });
        },
        async cancel () {
          const url = this.apis().cancellingOfPurchaseOrder(this.slotData.code);
          const result = await this.$http.put(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.$message.success('取消成功');
          // this.$router.push('/order/purchase');
          this.$emit('closeCannelMsgVisible');
          this.$emit('onSearch');
        }
      }
    }
</script>

<style scoped>
  .cancel-info-title-row {
    margin-bottom: 20px;
  }
  .cancel-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 20px;
  }
  .cancel-info-title_text {
    font-size: 16px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }
  .cancel-button {
    margin-left: 20px;
    margin-top: 20px;
  }
</style>
