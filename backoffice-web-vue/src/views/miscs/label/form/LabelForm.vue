<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <el-button type="primary" v-if="isTenant()&&readOnly" @click="onUpdate">修改</el-button>
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <label-basic-form ref="basicForm"
                           :slot-data="slotData"
                           :read-only="readOnly">
      </label-basic-form>
    </el-card>
    <div class="pt-2"></div>
    <el-dialog title="修改标签名称" width="650px" :visible.sync="this.updateVisible" :before-close="handleClose"
               append-to-body>
      <el-input v-model="slotData.name"></el-input>
      <div slot="footer" class="dialog-footer">
        <el-button @click="this.updateVisible = false">取 消</el-button>
        <el-button type="primary" @click="update()">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import LabelBasicForm from './LabelBasicForm';

  export default {
    name: 'LabelFrom',
    components: {
      LabelBasicForm,
    },
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        return this.$refs['basicForm'].validate(callback);
      },
      onUpdate(){
        this.updateVisible = true;
      },
      async update(){
        if (this.slotData.name=='') {
          this.$message.error('名称不能为空');
          return false;
        }
        const url = this.apis().updateLabel();
        console.log(this.slotData);
        const result = await this.$http.put(url, this.slotData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('更新成功');
        this.updateVisible = false;
      },
      handleClose(done) {
        this.updateVisible = false;
      },
    },
    computed: {},
    data() {
      return {
        updateVisible:false,
      }
    }
  }
</script>
