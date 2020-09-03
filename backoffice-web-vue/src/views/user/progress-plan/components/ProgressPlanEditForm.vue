<template>
  <div>
    <el-row class="progress-basic-row" :gutter="20">
      <el-col :span="12">
        <div class="progress-container">
          <el-table ref="nodeTable" :data="showData" stripe :height="autoHeight">
            <el-table-column label="节点名称" prop="progressPhase.name"></el-table-column>
            <el-table-column label="预警天数">
              <template slot-scope="scope">
                <el-input v-model="scope.row.warningDays" v-number-input.float="{ min: 0 ,decimal:0}"></el-input>
              </template>
            </el-table-column>
            <el-table-column label="操作">
              <template slot-scope="scope">
                <el-button type="text" @click="onDelete(scope.row)" :disabled="scope.row.isCannotRemove">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-col>
      <el-col :span="12">
        <div class="progress-container">
          <el-table ref="systemTable" stripe :data="phaseData" :height="autoHeight">
            <el-table-column label="节点名称" prop="name"></el-table-column>
            <el-table-column label="操作">
              <template slot-scope="scope">
                <el-button type="text" @click="onAppend(scope.row)" :disabled="canAppend(scope.row)">添加</el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" align="middle" style="margin-top: 20px">
      <el-col :span="4">
        <el-button class="sumbit-btn" @click="onConfirm">确定修改</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ProgressPlanEditForm',
    props: {
      progressPlan: {
        type: Array,
        default: () => []
      }
    },
    methods: {
      async getPhaseList () {
        const url = this.apis().getProgressPhaseList();
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
        }
        this.phaseData = result.data.content.filter(item => item.name !== '产前样' && item.name !== '备料');
      },
      onDelete (row) {
        let index = this.showData.findIndex(item => item.progressPhase.id == row.progressPhase.id);
        this.showData.splice(index, 1);
      },
      canAppend (row) {
        if (this.showData.findIndex(item => item.progressPhase.id == row.id) > -1) {
          return true;
        }
        return false;
      },
      onAppend (row) {
        let item = {
          progressPhase: {
            id: row.id,
            name: row.name
          },
          sequence: row.sequence,
          medias: [],
          warningDays: 3,
          delayedDays: 0,
          quantity: 0,
          completeAmount: 0,
          productionProgressOrders: []
        }
        this.showData.push(item);
        this.showData.sort((o1, o2) => o1.sequence - o2.sequence);
      },
      onConfirm () {
        this.$emit('onEditProgress', this.showData);
      }
    },
    data () {
      return {
        phaseData: [],
        showData: []
      }
    },
    created() {
      this.getPhaseList();
      this.showData = JSON.parse(JSON.stringify(this.progressPlan));
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

  .sumbit-btn {
    background-color: #ffd60c;
  }
</style>
