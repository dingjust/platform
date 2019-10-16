<template>
  <div class="info-detail-staff-body">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">操作日记</h6>
      </div>
    </el-row>
    <div class="block">
      <el-timeline>
        <el-timeline-item placement="top" v-for="(activity, index) in activities" :key="index"
          :color="index==0?'#FFD60C':'#E4E7ED'" :timestamp="activity.timestamp">
          <p class="info-log-content">{{activity.content}}</p>
        </el-timeline-item>
      </el-timeline>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'PurchaseOrderInfoLog',
    props: ['slotData'],
    components: {},
    mixins: [],
    computed: {

    },
    methods: {},
    data() {
      return {
        activities: [{
          content: '刘少力完成第二部分付款 ¥20000',
          timestamp: '2018-04-12 20:46',
          icon: 'el-icon-arrow-up'
        }, {
          content: '刘少力完成第二部分付款 ¥20000',
          timestamp: '2018-04-03 20:46',
          color: '#0bbd87'
        }, {
          content: '刘少力完成第二部分付款 ¥20000',
          timestamp: '2018-04-03 20:46',
          size: 'large'
        }, {
          content: '刘少力完成第二部分付款 ¥20000',
          timestamp: '2018-04-03 20:46'
        }]
      };
    },
    created() {}
  }

</script>
<style>
  .info-detail-staff-body {
    width: 100%;
    margin-top: 20px;
  }

  .info-row {
    margin-top: 5px;
  }

  .info-log-content{
    font-size: 10px;
    margin-top: 10px;
  }

</style>
