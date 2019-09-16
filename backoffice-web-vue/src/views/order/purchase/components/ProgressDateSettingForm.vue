<template>
  <div>
    <template v-for="item in estimateDates">
      <el-row type="flex" justify="center" align="middle" class="progress-date-form-row">
        <div class="progress-date-form-title">
          <h6>{{getEnum('productionProgressPhaseTypes', item.phase)}}</h6>
        </div>
        <el-date-picker v-model="item.estimatedDate" type="date" placeholder="选择日期">
        </el-date-picker>
      </el-row>
    </template>
    <el-row type="flex" justify="center" style="margin-top:20px;">
      <el-button @click="onSubmit" type="primary">确定</el-button>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: "ProgressDateSettingForm",
    props: ['slotData'],
    components: {},
    computed: {},
    methods: {
      generateDates() {
        var array = [];
        this.slotData.progresses.forEach(element => {
          array.push({
            creationtime: element.creationtime,
            delayedDays: element.delayedDays,
            estimatedDate: element.estimatedDate,
            id: element.id,
            medias: element.medias,
            modifiedtime: element.modifiedtime,
            phase: element.phase,
            quantity: element.quantity,
            sequence: element.sequence,
            updateOnly:true,
          });
        });;
        this.estimateDates = array;
      },
      async onSubmit() {
        const url = this.apis().updateProgressForBatch(this.slotData.code);
        const result = await this.$http.put(url, this.estimateDates);
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
        estimateDates: []
      };
    },
    created() {
      this.generateDates();
    },
    watch: {
      slotData: {
        handler(val, oldVal) {
          this.generateDates();
        },
        deep: true
      },
    }
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

</style>
