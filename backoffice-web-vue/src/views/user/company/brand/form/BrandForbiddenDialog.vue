<template>
  <div>
    <el-row type="flex" justify="center" class="dialog-row">
      <h6>你确定要禁用该账号吗？</h6>
    </el-row>
    <el-row type="flex" justify="space-around" class="dialog-row">
      <el-button class="info-cancel" @click="onCancel">
        取消
      </el-button>
      <el-button class="info-confirm" @click="onConfirm">
        确定
      </el-button>
    </el-row>
  </div>
</template>
<script>
  export default {
    name: 'BrandForbiddenDialog',
    data () {
      return {};
    },
    methods: {
      onCancel () {
        this.$emit('onCancel');
      },
      onConfirm () {
        this.$emit('onConfirm');
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
