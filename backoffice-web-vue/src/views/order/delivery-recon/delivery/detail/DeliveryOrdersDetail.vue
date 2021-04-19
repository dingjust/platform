
<!--
* @Description: 出货单详情
* @Date 2020/11/24 11:36
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col class="list-title">
          <h6>出货单详情</h6>
        </el-col>
        <el-col>
          <h6>出货单号：{{order.code}}</h6>
        </el-col>
        <el-col>
          <h6>创建日期：{{order.creationtime | timestampToTime}}</h6>
        </el-col>
        <el-col>
          <h6>状态：{{getEnum('DeliveryType', order.state)}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-container" style="margin-top: 20px">
        <h6 class="basic-text">标题：{{order.title}}</h6>
      </el-row>
      <el-row type="flex" justify="start" class="basic-container">
        <h6 class="basic-text">合作商：{{order.cooperator.type === 'ONLINE' ? order.cooperator.partner.name : order.cooperator.name}}</h6>
      </el-row>
      <el-row type="flex" justify="start" class="basic-container">
        <h6 class="basic-text" style="min-width: 48px;">单据：</h6>
        <div class="display: flex;flex-wrap: wrap;">
          <template v-if="order.medias && order.medias.length > 0">
            <el-image 
              title="点击查看大图及更多"
              v-for="media in order.medias"
              :key="media.id"
              class="media-image"
              :src="media.url"
              :preview-src-list="order.medias.map(item => item.url)" 
              :z-index="9999"/>
          </template>
        </div>
      </el-row>
      <el-row type="flex" justify="start" class="basic-container">
        <h6 class="basic-text">备注：{{order.remarks}}</h6>
      </el-row>
      <el-row v-if="order.state === 'PENDING_RECONCILED'" type="flex" justify="center">
        <el-button type="primary" size="medium" class="reconciliation-btn" v-if="canRecon" @click="onReconciliation">去对账</el-button>
      </el-row>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'DeliveryOrdersDetail',
  props: ['id'],
  computed: {
    canRecon: function () {
      // receiveParty 才能创建对账单
      return this.order.receiveParty.uid === this.$store.getters.currentUser.companyCode
    }
  },
  data () {
    return {
      order: {
        receiveParty: {},
        shipParty: {},
        cooperator: {}
      },
      currentUserUid: this.$store.getters.currentUser.uid
    }
  },
  methods: {
    async getDetail () {
      const url = this.apis().getDeliveryDetail(this.id);
      const result = await this.$http.get(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }

      this.order = result.data;  
    },
    onReconciliation () {
      this.$router.push({
        name: '创建出货对账单',
        params: {
          order: this.order
        }
      });
    }
  },
  created () {
    this.getDetail();
  }
}
</script>

<style scoped>
  .list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
    height: 16px;
  }

  .basic-container {
    margin: 0 0 20px 12px;
  }

  .basic-text {
    font-size: 16px;
    color: #303133;
    margin: 0px;
  }
  
  .reconciliation-btn {
    background: #ffd60c;
    color: #303133;
    border-color: #ffd60c;
  }

  .media-image {
    width: 100px; 
    height: 100px;
    margin: 0 0 10px 15px;
    border-radius: 5px;
  }
</style>