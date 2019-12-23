<template>
  <div>
    <el-row type="flex" justify="center" class="dialog-row">
      <h6>您的账号尚未完成认证，为了增加您账号的可信度，请您先完成认证</h6>
    </el-row>
    <el-row type="flex" justify="space-around" class="dialog-row">
      <el-button class="info-cancel" @click="onCancel">
        取消
      </el-button>
      <el-button class="info-confirm" @click="onConfirm">
        立即认证
      </el-button>
    </el-row>
  </div>
</template>
<script>
  export default {
    name: "AuthenticationDialog",
    data() {
      return {};
    },
    methods: {
      onCancel() {
        this.$emit("onCancel");
      },
      onConfirm() {
        this.$router.push("/account/Authentication");
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
