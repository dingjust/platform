<template>
  <div class="progress-container">
    <el-table ref="systemTable" stripe :data="formData.productionProgresses" :height="autoHeight">
      <el-table-column label="节点名称" prop="phase"></el-table-column>
      <el-table-column label="预计结束时间" prop="estimatedDate">
        <template slot-scope="scope">
          <el-link v-if="!modifyTime || modifyIndex != scope.$index" @dblclick.native="dblclickTime(scope.$index, scope.row)">
            {{scope.row.estimatedDate | timestampToTime}}
          </el-link>
          <el-date-picker v-if="modifyTime && modifyIndex == scope.$index" ref="datePicker"
                          @blur="timeBlur(scope.row)" :clearable="false"
                          v-model="scope.row.estimatedDate" style="width: 90%" size="mini"
                          type="date" value-format="timestamp" placeholder="选择日期"/>
        </template>
      </el-table-column>
      <el-table-column label="节点预警天数" prop="delayedDays">
        <template slot-scope="scope">
          <el-link v-if="!modifyDay || modifyIndex != scope.$index" @dblclick.native="dblclickDay(scope.$index, scope.row)">
            {{scope.row.delayedDays}}
          </el-link>
          <el-input v-if="modifyDay && modifyIndex == scope.$index" ref="input" id="text" size="mini"
                    v-model="scope.row.delayedDays"
                    v-number-input.float="{ min: 0 ,decimal:2}"
                    @blur="dayBlur(scope.row)" onkeydown="if(event.keyCode==13){blur()}">
          </el-input>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDelete(scope.$index)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column align="right" min-width="150">
        <template slot="header" slot-scope="scope">
          <el-row>
            <el-button size="mini">添加节点</el-button>
            <el-button size="mini" @saveProgressPlan="saveProgressPlan">保存节点方案</el-button>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <h6 style="color: #F56C6C">*双击具体的 "预计结束时间" 或 "节点预警时间" 进行编辑</h6>
  </div>
</template>

<script>
  export default {
    name: 'ProgressFactorySettingForm',
    props: ['formData'],
    methods: {
      saveProgressPlan () {
        this.$emit('saveProgressPlan');
      },
      onDelete (index) {
        this.formData.productionProgresses.splice(index, 1);
      },
      // 双击某行的预计结束时间
      dblclickTime (index, row) {
        this.modifyTime = true;
        this.modifyIndex = index;
        // 获取焦点
        this.$nextTick(() => {
          this.$refs.datePicker.focus();
        })
      },
      timeBlur (row) {
        this.modifyTime = false;
        this.modifyIndex = '';
      },
      // 双击某行延迟天数
      dblclickDay (index, row) {
        this.modifyDay = true;
        this.modifyIndex = index;
        this.originalDay = row.delayedDays;
        // 获取焦点
        this.$nextTick(() => {
          this.$refs.input.focus();
          let text = document.getElementById('text');
          // 选中框中的所有文本;
          text.select();
        })
      },
      // 延迟天数输入框失去焦点
      dayBlur (row) {
        this.modifyDay = false;
        this.modifyIndex = '';
        // 输入框未空的情况默认为0
        if (row.delayedDays == '') {
          row.delayedDays = this.originalDay;
        }
      }
    },
    data () {
      return {
        modifyTime: false,
        modifyDay: false,
        modifyIndex: '',
        originalDay: ''
      }
    }
  }
</script>

<style scoped>
  .progress-container {
    border: 1px solid #DCDFE6;
    border-radius: 2px;
    padding: 10px;
    width: 100%;
  }

  /deep/ .el-link.el-link--default:hover {
    color: #409eff;
  }
</style>
