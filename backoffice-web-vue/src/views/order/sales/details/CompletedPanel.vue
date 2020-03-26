<template>
  <div class="sale-details-b1_body">
    <el-row type="flex" align="top">
      <h6>
        订单当前状态：
        <span style="color:red;font-weight: bold;">交易完成</span>
      </h6>
    </el-row>
    <div v-if="false">
      <el-row type="flex" class="sales-detail-row">
        <el-col :span="20" :offset="3">
          <h6>退货方式：退款退货</h6>
        </el-col>
      </el-row>
      <el-row type="flex" class="sales-detail-row">
        <el-col :span="20" :offset="3">
          <h6>退货原因：请问囧饿哦情节哦就请问额</h6>
        </el-col>
      </el-row>
      <el-row type="flex" class="sales-detail-row">
        <el-col :span="2" :offset="3">
          <h6>上传凭证：</h6>
        </el-col>
        <el-col :span="18">
          <template v-for="(item,index) in images">
            <img width="80px" height="80px" style="margin-right:10px" :key="index"
                 :src="item.url!=null?item.url:'static/img/nopicture.png'" />
          </template>
        </el-col>
      </el-row>
    </div>
    <!-- 品牌 -->
    <!-- <el-row type="flex" justify="end">
      <el-col :span="3">
        <el-button class="sales-order-btn" style="background:white">平台介入</el-button>
      </el-col>
      <el-col :span="3">
        <el-button class="sales-order-btn" style="background:white">同意退货</el-button>
      </el-col>
    </el-row> -->
    <!-- 工厂 -->
<!--    <el-row type="flex" justify="end">-->
<!--      <el-col :span="3">-->
<!--        <el-button class="sales-order-btn" style="background:white">拒绝退货</el-button>-->
<!--      </el-col>-->
<!--      <el-col :span="3">-->
<!--        <el-button class="sales-order-btn" style="background:white" @click="onSure">同意退货</el-button>-->
<!--      </el-col>-->
<!--    </el-row>-->
<!--    <el-row type="flex" justify="end">-->
<!--      <el-col :span="3">-->
<!--        <el-button class="sales-order-btn" style="background:white">平台介入</el-button>-->
<!--      </el-col>-->
<!--      <el-col :span="3">-->
<!--        <el-button class="sales-order-btn" style="background:white" @click="onSure">撤销申请</el-button>-->
<!--      </el-col>-->
<!--    </el-row>-->
  </div>
</template>

<script>
  export default {
    name: 'CompletedPanel',
    props: [],
    components: {},
    computed: {},
    methods: {
    },
    data () {
      return {
      }
    },
    created () {

    },
    mounted () {}
  };
</script>
<style>

</style>
