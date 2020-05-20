<template>
  <el-row type="flex" justify="space-between">
    <template v-for="(item, index) in slotData.progress">
      <el-col :span="24/slotData.length">
        <el-row type="flex" justify="space-around">
          <h6 v-if="item.delatedDays" style="color: #F56C6C">延误{{item.delatedDays}}天</h6>
          <h6 v-if="!item.compleTime && !item.delatedDays">预计完成：{{item.expectedTime | timestampToTime}}</h6>
          <h6 v-if="item.compleTime && !item.delatedDays">完成时间：{{item.compleTime | timestampToTime}}</h6>
        </el-row>
        <el-row type="flex" justify="space-around">
          <i class="el-icon-success progress-icon" ref="progressIcon"
             :style="iconColor(item, slotData)"/>
          <div class="progress-line" :style="lineColor(item, slotData, index)"></div>
        </el-row>
        <el-row type="flex" justify="space-around">
          <h6>{{getEnum('productionProgressPhaseTypes', item.code)}}</h6>
        </el-row>
      </el-col>
    </template>
  </el-row>
</template>

<script>
  export default {
    name: 'ProgressOrderSteps',
    props: ['slotData'],
    methods: {
      iconColor (item, slotData) {
        console.log('-----------------------------------')
        console.log(item)
        console.log(slotData)
        console.log(item.sequence < slotData.phaseSqeuence)
        if (item.sequence < slotData.phaseSqeuence) {
          return 'color: #67C23A';
        } else if ((item.sequence > slotData.phaseSqeuence)) {
          return 'color: #909399;';
        } else {
          return 'color: #000000';
        }
      },
      lineColor (item, slotData, index) {
        const width = 'width:' + this.widthList[index] + 'px;';
        const marginleft = 'margin-left:' + this.widthList[index] / 2 + 'px;';
        if (item.sequence == slotData.phaseSqeuence - 1) {
          return 'border-color: #000000;' + width + marginleft;
        } else if (item.sequence < slotData.phaseSqeuence) {
          return 'border-color: #67C23A;' + width + marginleft;
        } else {
          return 'border-color: #909399;' + width + marginleft;
        }
      },
      getWidthList () {
        let leftLH = [];
        let startX;
        this.$nextTick(() => {
          this.$refs.progressIcon.forEach((val, index) => {
            startX = val.getBoundingClientRect().x;
            this.widthList.push(startX);
          })
          for (let i = 0; i < this.widthList.length - 1; i++) {
            leftLH.push(this.widthList[i + 1] - this.widthList[i]);
          }
          this.widthList = leftLH;
        });
      }
    },
    data () {
      return {
        widthList: []
      }
    },
    mounted () {
      this.getWidthList();
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
    margin-top: 15px;
    /*margin-left: 60px;*/
    position: absolute;
    z-index: 0;
  }
</style>
