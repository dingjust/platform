<template>
  <div>
    <template v-for="item in slotData.progresses">
      <el-row type="flex" justify="center" align="middle" class="progress-date-form-row" :key="item.id">
        <div class="progress-date-form-title">
          <h6>{{item.progressPhase.name}}</h6>
        </div>
        <el-date-picker v-model="item.estimatedDate" :picker-options="pickerOptions" type="date" placeholder="选择日期">
        </el-date-picker>
      </el-row>
    </template>
    <h6 class="progress-date-form-info">预计交货时间：{{slotData.expectedDeliveryDate | formatDate}}</h6>
    <el-row type="flex" justify="center" style="margin-top:20px;">
      <el-button @click="onSubmit" type="primary">确定</el-button>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ProductionProgressDateSettingForm',
    props: ['slotData'],
    components: {},
    computed: {},
    methods: {
      async onSubmit() {
        const url = this.apis().setProgressDate(this.slotData.code);
        const result = await this.$http.put(url, this.slotData.progresses);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('设置成功');
        this.$emit('afterSubmit');
      }
    },
    data() {
      return {
        pickerOptions: {
          // disabledDate(time) {
          //   let date=new Date();
          //   date.setDate(date.getDate()-1);
          //   return time.getTime() < date;
          // },
        }
      };
    },
    created() {},
  };

</script>
<style>
  .purchase-grid-content {
    text-align: center;
    border-left: 2px solid rgba(0, 0, 0, 0.09);
  }

  .progress-date-form-row {
    margin-top: 10px;
  }

  .progress-date-form-title {
    width: 50px;
  }

  .progress-date-form-info {
    color: red;
    size: 12px;
    margin-left: 50px;
    margin-top: 10px;
  }

</style>
