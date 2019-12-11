<template>
  <div class="animated fadeIn dashboard-card">
    <el-row type="flex" justify="space-between" class="progress-card-title_row">
      <el-col :span="10">
        <el-row type="flex" justify="space-between">
          <h6 class="progress-card-btn" :style="showDelieryOrder?'':activeStyle" @click="showDelieryOrder=false">上线倒计时
          </h6>
          <el-divider direction="vertical"></el-divider>
          <h6 class="progress-card-btn" :style="showDelieryOrder?activeStyle:''" @click="showDelieryOrder=true">交货倒计时
          </h6>
        </el-row>
      </el-col>
      <el-col :span="6">
        <el-row type="flex" justify="end">
          <h6 class="progress-card-btn_all" v-if="showDelieryOrder">剩余{{data.progress.totalElements-data.progress.numberOfElements}}条记录</h6>
          <h6 class="progress-card-btn_all" v-if="!showDelieryOrder">剩余{{data.order.totalElements-data.order.numberOfElements}}条记录</h6>
        </el-row>
      </el-col>
    </el-row>
    <template v-if="!showDelieryOrder" v-for="item in data.progress.content">
      <div class="warning-progress-row">
        <el-row type="flex" justify="space-between">
          <h6 class="progress-card-info">{{item.code}}</h6>
          <h6 class="progress-card-info">{{isDelay(item.remainDays)?'已延期':'剩余'}}<span
              :class="isDelay(item.remainDays)?'progress-card-info_warning':'progress-card-info_safe'">{{Math.abs(item.remainDays)}}</span>天
          </h6>
        </el-row>
        <warning-progress :remainDay="item.remainDays" />
      </div>
    </template>
    <template v-if="showDelieryOrder" v-for="item in data.order.content">
      <div class="warning-progress-row">
        <el-row type="flex" justify="space-between">
          <h6 class="progress-card-info">{{item.code}}</h6>
          <h6 class="progress-card-info">{{isDelay(item.remainDays)?'已延期':'剩余'}}<span
              :class="isDelay(item.remainDays)?'progress-card-info_warning':'progress-card-info_safe'">{{Math.abs(item.remainDays)}}</span>天
          </h6>
        </el-row>
        <warning-progress :remainDay="item.remainDays" />
      </div>
    </template>
  </div>
</template>

<script>
  import WarningProgress from '@/components/custom/WarningProgress';

  export default {
    name: 'ProgressCard',
    components: {
      WarningProgress
    },
    computed: {

    },
    methods: {
      isDelay(remainDays) {
        return remainDays < 0;
      },
      async getData() {
        const url = this.apis().reportsProgress();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.data = result;
      }
    },
    data() {
      return {
        showDelieryOrder: false,
        activeStyle: {
          color: '#FFA403'
        },
        onlineOrders: [{
            code: "TP00001",
            remainDays: 1,
          },
          {
            code: "TP00001",
            remainDays: 3,
          }, {
            code: "TP00001",
            remainDays: -3,
          }, {
            code: "TP00001",
            remainDays: -5,
          }, {
            code: "TP00001",
            remainDays: 5,
          }
        ],
        deliveryOrders: [{
            code: "TP00002",
            remainDays: 2,
          },
          {
            code: "TP00001",
            remainDays: -1,
          }, {
            code: "TP00001",
            remainDays: 1,
          }, {
            code: "TP00001",
            remainDays: 5,
          }, {
            code: "TP00001",
            remainDays: -2,
          }
        ],
        data: {
          progress: {
            content: [],
            last: false,
            totalElements: 0,
            totalPages: 0,
            size: 5,
            number: 1,
            sort: null,
            first: false,
            numberOfElements: 5
          },
          order: {
            content: [],
            last: false,
            totalElements: 0,
            totalPages: 0,
            size: 5,
            number: 1,
            sort: null,
            first: false,
            numberOfElements: 5
          }
        },
      };
    },
    created() {
      this.getData();
    }
  };

</script>
<style>
  .warning-progress-row {
    margin-bottom: 15px;
  }

  .progress-card-info {
    font-size: 12px;
    color: rgba(0, 0, 0, 0.4);
  }

  .progress-card-info_warning {
    color: #FF6666;
  }

  .progress-card-info_safe {
    color: #7AED8F;
  }

  .progress-card-btn {
    font-size: 13px;
    cursor: pointer;
    color: #999999;
  }

  .progress-card-btn:hover {
    color: #FFA403;
  }

  .progress-card-title_row {
    margin-bottom: 15px;
  }

  .progress-card-btn_all {
    color: #FFA403;
    font-size: 12px;
  }

  .progress-card-btn_all:hover {
    cursor: pointer;
  }

</style>
