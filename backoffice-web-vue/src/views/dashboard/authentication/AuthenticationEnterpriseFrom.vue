<template>
  <div class="uniquecode-form-body">
    <el-form ref="form" label-position="top" :model="enterpriseSlotData" :rules="rules" :disabled="enterpriseReadOnly">
      <el-row type="flex" justify="center" :gutter=15>
        <el-col :span="3">
          <h6 class="enterprise-form-title">企业信息</h6>
        </el-col>
        <el-col :span="12" />
      </el-row>
      <el-row class="form-row" type="flex" justify="center" :gutter=15>
        <el-col :span="3">
          <el-button type="info" style="width: 120px" disabled>企业名称</el-button>
        </el-col>
        <el-col :span="12">
          <el-input size="small" v-model="enterpriseSlotData.companyName" placeholder="企业名称" />
        </el-col>
      </el-row>
      <el-row class="form-row" type="flex" justify="center" :gutter=15>
        <el-col :span="3">
          <el-button style="width: 120px" type="info" disabled>信用代码</el-button>
        </el-col>
        <el-col :span="12">
          <el-input size="small" v-model="enterpriseSlotData.organization" placeholder="信用代码" />
        </el-col>
      </el-row>
      <el-row class="form-row" type="flex" justify="center" :gutter=15>
        <el-col :span="3">
          <el-button type="info" style="width: 120px" disabled>法定代表人</el-button>
        </el-col>
        <el-col :span="12">
          <el-input size="small" v-model="enterpriseSlotData.username" placeholder="姓名(与身份证一致)" />
        </el-col>
      </el-row>
      <el-row class="seal_custom-row" type="flex" justify="center" align="middle">
        <Authorized :permission="['CERT_APPLY']">
          <el-button v-if="companyState == 'UNCERTIFIED'" class="form-submit_btn submit" size="mini" round @click="onSave">提交认证
          </el-button>
        </Authorized>
      </el-row>
    </el-form>
    <el-row class="seal_custom-row" type="flex" justify="center" align="middle">
      <Authorized :permission="['CERT_APPLY']">
        <el-button v-if="companyState == 'CHECK'" class="form-submit_btn" size="mini" type="warning" round
          @click="onSave">继续认证</el-button>
      </Authorized>
      <Authorized :permission="['CERT_APPLY']">
        <el-button v-if="reverificationShow" class="form-submit_btn" size="mini" type="danger" round @click="onSave">
          重新认证</el-button>
      </Authorized>
    </el-row>
    <a id="a" href="" target="_blank"></a>
    <el-dialog :visible.sync="dialogVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <el-row type="flex" justify="center" style="margin-bottom:30px">
        <h6>再次确认</h6>
      </el-row>
      <el-row type="flex" class="confirm-row">
        <el-col :span="12" :offset="8">
          <h6>企业名称：{{enterpriseSlotData.companyName}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" class="confirm-row">
        <el-col :span="12" :offset="8">
          <h6>信用代码：{{enterpriseSlotData.organization}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" class="confirm-row">
        <el-col :span="12" :offset="8">
          <h6>法定代表人：{{enterpriseSlotData.username}}</h6>
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
    name: 'AuthenticationEnterpriseFrom',
    props: ['enterpriseSlotData', 'enterpriseReadOnly', 'companyState'],
    components: {

    },
    mixins: [],
    computed: {
      reverificationShow: function () {
        return (this.companyState == 'SUCCESS' || this.companyState == 'FAILED');
      }
    },
    methods: {
      async onSave() {
        if (this.enterpriseSlotData.companyName == null || this.enterpriseSlotData.companyName == '') {
          this.$message.error('请填写企业名称');
        } else if (this.enterpriseSlotData.organization == null || this.enterpriseSlotData.organization == '') {
          this.$message.error('请填写税号');
        } else if (this.enterpriseSlotData.username == null || this.enterpriseSlotData.username == '') {
          this.$message.error('请填写办理人姓名');
        } else {
          this.dialogVisible = true;
        }
      },
      async _onSave() {
        this.dialogVisible=false;
        const url = this.apis().enterpriseAuthentication();
        const tempData = {
          companyName: this.enterpriseSlotData.companyName,
          organization: this.enterpriseSlotData.organization,
          username: this.enterpriseSlotData.username,
          verifyWay: 'WAY1',
          companyType: 'TYPE1'
        };
        let formData = Object.assign({}, tempData);
        const result = await http.post(url, formData);
        if (result.data != null) {
          // this.$confirm('是否跳转到认证页面？', '', {
          //   confirmButtonText: '是',
          //   cancelButtonText: '否',
          //   type: 'warning'
          // }).then(() => {
            window.open(result.data);
          // });
        } else {
          this.$message.success(result.msg);
        }
      }
    },
    data() {
      return {
        dialogVisible: false,
        rules: {
          companyName: [{
            required: true,
            message: '必填',
            trigger: 'blur'
          }],
          username: [{
            required: true,
            message: '必填',
            trigger: 'blur'
          }],
          organization: [{
            required: true,
            message: '必填',
            trigger: 'blur'
          }]
        },
      }
    },
    created() {},
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

  .enterprise-form-title {
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
