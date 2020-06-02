<template>
  <div>
<!--    <el-row class="progress-row">-->
<!--      <el-col :span="6">-->
<!--        <el-form-item label="生产节点" prop="progressPlan">-->
<!--          <el-input :disabled="true"></el-input>-->
<!--        </el-form-item>-->
<!--      </el-col>-->
<!--    </el-row>-->
    <el-row class="progress-row" :gutter="20">
      <el-col :span="12">
        <div class="progress-container">
          <el-table ref="nodeTable" :data="formData.progresses" stripe :height="autoHeight">
            <el-table-column label="节点名称" prop="progressPhase"></el-table-column>
            <el-table-column label="预警天数">
              <template slot-scope="scope">
                <el-input v-model="scope.row.delayedDays" v-if="!scope.row.originPhase"></el-input>
                <span v-else>{{scope.row.delayedDays}}</span>
              </template>
            </el-table-column>
            <el-table-column label="操作">
              <template slot-scope="scope">
                <el-button type="text" @click="onDelete(scope.row, scope.$index)" :disabled="scope.row.originPhase">删除</el-button>
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
                <el-button type="text" @click="onAppend(scope.row)" :disabled="isDisabled(scope.row)">添加</el-button>
              </template>
            </el-table-column>
            <el-table-column align="right" min-width="150">
              <template slot="header" slot-scope="scope">
                <el-row>
<!--                  <el-button size="mini">添加节点</el-button>-->
                  <el-button size="mini" @click="progressPlanVisible=!progressPlanVisible">保存节点方案</el-button>
                </el-row>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-col>
    </el-row>
    <el-dialog :visible.sync="progressPlanVisible" width="30%" class="purchase-dialog" append-to-body
               :close-on-click-modal="false">
      <div>
        <el-row>
          <el-col>
            <div class="progress-list-title">
              <h6>保存节点方案</h6>
            </div>
          </el-col>
        </el-row>
        <el-form :model="saveData">
          <el-row>
            <el-form-item label="方案名称" prop="name"
                          :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="saveData.name"></el-input>
            </el-form-item>
          </el-row>
          <el-row>
            <el-form-item label="备注">
              <el-input v-model="saveData.remarks"></el-input>
            </el-form-item>
          </el-row>
        </el-form>
        <el-row type="flex" justify="center" align="middle">
          <el-button class="material-btn" @click="saveProgressPlan">保存</el-button>
        </el-row>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import ProgressPlanSelectDialog from '../../../../user/progress-plan/components/ProgressPlanSelectDialog';
  import ProgressSettingForm from '../../../../user/progress-plan/components/ProgressSettingForm';
  export default {
    name: 'ProgressOrderNodeForm',
    components: {ProgressSettingForm, ProgressPlanSelectDialog},
    props: ['formData'],
    methods: {
      async getPhaseList () {
        const url = this.apis().getProgressPhaseList();
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
        }
        this.phaseData = Object.assign([], result.data.content);
      },
      onDelete (row, index) {
        this.formData.progresses.splice(index, 1);
      },
      onAppend (row) {
        this.formData.progresses.push({
          medias: [],
          progressPhase: row.name,
          quantity: 0,
          sequence: row.sequence,
          completeAmount: 0,
          productionProgressOrders: []
        });
        this.formData.progresses.sort((o1, o2) => {
          return o1.sequence - o2.sequence;
        })
      },
      isDisabled (row) {
        console.log(this.currentSequence);
        return this.formData.progresses.findIndex(val => val.progressPhase == row.name) > -1 ||
        row.sequence < this.currentSequence;
      },
      async saveProgressPlan () {
        let item = {};
        this.formData.progresses.forEach(val => {
          item.medias = val.medias;
          item.progressPhase = val.progressPhase;
          item.quantity = val.quantity;
          item.sequence = val.sequence;
          item.completeAmount = val.completeAmount;
          item.productionProgressOrders = val.productionProgressOrders;
          this.saveData.productionProgresses.push(item);
          item = {}
        })
        const url = this.apis().createProgressPlan();
        const result = await this.$http.post(url, this.saveData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('保存节点方案成功');
        this.progressPlanVisible = !this.progressPlanVisible;
      }
    },
    data () {
      return {
        progressPlanVisible: false,
        phaseData: [],
        originData: this.formData.progresses,
        currentSequence: '',
        saveData: {
          name: '',
          remarks: '',
          productionProgresses: []
        }
      }
    },
    watch: {
      'formData.currentPhase': {
        handler (val) {
          if (val) {
            let index = this.formData.progresses.findIndex(val => val.progressPhase == this.formData.currentPhase);
            this.currentSequence = this.formData.progresses[index].sequence;
          }
        },
        deep: true
      }
    },
    created () {
      this.getPhaseList();
    },
    mounted () {
    }
  }
</script>

<style scoped>
  .progress-row {
    padding-left: 10px;
    margin-top: 20px;
  }

  .progress-container {
    border: 1px solid #DCDFE6;
    border-radius: 2px;
    width: 100%;
  }

  .progress-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    /* border-color: #000000; */
    color: #000;
    width: 100px;
    /* height: 35px; */
    margin-top: 20px;
  }
</style>
