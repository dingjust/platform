<template>
  <div class="uniquecode-form-body">
    <el-form ref="form" label-position="top" :model="personalSlotData" :rules="rules" :disabled="readOnly">
      <el-row type="flex" justify="center" :gutter=15>
        <el-col :span="3">
          <h6 class="personal-form-title">个人信息</h6>
        </el-col>
        <el-col :span="12" />
      </el-row>
      <el-row class="form-row" type="flex" justify="center" :gutter=15>
        <el-col :span="3">
          <el-button type="info" style="width: 120px" disabled>个人姓名</el-button>
        </el-col>
        <el-col :span="12">
          <el-input size="small" v-model="personalSlotData.username" placeholder="个人姓名(与身份证一致)" />
        </el-col>
      </el-row>
      <el-row class="form-row" type="flex" justify="center" :gutter=15>
        <el-col :span="3">
          <el-button style="width: 120px" type="info" disabled>操作人身份证号</el-button>
        </el-col>
        <el-col :span="12">
          <el-input size="small" v-model="personalSlotData.idCardNum" placeholder="操作人身份证号" />
        </el-col>
      </el-row>
      <el-row class="seal_custom-row" type="flex" justify="center" align="middle">
        <Authorized :permission="['CERT_APPLY']">
          <el-button v-if="personalState == 'UNCERTIFIED'" class="form-submit_btn submit" round size="mini"
            @click="onSave">
            提交认证</el-button>
        </Authorized>
      </el-row>
    </el-form>
    <el-row class="seal_custom-row" type="flex" justify="center" align="middle">
      <Authorized :permission="['CERT_APPLY']">
        <el-button v-if="personalState == 'CHECK'" class="form-submit_btn" size="mini" type="warning" @click="onSave">
          继续认证</el-button>
      </Authorized>
      <Authorized :permission="['CERT_APPLY']">
        <el-button v-if="personalState == 'FAIL'" class="form-submit_btn" size="mini" type="danger" round
          @click="onSave">
          重新认证</el-button>
      </Authorized>
    </el-row>
    <el-dialog :visible.sync="dialogVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <el-row type="flex" justify="center" style="margin-bottom:30px">
        <h6>再次确认</h6>
      </el-row>
      <el-row type="flex" class="confirm-row">
        <el-col :span="12" :offset="8">
          <h6>个人名称：{{personalSlotData.username}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" class="confirm-row">
        <el-col :span="12" :offset="8">
          <h6>信用代码：{{personalSlotData.idCardNum}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="space-around" style="margin-top:30px">
        <el-button class="auth-confirm-btn" round @click="dialogVisible=false">取消</el-button>
        <el-button class="auth-confirm-btn submit" round @click="_onSave">确认</el-button>
      </el-row>
    </el-dialog>
  </div>
</template>

<script>
  import http from '@/common/js/http';
  export default {
    name: 'AuthenticationPersonalFrom',
    props: ['personalSlotData', 'personalReadOnly', 'personalState'],
    components: {

    },
    mixins: [],
    computed: {

    },
    methods: {
      async onSave() {
        if (this.personalSlotData.username == null || this.personalSlotData.username == '') {
          this.$message.error('请填写个人姓名');
          return;
        } else if (this.personalSlotData.idCardNum == null || this.personalSlotData.idCardNum == '') {
          this.$message.error('请填写身份证号码');
          return;
        } else {
          this.dialogVisible = true;
        }

      },
      async _onSave() {
        this.dialogVisible = false;
        const url = this.apis().personalAuthentication();
        const tempData = {
          username: this.personalSlotData.username,
          idCardNum: this.personalSlotData.idCardNum,
        };
        let formData = Object.assign({}, tempData);
        const result = await http.post(url, formData);
        console.log(result);
        // this.$message.success(result.msg);
        if (result.data != null) {
          window.open(result.data, '_blank');
        } else {
          this.$message.success(result.msg);
        }
      },
      reAuthentication() {
        this.readOnly = false;
        this.isReAuthentication = true;
      }
    },
    data() {
      return {
        dialogVisible: false,
        rules: {
          username: [{
            required: true,
            message: '必填',
            trigger: 'blur'
          }],
          idCardNum: [{
            required: true,
            message: '必填',
            trigger: 'blur'
          }],
        },
        readOnly: false,
        isReAuthentication: false,
      }
    },
    created() {
      this.readOnly = this.personalReadOnly
    },
    mounted() {}

  }

</script>
<style>
  .form-row {
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

  .personal-form-title {
    font-size: 10px;
    color: #c8c9cc;
  }

  .form-submit_btn {
    margin-top: 10px;
    width: 400px;
    height: 40px;
  }

  .auth-confirm-btn {
    width: 150px;
    height: 40px;
  }

  .submit {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }


  .confirm-row {
    margin-bottom: 10px;
  }

</style>
