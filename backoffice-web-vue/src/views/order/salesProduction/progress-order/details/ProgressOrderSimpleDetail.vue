<template>
  <div class="border-container">
    <el-row type="flex" justify="space-between">
      <el-col :span="20">
        <el-row type="flex" justify="start">
          <el-col :span="1">
            <el-checkbox v-model="checked"></el-checkbox>
          </el-col>
          <el-col :span="5">
            <h6>工单号：{{slotData.code}}</h6>
          </el-col>
          <el-col :span="6">
            <h6>工单负责人：{{slotData.personInCharge ? slotData.personInCharge.name : ''}}</h6>
          </el-col>
          <el-col :span="6">
            <h6>优先级：{{slotData.priorityLevel ? getEnum('priorities', slotData.priorityLevel) : ''}}</h6>
          </el-col>
          <el-col :span="6">
            <h6>工单生成时间：{{slotData.creationtime | timestampToTime}}</h6>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="2">
<!--        <h6 style="color: #F56C6C">延期??天</h6>-->
      </el-col>
    </el-row>
    <el-row type="flex" justify="space-between" style="margin-top: 10px" align="bottom">
      <el-col :span="20">
        <el-row type="flex" align="bottom">
          <el-col :span="2" :offset="1">
            <img width="60px" height="60px"
                 :src="slotData.product && slotData.product.thumbnail!=null&&slotData.product.thumbnail.length!=0
                 ? slotData.product.thumbnail.url : 'static/img/nopicture.png'"/>
          </el-col>
          <el-col :span="5">
            <h6 style="margin-bottom: 13px;">产品名：{{slotData.product ? slotData.product.name : ''}}</h6>
            <h6>货号：{{slotData.product ? slotData.product.skuID : ''}}</h6>
          </el-col>
          <el-col :span="5">
            <h6>生成数量：{{getTotalQuantity}}</h6>
          </el-col>
          <el-col :span="5">
            <h6 style="margin-bottom: 13px;">关联订单：{{slotData.orderCode}}</h6>
            <h6>交货日期：{{slotData.expectedDeliveryDate | timestampToTime}}</h6>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="2">
        <el-button class="list-btn" @click="onDetail">查看详情</el-button>
      </el-col>
    </el-row>
    <el-divider/>
    <el-row type="flex" justify="space-between" align="middle">
      <el-col :span="24">
<!--        <progress-order-steps :phaseSqeuence="slotData.progressPlan.phaseSqeuence"-->
<!--                              :progresses="slotData.progressPlan.progress"/>-->
        <el-row type="flex" justify="space-between">
          <template v-for="(item, index) in slotData.progresses">
            <el-col :span="getSpan">
              <el-row type="flex" justify="center" align="middle">
<!--                <h6 v-if="item.delatedDays" style="color: #F56C6C">延误{{item.delatedDays}}天</h6>-->
                <h6 v-if="item.finishDate">完成时间：{{item.finishDate | timestampToTime}}</h6>
                <h6 v-if="item.estimatedDate && !item.finishDate">预计完成：{{item.estimatedDate | timestampToTime}}</h6>
              </el-row>
            </el-col>
          </template>
        </el-row>
        <el-steps :active="getActive" align-center finish-status="success">
          <template v-for="(item, index) in slotData.progresses">
            <el-step :title="item.progressPhase.name"/>
          </template>
        </el-steps>
      </el-col>
<!--      <el-col :span="4">-->
<!--        <el-row>-->
<!--          <el-button class="list-btn">发货</el-button>-->
<!--          <el-button class="list-btn">入库</el-button>-->
<!--        </el-row>-->
<!--      </el-col>-->
    </el-row>
  </div>
</template>

<script>
  import ProgressOrderSteps from '../components/ProgressOrderSteps';
  export default {
    name: 'ProgressOrderSimpleDetail',
    components: {ProgressOrderSteps},
    props: ['slotData'],
    computed: {
      getActive: function () {
        if (this.slotData.status == 'COMPLETED') {
          return this.slotData.progresses.length;
        }
        if (this.slotData.currentPhase) {
          return this.slotData.progresses.findIndex(val => val.progressPhase == this.slotData.currentPhase.id);
        }
        return 0;
      },
      getSpan: function () {
        return Math.ceil(24 / this.slotData.progresses.length);
      },
      getTotalQuantity: function () {
        let count = 0;
        this.slotData.colorSizeEntries.forEach(val => {
          count += val.quantity;
        })
        return count;
      }
    },
    methods: {
      onDetail (row) {
        this.$router.push('/sales/progressOrder/' + this.slotData.code);
      }
    },
    data () {
      return {
        checked: true
      }
    }
  }
</script>

<style scoped>
  .border-container {
    border: 1px solid #DCDFE6;
    padding: 10px;
    border-radius: 5px;
    /*background-color: #F5F5F5;*/
  }

  .list-btn {
    width: 80px;
  }
</style>
