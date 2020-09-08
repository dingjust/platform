<template>
  <el-row type="flex" justify="space-between" style="margin: 15px 30px;">
    <template v-for="item in titleList">
      <div class="step-block" :key="item.code">
        <div class="number-icon" :style="item.code === step ? 'background-color: #ffd60c;' : ''">{{item.code}}</div>
        <h6 class="step-title">{{item.title}}</h6>
      </div>
    </template>
  </el-row>
</template>

<script>
export default {
  name: 'ContractSteps',
  props: {
    step: {
      type: Number,
      default: 1
    }
  },
  data () {
    return {
      titleList: [{
        code: 1,
        title: '选择合同类型'
      }, {
        code: 2,
        title: '选择签署方式填写对应内容'
      }, {
        code: 3,
        title: '生成合同去签署选择印章'
      }, {
        code: 4,
        title: '短信验证码确认签署'
      }, {
        code: 5,
        title: '完成签署'
      }],
    }
  }
}
</script>

<style scoped>
  .step-block {
    display: flex;
  }

  .number-icon {
    display: flex;
    justify-content: center;
    align-items: center;
    border: 1px solid #DCDFE6;
    width: 25px;
    height: 25px;
    border-radius: 50%;
    margin-right: 5px;
    color: #303133;
  }

  .step-title {
    margin: 0px;
    display: flex;
    align-items: center;
  }
</style>