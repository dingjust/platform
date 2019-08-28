<template>
  <el-row type="flex" justify="space-between">
    <template v-for="(item,index) in mockData">
      <el-col :span="5">
        <el-row type="flex" justify="center" align="middle">
          <h6 class="progress-status">{{item.status}}</h6>
        </el-row>
        <el-row type="flex" justify="center" align="middle">
          <div :class="getLeftLine(index,mockData)" />
          <el-col :span="6">
            <div
              :class="item.finsh?'progress-icon-container':isDoing(index,mockData)?'progress-icon-container_doing':'progress-icon-container_none'">
              <i class="iconfont2 progress-icon" v-html="item.icon" v-if="!isDoing(index,mockData)"></i>
              <h6 v-if="isDoing(index,mockData)" class="progress-icon-container_text">进行中</h6>
            </div>
          </el-col>
          <div :class="getRightLine(index,mockData)" />
        </el-row>
        <el-row type="flex" justify="center" align="middle">
          <div class="progress-line-horizon_none" />
          <div :class="item.finsh?'progress-line-vertical':'progress-line-vertical_none'">
          </div>
          <div class="progress-line-horizon_none" />
        </el-row>
        <el-row type="flex" justify="center" align="middle" v-if="item.img!=null">
          <img class="progress-img" :src="item.img">
        </el-row>
        <el-row type="flex" justify="center" align="middle" class="progress-row" v-if="item.finshDate!=null">
          <el-col :span="19" :offset="4">
            <h6 class="progress-info">完成日期: {{item.finshDate}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" justify="center" align="middle" v-if="item.num!=null">
          <el-col :span="19" :offset="4">
            <h6 class="progress-info">完成数量: {{item.num}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" justify="center" align="middle" v-if="item.remarks!=null">
          <el-col :span="19" :offset="4">
            <h6 class="progress-info">备注: {{item.remarks}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" justify="center" align="middle" v-if="!item.finsh">
          <el-button size="mini" class="info-detail-logistics_info-btn1">编辑</el-button>
        </el-row>
        <el-row type="flex" style="margin-top:5px;" justify="center" align="middle" v-if="!item.finsh&&isDoing(index,mockData)">
          <el-button size="mini" class="info-detail-logistics_info-btn1">{{item.status}}完成</el-button>
        </el-row>
      </el-col>
    </template>
  </el-row>
</template>

<script>
  export default {
    name: "PurchaseOrderProgress",
    props: ['slotData'],
    components: {},
    computed: {},
    methods: {
      ///判断左边线样式
      getLeftLine(index, data) {
        if (index == 0) {
          return 'progress-line-horizon_none'
        } else {
          if (data[index].finsh) {
            return 'progress-line-horizon';
          } else {
            return 'progress-line-horizon_grey';
          }
        }
      },
      ///判断右边线样式
      getRightLine(index, data) {
        if (index == data.length - 1) {
          return 'progress-line-horizon_none'
        } else {
          if (data[index].finsh) {
            if (data[index + 1].finsh) {
              return 'progress-line-horizon'
            } else {
              return 'progress-line-horizon_grey';
            }
          } else {
            return 'progress-line-horizon_grey';
          }
        }
      },
      ///判断是否正在进行中
      isDoing(index, data) {
        if (data[index].finsh) {
          return false;
        } else {
          if (index == 0) {
            return true;
          } else {
            if (data[index - 1].finsh) {
              return true;
            } else {
              return false;
            }
          }
        }
      }
    },
    data() {
      return {
        mockData: [{
            status: '备料',
            finshDate: '2019-3-1',
            num: 2000,
            remarks: '延期两天，后面 时间赶回来',
            img: '/resource/h0f/h26/8804513611806.jpg',
            finsh: true,
            icon: '&#xe675;'
          },
          {
            status: '裁剪',
            finshDate: '2019-3-1',
            num: 2000,
            remarks: '延期两天，后面 时间赶回来',
            img: '/resource/h0f/h26/8804513611806.jpg',
            finsh: true,
            icon: '&#xe677;'
          },
          {
            status: '车缝',
            finshDate: '2019-3-1',
            num: 2000,
            remarks: '延期两天，后面 时间赶回来',
            finsh: false,
            icon: '&#xe67a;'
          },
          {
            status: '后整',
            finshDate: '2019-3-1',
            num: 2000,
            remarks: '延期两天，后面 时间赶回来',
            finsh: false,
            icon: '&#xe679;'
          },
          {
            status: '验货',
            finshDate: '2019-3-1',
            num: 2000,
            remarks: '延期两天，后面 时间赶回来',
            finsh: false,
            icon: '&#xe689;'
          }
        ]
      };
    },
    created() {

    }
  };

</script>
<style>
  .progress-status {
    font-weight: 500;
    color: rgba(0, 0, 0, 0.85);
    font-size: 12px;
  }

  .progress-vertical-line {
    height: 100px;
    width: 1px;
    background-color: aqua;
  }

  .progress-icon-container {
    background-color: #ffd60c;
    /* background-color: rgb(87, 84, 68); */
    border-radius: 50%;
    width: 35px;
    height: 35px;
    text-align: center;
    line-height: 35px;
  }

  .progress-icon-container_doing {
    background-color: rgba(5, 0, 1, 0.45);
    border-radius: 50%;
    width: 35px;
    height: 35px;
    text-align: center;
    line-height: 35px;
  }

  .progress-icon-container_text {
    font-size: 10px;
    color: #fff;
    line-height: 35px;
  }

  .progress-icon-container_none {
    background-color: #F2EFF0;
    /* background-color: rgb(87, 84, 68); */
    border-radius: 50%;
    width: 35px;
    height: 35px;
    text-align: center;
    line-height: 35px;
  }


  .progress-icon {
    font-size: 24px;
  }

  .progress-line-horizon {
    width: 100%;
    height: 2px;
    border-top: 2px dashed #FFD60C;
  }

  .progress-line-horizon_none {
    width: 100%;
    height: 2px;
    /* border-top: 1px dashed #FFD60C; */
  }

  .progress-line-horizon_grey {
    width: 100%;
    height: 2px;
    border-top: 2px dashed #F2EFF0;
  }

  .progress-line-vertical {
    width: 1px;
    height: 50px;
    border-left: 0.5px solid #FFD60C;
    margin-left: 3px;
    /* margin-left:  */
  }

  .progress-line-vertical_none {
    width: 1px;
    height: 50px;
    border-left: 0.5px solid #F2EFF0;
    margin-left: 3px;
    /* margin-left:  */
  }

  .progress-img {
    width: 90px;
    height: 50px;
    border-radius: 5px;
  }

  .progress-info {
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    font-size: 10px;
  }

  .progress-row {
    margin-top: 2px;
  }

</style>
