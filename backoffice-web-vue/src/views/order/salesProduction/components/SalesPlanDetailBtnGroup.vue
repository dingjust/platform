<template>
  <div>
    <el-row type="flex" justify="space-around" style="margin-top: 20px" :gutter="50">
      <el-col :span="3" v-if="state=='AUDITING'">
        <el-button class="material-btn" @click="onWithdraw">撤回</el-button>
      </el-col>
      <el-col :span="3" v-if="(state=='NONE'||state=='AUDITED_FAILED')&&canRefuse">
        <el-button class="material-btn_red" @click="onRefuse">拒单</el-button>
      </el-col>
      <el-col :span="3">
        <el-button class="material-btn" @click="onGoback">返回</el-button>
      </el-col>
      <el-col :span="3" v-if="state=='NONE'||state=='AUDITED_FAILED'">
        <el-button class="material-btn" @click="onSave">保存</el-button>
      </el-col>
      <el-col :span="3" v-if="state=='NONE'||state=='AUDITED_FAILED'">
        <el-button class="material-btn" @click="onSubmit">提交审核</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'SalesPlanDetailBtnGroup',
    props: {
      state: {
        type: String
      },
      canRefuse: {
        type: Boolean,
        default: false
      }
    },
    data() {
      return {}
    },
    computed: {

    },
    methods: {
      onGoback() {
        this.$router.go(-1);
      },
      onWithdraw() {
        this.$emit('onWithdraw');
      },
      onSave() {
        this.$emit('onSave');
      },
      onSubmit() {
        this.$emit('onSubmit');
      },
      onRefuse() {
        this.$emit('onRefuse');
      }
    }
  }

</script>

<style scoped>
  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  .material-btn_red {
    background-color: red;
    /* border-color: #FFD5CE; */
    color: white;
    width: 90px;
    height: 35px;
  }

</style>
