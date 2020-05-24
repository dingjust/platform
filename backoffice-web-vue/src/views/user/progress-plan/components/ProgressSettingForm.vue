<template>
  <div>
    <el-row class="progress-basic-row" :gutter="20">
      <el-col :span="12">
        <div class="progress-container">
          <el-table ref="nodeTable" :data="formData.productionProgresses" stripe :height="autoHeight">
            <el-table-column label="节点名称" prop="progressPhase"></el-table-column>
            <el-table-column label="预警天数">
              <template slot-scope="scope">
                <el-input v-model="scope.row.delayedDays"></el-input>
              </template>
            </el-table-column>
            <el-table-column label="操作">
              <template slot-scope="scope">
                <el-button type="text" @click="onDelete(scope.row)" :disabled="isDeleteDisabled(scope.row)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-col>
      <el-col :span="12">
        <div class="progress-container">
          <el-table ref="systemTable" stripe :data="data" :height="autoHeight">
            <el-table-column label="节点名称" prop="progressPhase"></el-table-column>
            <el-table-column label="操作">
              <template slot-scope="scope">
                <el-button type="text" @click="onAppend(scope.row)" :disabled="isDisabled(scope.row)">添加</el-button>
              </template>
            </el-table-column>
            <el-table-column align="right" v-if="!isCreate" min-width="150">
              <template slot="header" slot-scope="scope">
                <el-row>
                  <el-button size="mini">添加节点</el-button>
                  <el-button size="mini" @saveProgressPlan="saveProgressPlan">保存节点方案</el-button>
                </el-row>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ProgressSettingForm',
    props: {
      formData: {
        type: Object
      },
      isCreate: {
        type: Boolean,
        default: true
      }
    },
    methods: {
      onAppend (row) {
        row.delayedDays = 0;
        this.formData.productionProgresses.push(row);
      },
      onDelete (row) {
        const index = this.formData.productionProgresses.findIndex(val => val.progressPhase == row.progressPhase);
        if (index > -1) {
          this.formData.productionProgresses.splice(index, 1);
        }
      },
      isDisabled (row) {
        return this.formData.productionProgresses.findIndex(val => val.progressPhase == row.progressPhase) > -1;
      },
      isDeleteDisabled (row) {
        if (this.isCreate) {
          return false;
        }
        this.$emit('isDeleteDisabled', row);
      },
      saveProgressPlan () {
        this.$emit('saveProgressPlan');
      }
    },
    data () {
      return {
        data: [
          {
            medias: [],
            progressPhase: '备料',
            quantity: 0,
            sequence: 0,
            delayedDays: 0,
            completeAmount: 0,
            productionProgressOrders: []
          },
          {
            medias: [],
            progressPhase: '裁剪',
            quantity: 0,
            sequence: 1,
            delayedDays: 0,
            completeAmount: 0,
            productionProgressOrders: []
          },
          {
            medias: [],
            progressPhase: '车缝',
            quantity: 0,
            sequence: 2,
            delayedDays: 0,
            completeAmount: 0,
            productionProgressOrders: []
          },
          {
            medias: [],
            progressPhase: '后整',
            quantity: 0,
            sequence: 3,
            delayedDays: 0,
            completeAmount: 0,
            productionProgressOrders: []
          },
          {
            medias: [],
            progressPhase: '验货',
            quantity: 0,
            sequence: 4,
            delayedDays: 0,
            completeAmount: 0,
            productionProgressOrders: []
          }
        ]
      }
    }
  }
</script>

<style scoped>
  .progress-basic-row {
    padding-left: 20px;
  }

  .progress-container {
    border: 1px solid #DCDFE6;
    border-radius: 2px;
    width: 100%;
  }
</style>
