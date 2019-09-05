<template>
  <div class="uniquecode-form-body">
    <el-row class="form-row" type="flex" justify="center" :gutter=15 >
      <el-col :span="3" >
        <el-button type="info" style="width: 120px" disabled >个人姓名</el-button>
      </el-col>
      <el-col :span="12">
        <el-input size="small" v-model="username" placeholder="个人姓名" />
      </el-col>
    </el-row>
    <el-row class="form-row" type="flex" justify="center" :gutter=15 >
      <el-col :span="3" >
        <el-button style="width: 120px" type="info" disabled >操作人身份证号</el-button>
      </el-col>
      <el-col :span="12">
        <el-input size="small" v-model="idCardNum" placeholder="操作人身份证号" />
      </el-col>
    </el-row>
    <el-row class="seal_custom-row" type="flex" justify="center" align="middle">
      <el-button style="margin-top: 10px;width: 400px" size="mini" type="warning" @click="onSave" >提交认证</el-button>
    </el-row>
  </div>
</template>

<script>
  import http from '@/common/js/http';
  export default {
    name: 'AuthenticationPersonalFrom',
    components: {

    },
    mixins: [],
    computed: {

    },
    methods: {
      async onSave(){
        if(this.idCardNum == null || this.idCardNum == ''){
          this.$message.error('身份证号不能为空');
          return;
        }else if(this.username == null || this.username == ''){
          this.$message.error('名字不能为空');
          return;
        }else{
          const url = this.apis().personalAuthentication();
          const tempData = {
            username: this.username,
            idCardNum: this.idCardNum,
          };
          let formData = Object.assign({}, tempData);
          const result = await http.post(url, formData);
          console.log(result);
          // this.$message.success(result.msg);
          if(result.data !=  null){
            window.open(result.data, '_blank');
          }else{
            this.$message.success(result.msg);
          }
        }

      }
    },
    data() {
      return {
        username: '',
        idCardNum: '',
      }
    },
    created() {

    },
    mounted() {}

  }

</script>
<style>
  .form-row{
    margin-top: 10px;
  }
  .uniquecode-form-body {
    width: 100%;
  }

  .uniquecode-form-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .uniquecode-form-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .uniquecode-form-title-row {
    margin-bottom: 20px;
  }

  .uniquecode-form-order {
    background-color: rgba(0, 0, 0, 0.02);
    padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    padding-right: 10px;
    margin-top: 20px;
  }

  .uniquecode-form-text {
    font-size: 12px;
    color: rgba(51, 48, 48, 0.65);
  }

  .uniquecode-form-btn {
    background: #FFD60C;
    color: rgba(0, 0, 0, 0.85);
    width: 200px;
    margin-top: 20px;
  }

</style>
