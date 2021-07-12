<!--
* @Description: 需求审阅列表查看的 需求详情
* @Date 2021/07/01 16:04
* @Author L.G.Y
-->
<template>
  <div v-if="slotData">
    <el-row class="info-title-row" type="flex" justify="space-between">
      <div class="info-title">
        <h6 class="info-title_text">需求订单详情</h6>
      </div>
    </el-row>
    <el-row type="flex" align="middle" style="margin-bottom: 20px">
      <el-col :span="6">
        <span>需求编号：{{slotData.code}}</span>
      </el-col>
      <el-col :span="6">
        <span>当前状态：<span :style="{color: statusColor}">{{getEnum('requirementOrderStatuses',slotData.status)}}</span></span>
      </el-col>
      <el-col :span="6">
        <el-row type="flex" justify="end">
          <span>发布日期：{{slotData.creationtime | formatDate}}</span>
        </el-row>
      </el-col>
      <el-col :span="6">
        <el-row type="flex" justify="end">
          <span>有效期限：{{getEnum('EffectiveDays',slotData.details.effectiveDays == null ? 'null': slotData.details.effectiveDays.toString())}}</span>
        </el-row>
      </el-col>
    </el-row>
    <div class="titleCardClass">
      <el-row type="flex">
        <el-col :span="18">
          <el-row>
            <div class="titleClass">
              <h6>需求信息</h6>
            </div>
          </el-row>
          <requirement-order-basic-info-page :slotData="slotData" style="padding:10px"/>
        </el-col>
        <el-divider direction="vertical"></el-divider>
        <el-col :span="6">
          <el-row>
            <div class="titleClass">
              <h6>发布需求者</h6>
            </div>
          </el-row>
          <requirement-order-belong-to-info-page :slotData="slotData" style="margin: 20px 0px 10px 10px;"/>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
import RequirementOrderBasicInfoPage from '@/views/order/requirement/info/RequirementOrderBasicInfoPage'
import RequirementOrderBelongToInfoPage from '@/views/order/requirement/info/RequirementOrderBelongToInfoPage'

export default {
  name: 'RequirementReviewDetail',
  components: {
    RequirementOrderBasicInfoPage,
    RequirementOrderBelongToInfoPage
  },
  props: ['row'],
  computed: {
    statusColor: function () {
      var color = '';
      switch (this.slotData.status) {
        case 'PENDING_QUOTE':
          color = 'red';
          break;
        case 'COMPLETED':
          color = 'green';
          break;
        case 'CANCELLED':
          color = 'grey';
          break;
      }
      return color;
    }
  },
  methods: {
    async getDetail () {
      const url = this.apis().getRequirementOrder(this.row.code);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.slotData = result;
    },
    async getBackup () {
      const url = this.apis().getRequirementOrderBackUp(this.row.code);
      const result = await this.$http.get(url);
      
      if (result.code === 1) {
        this.slotData = JSON.parse(result.data);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else {
        this.$message.error('获取失败!')
      }
    },
  },
  data () {
    return {
      slotData: null
    }
  },
  created () {
    if (this.row.isNewCreated === false && this.row.reviewState === 'REVIEWING' && this.row.status === 'PENDING_QUOTE') {
      this.getBackup();
    } else {
      this.getDetail();
    }
  }
}
</script>

<style scoped>
  .info-title-row {
    margin-bottom: 20px;
  }

  .info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

   .info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }

  .titleClass{
    padding: 10px 0px 1px 10px;
    background-color: #F0F0F0;
  }

  .titleCardClass >>> .el-divider--vertical{
    height: auto;
    margin: 0px;
  }
</style>