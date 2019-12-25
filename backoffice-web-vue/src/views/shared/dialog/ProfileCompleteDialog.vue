<template>
  <div>
    <el-row type="flex" justify="center" class="dialog-row">
      <h6>您的公司资料尚未完善，为了方便您更精准的匹配工厂，请您先完善公司资料</h6>
    </el-row>
    <el-row type="flex" justify="space-around" class="dialog-row">
      <el-button class="info-cancel" @click="onCancel">
        取消
      </el-button>
      <el-button class="info-confirm" @click="onConfirm">
        完善资料
      </el-button>
    </el-row>
  </div>
</template>
<script>
  export default {
    name: "ProfileCompleteDialog",
    data() {
      return {};
    },
    methods: {
      onCancel() {
        this.$emit("onCancel");
      },
      onConfirm() {
        this.$router.push("/account/index");
      }
    }
  };

</script>
<style scoped>
  .dialog-row {
    margin-top: 70px;
  }

  .info-cancel {
    color: #000;
    width: 100px;
  }

  .info-confirm {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 100px;
  }

</style>
