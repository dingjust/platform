<template>
  <div class="sale-details-b1_body">
    <el-row type="flex" align="top">
      <h6>
        订单当前状态：
        <span style="color:red;font-weight: bold;">{{formData.status == 'IN_REFUND' ? '卖家已同意退款，等待退款完成' : '用户申请退款'}}</span>
      </h6>
    </el-row>
    <el-row type="flex" class="sales-detail-row">
      <el-col :span="20" :offset="3">
        <h6>退货方式：{{getEnum('refundType', formData.refundType)}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="sales-detail-row">
      <el-col :span="20" :offset="3">
        <h6>退货原因：{{formData.applyReason}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="sales-detail-row" v-if="formData.applyImages">
      <el-col :span="2" :offset="3">
        <h6>退款凭证</h6>
      </el-col>
      <el-col :span="18">
        <template v-for="(item,index) in formData.applyImages">
          <img width="80px" height="80px" style="margin-right:10px" :key="index"
            :src="item.url!=null?item.url:'static/img/nopicture.png'" />
        </template>
      </el-col>
    </el-row>
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
    <el-row type="flex" justify="end" v-if="isFactory() && formData.status === 'PENDING_CONFIRM'">
      <el-col :span="3">
        <el-button class="sales-order-btn" style="background:white" @click="refuseReturn">拒绝退货</el-button>
      </el-col>
      <el-col :span="3">
        <el-button class="sales-order-btn" style="background:white" @click="onSure">同意退货</el-button>
      </el-col>
    </el-row>
    <el-row type="flex" justify="end" v-if="isBrand() && formData.status === 'PENDING_CONFIRM'">
<!--      <el-col :span="3">-->
<!--        <el-button class="sales-order-btn" style="background:white" @click="platformIntervene">平台介入</el-button>-->
<!--      </el-col>-->
      <el-col :span="3">
        <el-button class="sales-order-btn" @click="cannelApply">撤销申请</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ReturnPanel',
    props: ['formData'],
    components: {},
    computed: {},
    methods: {
      // async getRefundDetail () {
      //   const url = this.apis().getRefundDetail(this.slotData.code);
      //   const result = await this.$http.post(url);
      //   if (result.code === 0) {
      //     this.$message.error(result.msg);
      //     return;
      //   }
      //   this.formData = Object.assign({}, result.data);
      //   console.log(this.formData);
      // },
      onSure () {
        const flag = true;
        this.$confirm('确认后将同意买家退货，请问是否继续？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$emit('returnAudit', flag);
        });
      },
      refuseReturn () {
        this.$emit('onRefuseReturnForm');
      },
      platformIntervene () {
        this.$confirm('确认后将请求平台介入，请问是否继续', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$emit('platformIntervene');
        });
      },
      cannelApply () {
        this.$confirm('确认后将撤销退货申请，请问是否继续', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$emit('cannelApply');
        });
      }
    },
    data () {
      return {
        images: [{
          url: '/resource/hf5/h95/8821490221086.jpg'
        },
        {
          url: '/resource/hf5/h95/8821490221086.jpg'
        },
        {
          url: '/resource/hf5/h95/8821490221086.jpg'
        },
        {
          url: '/resource/hf5/h95/8821490221086.jpg'
        },
        {
          url: '/resource/hf5/h95/8821490221086.jpg'
        }
        ]
      }
    },
    created () {
      console.log(this.formData);
    },
    mounted () {}
  };
</script>
<style>

</style>
