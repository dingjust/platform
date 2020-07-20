<template>
  <div class="animated fadeIn">
    <el-card :shadow="shadow">
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="title">
            <h6>发货任务单</h6>
          </div>
        </el-col>
        <el-col :span="4">
          <h6>状态：{{getEnum('ReceiveDispatchTaskState', formData.state)}}</h6>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <template v-if="showOrderInfo">
        <el-row type="flex" justify="start" class="basic-row">
          <el-col :span="3">
            <img width="100px" height="100px"
              :src="formData.product.thumbnail!=null&&formData.product.thumbnail.length!=0?formData.product.thumbnail.url:'static/img/nopicture.png'">
          </el-col>
          <el-col :span="21">
            <el-row type="flex" style="padding: 10px 0px">
              <el-col :span="8">
                <h6>产品名称：{{formData.product.name}}</h6>
              </el-col>
              <el-col :span="8">
                <h6>货号：{{formData.product.skuID}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <el-col :span="8">
                <h6>发货方：{{formData.shipParty!=null?formData.shipParty.name:''}}</h6>
              </el-col>
              <el-col :span="8">
                <h6>收货方：{{formData.receiveParty!=null?formData.receiveParty.name:''}}</h6>
              </el-col>
              <el-col :span="8">
                <h6>发货负责人：{{formData.merchandiser.name}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <el-col :span="12">
                <h6>收货地址：{{formData.deliveryAddress.details}}</h6>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
      </template>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="24">
          <shipping-tasks-quantity-table :formData="formData" />
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="24">
          <shipping-tasks-orders-list :formData="formData" :readOnly="!isShipParty" @onCreate="onCreate" />
        </el-col>
      </el-row>
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px"
        v-if="isShipParty&&formData.state=='IN_DELIVERY'">
        <el-button class="shipping-btn" :disabled="!finshiBtnEnable" @click="onFinish">发货完结</el-button>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import ShippingTasksQuantityTable from '../table/ShippingTasksQuantityTable'
  import ShippingTasksOrdersList from '../list/ShippingTasksOrdersList'
  export default {
    name: 'ShippingTasksDetail',
    props: {
      id: {

      },
      shadow: {
        type: String,
        default: 'always'
      },
      showOrderInfo: {
        type: Boolean,
        default: true
      }
    },
    components: {
      ShippingTasksQuantityTable,
      ShippingTasksOrdersList
    },
    computed: {
      //发货完结按钮显示状态
      finshiBtnEnable: function () {
        //TODO:生产单状态为待出库
        if (this.formData.productionTaskOrder != null && this.formData.productionTaskOrder.state ==
          'TO_BE_DELIVERED') {
          if (this.isShipParty) {
            if (this.formData.shippingSheets != null && this.formData.shippingSheets.length > 0) {
              let pass = true;
              this.formData.shippingSheets.forEach(sheet => {
                if (!(sheet.state == 'PENDING_RECONCILED' || sheet.state == 'COMPLETED'||sheet.state == 'IN_RECONCILED')) {
                  pass = false;
                  return false;
                }
              });
              return pass;
            }
          }
        }
        return false;
      },
      //是发货方
      isShipParty: function () {
        if (this.formData.shipParty != null && this.currentUser != null) {
          return this.currentUser.companyCode == this.formData.shipParty.uid;
        } else {
          return false;
        }
      },
      //是收货方
      isReceiveParty: function () {
        if (this.formData.receiveParty != null && this.currentUser != null) {
          return this.currentUser.companyCode == this.formData.receiveParty.uid;
        } else {
          return false;
        }
      },
      isFinish: function () {
        // TODO 判断是否所有发货单都已收货
        return false;
      },
    },
    methods: {
      async getDetail() {
        // TODO 获取发货任务详情
        const url = this.apis().shippingTaskDetail(this.id);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.formData = result.data;
      },
      onCreate() {
        // TODO 整理需要传递的数据
        let taskData = this.formData;
        this.$router.push({
          name: '创建发货单',
          params: {
            taskData: taskData
          }
        });
      },
      onFinish() {
        this.$confirm('确认发货完结后，不能再创建发货单了，表示该发货任务完结，是否确认该操作。', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onFinish();
        });
      },
      async _onFinish() {
        // 发货完结        
        const url = this.apis().shippingFinish(this.id);
        const result = await this.$http.put(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.getDetail();
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        formData: {
          product: {
            name: '',
            skuID: '',
          },
          shipParty: {
            name: '',
          },
          receiveParty: {
            name: ''
          },
          merchandiser: {
            name: ''
          },
          deliveryAddress: {
            details: ''
          },
          orders: []
        }
      }
    },
    created() {
      this.getDetail();
    },
    destroyed() {

    }
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .basic-row {
    padding-left: 10px;
    margin-top: 20px;
  }

  .shipping-btn {
    width: 120px;
    height: 40px;
  }

</style>
