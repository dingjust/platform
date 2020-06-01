<template>
  <div>
    <el-row type="flex" justify="space-between">
      <template v-for="(item, index) in progresses">
        <el-col :span="getSpan">
          <el-row type="flex" justify="center" align="middle">
            <h6 v-if="item.delatedDays" style="color: #F56C6C">延误{{item.delatedDays}}天</h6>
            <h6 v-if="!item.compleTime && !item.delatedDays">预计完成：{{item.expectedTime | timestampToTime}}</h6>
            <h6 v-if="item.compleTime && !item.delatedDays">完成时间：{{item.compleTime | timestampToTime}}</h6>
          </el-row>
        </el-col>
      </template>
    </el-row>
    <el-row type="flex" justify="space-between">
      <template v-for="(item, index) in progresses">
        <el-col :span="getSpan">
          <el-row type="flex" justify="center" align="middle">
            <div class="step-circular" :style="setStepStyle(item, index)">
              <i class="el-icon-check step-icon" :style="setIconStyle(item, index)"></i>
            </div>
            <div class="progress-line" v-if="index != progresses.length - 1" :style="lineColor(item, index)"></div>
          </el-row>
          <el-row type="flex" justify="center">
            <h6>{{getEnum('productionProgressPhaseTypes', item.code)}}</h6>
          </el-row>
        </el-col>
      </template>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ProgressOrderSteps',
    props: ['phaseSqeuence', 'progresses'],
    computed: {
      getSpan: function () {
        return Math.ceil(24 / this.progresses.length);
      }
    },
    methods: {
      setStepStyle (item, index) {
        if (item.sequence < this.phaseSqeuence) {
          return 'background-color: #67C23A;border: 2px solid #67C23A;';
        } else if (item.sequence > this.phaseSqeuence) {
          return 'background-color: #FFFFFF;border: 2px solid #909399;';
        } else {
          return 'background-color: #FFFFFF;border: 2px solid #000000;';
        }
      },
      setIconStyle (item, index) {
        if (item.sequence < this.phaseSqeuence) {
          return 'color: #000000';
        } else {
          return 'color: #FFFFFF';
        }
      },
      lineColor (item, index) {
        // if (item.sequence == this.phaseSqeuence - 1) {
        //   return 'border-color: #000000;';
        // } else
        if (item.sequence < this.phaseSqeuence - 1) {
          return 'border-color: #67C23A;';
        } else {
          return 'border-color: #909399;';
        }
      }
    },
    data () {
      return {
      }
    },
    watch: {
    },
    mounted () {
    }
  }
</script>

<style scoped>
  .progress-icon {
    font-size: 30px;
    margin-bottom: 5px;
    background-color: #FFFFFF;
    border-radius: 50%;
    z-index: 2;
  }

  .progress-success-icon {
    color: #67C23A;
  }

  .progress-wait-icon {
    color: #909399;
  }

  .progress-line {
    border-top: 2px solid #DCDFE6;
    /*margin-top: 15px;*/
    /*margin-left: 60px;*/
    width: 100%;
    z-index: 0;
    left: 50%;
    position: absolute;
  }

  .step-circular {
    width: 30px;
    height: 30px;
    /*background-color: #000000;*/
    border-radius: 30px;
    /*border: 2px solid #DCDFE6;*/
    z-index: 2;
  }

  .step-icon {
    font-size: 20px;
    font-weight: bolder;
    padding-top: 4px;
    padding-left: 2px;
  }
</style>
