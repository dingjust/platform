<!-- 
 * @description: 复议单表单
 * @fileName: ReconsiderOrderForm.vue 
 * @author: yj 
 * @date: 2020-06-23 14:47:26
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn receipt-order-container">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="4">
          <div class="title">
            <h6>申请复议</h6>
          </div>
        </el-col>
        <el-col :span="4">
          <div>
            <h6>时间：{{Date.now()|timestampToTime}}</h6>
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
      <el-table :data="data" stripe style="width: 100%">
        <el-table-column prop="" label="发货单">
        </el-table-column>
        <el-table-column prop="name" label="发货数量">
        </el-table-column>
        <el-table-column prop="" label="收货单">
        </el-table-column>
        <el-table-column prop="" label="收货数量">
        </el-table-column>
        <el-table-column prop="" label="退货单">
        </el-table-column>
        <el-table-column prop="" label="退货数/收退数">
        </el-table-column>
        <el-table-column prop="" label="差异数">
        </el-table-column>
      </el-table>
      <el-form :model="form" :inline="true">
        <el-row type="flex" justify="space-between" style="margin-top:20px">
          <el-col :span="6" :offset="2">
            <el-row type="flex">
              <h6 style="margin-right:20px">上传凭证</h6>
              <images-upload class="form-upload" :slot-data="attachments" />
            </el-row>
          </el-col>
          <el-col :span="6">
            <!-- <h6>申请复议数量：1</h6> -->
            <el-form-item label="申请复议数量">
              <el-input v-model="form.num" placeholder="0"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <el-row type="flex" justify="center" style="margin-top: 20px" :gutter="50">
        <template>
          <el-col :span="4">
            <el-button class="material-btn" @click="onSubmit">提交复议</el-button>
          </el-col>
        </template>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import {
    ColorSizeBoxTable,
    ColorSizeTable
  } from '@/components/'

  import ImagesUpload from '@/components/custom/ImagesUpload';

  export default {
    name: 'ReconsiderOrderForm',
    props: {

    },
    components: {
      ImagesUpload,
    },
    computed: {

    },
    methods: {
      onSubmit() {
        //校验数量与订单差异

      },
      async _onSubmit() {
        // this.onReturnedMessage();
      },
    },
    data() {
      return {
        data: [],
        form: {
          num: ''
        },
        attachments: []
      }
    },
    created() {

    },
    destroyed() {

    }
  }

</script>

<style scoped src="../../css/reconsider-order.css"></style>
