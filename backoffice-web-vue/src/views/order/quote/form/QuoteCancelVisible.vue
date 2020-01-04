<template>
  <div>
    <el-row type="flex" justify="center" class="dialog-row">
      <h6>你确定要关闭该报价单吗？</h6>
    </el-row>
    <el-row type="flex" justify="center" class="dialog-row">
      <el-select v-model="cannelMsg" placeholder="关闭理由">
        <el-option
          v-for="item in options"
          :key="item.value"
          :label="item.label"
          :value="item.value"
          :disabled="item.disabled">
        </el-option>
      </el-select>
    </el-row>
    <el-row type="flex" justify="space-around" style="margin-top: 70px">
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
    name: 'QuoteCannelVisible',
    data () {
      return {
        cannelMsg: '',
        options: [{
          value: '质量有问题',
          label: '质量有问题'
        },
        {
          value: '数量有问题',
          label: '数量有问题'
        }]
      };
    },
    methods: {
      onCancel () {
        this.$emit('onCancel');
      },
      onConfirm () {
        if (this.cannelMsg === '') {
          this.$message.error('请选择下架原因');
        } else {
          this.$emit('onConfirm', this.cannelMsg);
        }
      }
    }
  };
</script>
<style scoped>
  .dialog-row {
    margin-top: 20px;
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
