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
          <el-col :span="5">
            <h6>工单负责人：{{slotData.charge}}</h6>
          </el-col>
          <el-col :span="5">
            <h6>优先级：{{slotData.priority}}</h6>
          </el-col>
          <el-col :span="5">
            <h6>工单生成时间：{{slotData.creationTime | timestampToTime}}</h6>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="2">
        <h6 style="color: #F56C6C">延期10天</h6>
      </el-col>
    </el-row>
    <el-row type="flex" justify="space-between" style="margin-top: 10px" align="bottom">
      <el-col :span="20">
        <el-row type="flex" align="bottom">
          <el-col :span="2" :offset="1">
            <img width="60px" height="60px"
                 :src="slotData.product.thumbnail!=null&&slotData.product.thumbnail.length!=0?slotData.product.thumbnail.url:'static/img/nopicture.png'"/>
          </el-col>
          <el-col :span="5">
            <h6 style="margin-bottom: 13px;">产品名：{{slotData.product.name}}</h6>
            <h6>货号：{{slotData.product.shuID}}</h6>
          </el-col>
          <el-col :span="5">
            <h6>生成数量：{{slotData.product.quantity}}</h6>
          </el-col>
          <el-col :span="5">
            <h6 style="margin-bottom: 13px;">关联订单：{{slotData.product.relationOrder}}</h6>
            <h6>交货日期：{{slotData.product.deliveryDate | timestampToTime}}</h6>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="2">
        <el-button class="list-btn">查看详情</el-button>
      </el-col>
    </el-row>
    <el-divider/>
    <el-row type="flex" justify="space-between" align="middle">
      <el-col :span="19" :offset="1">
        <progress-order-steps :slotData="slotData.progressPlan"/>
      </el-col>
      <el-col :span="4">
        <el-row>
          <el-button class="list-btn">发货</el-button>
          <el-button class="list-btn">入库</el-button>
        </el-row>
      </el-col>
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

    },
    methods: {
      onDetail (row) {
        this.$router.push('/sales/outboundOrder/' + row.code);
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
