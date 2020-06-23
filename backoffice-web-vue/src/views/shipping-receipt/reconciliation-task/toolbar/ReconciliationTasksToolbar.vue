<template>
  <div>
    <el-form :inline="true">
      <el-row type="flex" justify="space-between">
        <el-col :span="22">
          <el-form-item label="订单信息">
            <el-input placeholder="输入订单号、产品名或货号" v-model="queryFormData.keyword" style="width: 130px"></el-input>
          </el-form-item>
          <el-form-item label="负责人">
            <el-input placeholder="输入负责人名称" v-model="queryFormData.productionLeaderName" style="width: 120px"></el-input>
          </el-form-item>
          <el-form-item label="合作商">
            <el-input placeholder="输入合作商名称" v-model="queryFormData.operatorName" style="width: 120px"></el-input>
          </el-form-item>
          <el-form-item label="创建时间">
            <el-date-picker
              v-model="dateArr"
              style="width: 215px"
              type="daterange"
              value-format="timestamp"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期">
            </el-date-picker>
          </el-form-item>
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </el-col>
        <el-col :span="2">
          <el-button class="create-btn" @click="onCreate" v-if="canCreate">创建对账单</el-button>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'ReconciliationTasksToolbar',
    props: ['queryFormData', 'canCreate'],
    components: {

    },
    computed: {

    },
    methods: {
      onAdvancedSearch () {
        this.$emit('onAdvancedSearch', 0 , 10);
      },
      onReset () {
        this.dateArr = [];
        this.queryFormData.keyword = '';
        this.queryFormData.productionLeaderName = '';
        this.queryFormData.operatorName = '';
        this.queryFormData.creationtimeStart = '';
        this.queryFormData.creationtimeEnd = '';
      },
      onCreate () {
        this.$emit('onCreate');
      }
    },
    data () {
      return {
        dateArr: []
      }
    },
    watch: {
      dateArr: function (newVal, oldVal) {
        if (newVal) {
          this.queryFormData.creationtimeStart = newVal[0];
          this.queryFormData.creationtimeEnd = newVal[1];
        }
      }
    },
    create () {
      
    }
  }
</script>

<style scoped>
  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }
  
  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
  }

  /deep/ .el-date-editor .el-range-separator {
    width: 12%;
  }
</style>