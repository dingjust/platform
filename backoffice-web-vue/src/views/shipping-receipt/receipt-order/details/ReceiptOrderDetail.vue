<!-- 
 * @description: 收货单详情
 * @fileName: ReceiptOrderDetail.vue 
 * @author: yj 
 * @date: 2020-06-22 13:58:22
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn receipt-order-container">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="4">
          <div class="title">
            <h6>收货单详情</h6>
          </div>
        </el-col>
        <el-col :span="4">
          <div>
            <h6>状态：待核验</h6>
          </div>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="3">
          <!-- <img width="54px" height="54px"
              :src="scope.row.thumbnail!=null&&scope.row.thumbnail.length!=0?scope.row.thumbnail.url:'static/img/nopicture.png'"> -->
          <img width="100px" height="100px" :src="'static/img/nopicture.png'">
        </el-col>
        <el-col :span="21">
          <el-row type="flex" style="padding: 10px 0px">
            <el-col :span="8">
              <h6>产品名称：红烧猪蹄</h6>
            </el-col>
            <el-col :span="8">
              <h6>发货方：红烧猪蹄</h6>
            </el-col>
            <el-col :span="8">
              <h6>收货方：梅菜扣肉</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="8">
              <h6>货号：梅菜扣肉</h6>
            </el-col>
            <el-col :span="8">
              <h6>发货负责人：烧鸡翅</h6>
            </el-col>
            <el-col :span="8">
              <h6>联系方式：123456789</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="24">
              <h6>收货地址：广州市海珠区云顶同创汇二期</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="8">
              <h6>物流方式：货拉拉</h6>
            </el-col>
            <el-col :span="8">
              <h6>发货单号：SF017532492929</h6>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex" style="margin-top:20px">
        <el-col :span="4" :offset="4">
          <el-radio v-model="showOnBox" :disabled="true" :label="true">按箱号</el-radio>
          <el-radio v-model="showOnBox" :disabled="true" :label="false">按总列表</el-radio>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row" v-if="showOnBox">
        <el-col :span="24">
          <color-size-box-table :vdata="data.entries!=null?[data.entries[0].colorSizeEntries]:[]"
            :colorSizeEntries="data.entries!=null?data.entries[0].colorSizeEntries:[]" :readOnly="true" />
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row" v-if="!showOnBox">
        <el-col :span="24">
          <color-size-table :data="data.entries!=null?data.entries[0].colorSizeEntries:[]" :readOnly="true" />
        </el-col>
      </el-row>
      <el-row type="flex" style="margin-top:20px">
        <el-col :span="4" :offset="4">
          <h6>有无退货：{{returned?'有':'无'}}退货</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="8" :offset="2">
          <h6>发货单：KY1000000001</h6>
        </el-col>
      </el-row>
      <receipt-order-detail-btn-group />
    </el-card>
  </div>
</template>

<script>
  import {
    ColorSizeBoxTable,
    ColorSizeTable
  } from '@/components/'

  import ReceiptOrderDetailBtnGroup from './ReceiptOrderDetailBtnGroup';

  export default {
    name: 'ReceiptOrderDetail',
    props: {
      //收货单id
      id: {
        require: true
      }
    },
    components: {
      ColorSizeBoxTable,
      ColorSizeTable,
      ReceiptOrderDetailBtnGroup
    },
    computed: {},
    methods: {
      async getDetail() {
        const url = this.apis().getProductionTaskDetails(this.id);
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        // this.data = Object.assign({}, result.data);
        this.$set(this, 'data', Object.assign({}, result.data));
      },
    },
    data() {
      return {
        data: '',
        showOnBox: false,
        returned: false
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

  .sumbit-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 125px;
    height: 32px;
  }

  .receipt-order-container h6 {
    font-size: 14px;
    color: #606266;
  }

  .receipt-order-container {
    padding-bottom: 10px;
  }

</style>
