<!--
* @Description: 单独添加颜色尺码
* @Date 2021/03/05 14:33
* @Author L.G.Y
-->
<template>
  <div>
    <el-row type="flex">
      <el-input ref="input" placeholder="请输入名称" v-model="name" @keyup.enter.native="onConfirm">
        <el-select v-model="selectType" slot="prepend" placeholder="请选择" style="width: 100px;">
          <el-option label="颜色" value="color"></el-option>
          <el-option label="尺码" value="size"></el-option>
        </el-select>
      </el-input>
    </el-row>
    <el-row type="flex" justify="end" style="margin-top: 20px">
      <el-button @click="onCancel">取消</el-button>
      <el-button type="primary" @click="onConfirm">确定</el-button>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'ColorSizeAddForm',
  data () {
    return {
      name: '',
      selectType: 'color',
      lock: false
    }
  },
  methods: {
    onCancel () {
      this.$emit('closeDialog');
    },
    onConfirm () {
      if (this.lock) {
        return;
      }
      this.lock = true;
      if (this.name.trim() === '') {
        this.$message.warning('请填写' + (this.selectType === 'color' ? '颜色' : '尺码') + '名称');
        return;
      }
      this.$confirm('是否进行添加操作?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        if (this.selectType === 'color') {
          this.addColor();
        } else if (this.selectType === 'size') {
          this.addSize();
        }
      });
    },
    async addColor () {
      const url = this.apis().addCustomColor();
      const result = await this.$http.post(url, {
        name: this.name
      });

      if (result.code === 1) {
        this.$emit('addColorSize', result.data, this.selectType);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('操作失败，请稍后再试 . . .');
      }

      this.lock = false;
    },
    async addSize () {
      const url = this.apis().addCustomSize();
      const result = await this.$http.post(url, {
        name: this.name
      });

      if (result.code === 1) {
        this.$emit('addColorSize', result.data, this.selectType);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('操作失败，请稍后再试 . . .');
      }

      this.lock = false;
    }
  },
  mounted () {
    this.$nextTick(() => {
      this.$refs.input.focus();
    })
  }
}
</script>

<style scoped>

</style>