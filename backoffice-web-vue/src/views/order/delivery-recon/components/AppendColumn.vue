<template>
  <el-form ref="form" :model="column">
    <el-row>
      <el-form-item label="" prop="value" :rules="[{ required: true, message: '必填', trigger: 'blur'}]" @submit.native.prevent>
        <el-input v-model="column.value" 
                  :placeholder="placeholder" 
                  @keyup.enter.native="onConfirm"></el-input>
      </el-form-item>
    </el-row>
    <el-row type="flex" justify="end" style="margin-top: 20px">
      <el-button @click="onCancel">取消</el-button>
      <el-button type="primary" @click="onConfirm">确定</el-button>
    </el-row>
  </el-form>
</template>

<script>
export default {
  name: 'AppendColumn',
  props: ['modifyColumn'],
  data () {
    return {
      column: {
        code: '',
        value: ''
      },
      placeholder: '请输入新增列名'
    }
  },
  methods: {
    onCancel () {
      this.$emit('callback');
    },
    onConfirm () {
      this.$refs.form.validate(valid => {
        if (valid) {
          if (this.modifyColumn && this.modifyColumn != '') {
            this._onModify();
          } else {
            this._onConfirm();
          }
        }
      })
    },
    _onConfirm () {
      this.$confirm('是否添加 '+ this.column.value +' 作为表单列', '提示', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this.$emit('addColumn', this.column.value);
      });
    },
    _onModify () {
      this.$confirm('是否将 '+ this.column.value +' 作为新表单列名', '提示', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this.$emit('toModifyColumn', this.column);
      });
    },
  },
  created () {
    if (this.modifyColumn && this.modifyColumn != '') {
      this.column = this.modifyColumn;
      this.placeholder = '请输入修改列名'
    }
  }  
}
</script>

<style scoped>

</style>