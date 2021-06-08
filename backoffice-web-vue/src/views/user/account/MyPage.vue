<template>
  <div class="animated fadeIn content">
    <el-dialog title="修改密码" :visible.sync="dialogVisible" :modal="false" width="30%" :close-on-click-modal="false">
      <change-password-page :username="currentUser.username" :ignore-old-password="false"
        @onChangePassword="doChangePassword" @onCancel="onCancel" />
    </el-dialog>
    <el-card class="box-card">
      <!-- <el-row type="flex" justify="space-between" align="middle"> -->
        <!-- <el-col :span="18"> -->
          <el-form :model="form" :rules="rules" ref="form" label-position="left" label-width="80px">
            <div class="my-form-body">
              <el-row class="my-form-title-row">
                <div class="my-form-title">
                  <h6 class="my-form-title_text">我的</h6>
                </div>
              </el-row>
              <el-row type="flex" justify="center">
                <el-col :span="8">
                  <el-form-item label="头像:">
                    <images-upload class="my-form-upload" :slot-data="attachments" :limit="1" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row type="flex" justify="center">
                <el-col :span="8">
                  <el-form-item label="账号:">
                    <el-input v-model="currentUser.mobileNumber" :disabled="true"></el-input>
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row type="flex" justify="center">
                <el-col :span="8">
                  <el-form-item label="名称:">
                    <el-input v-model="form.name" :disabled="!isMainUser||authenticated"></el-input>
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row type="flex" justify="center">
                <el-col :span="8">
                  <el-form-item label="联系方式:">
                    <el-input v-model="form.contact" :disabled="!isMainUser"></el-input>
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row type="flex" justify="center">
                <el-col :span="8">
                  <el-form-item label="账户密码:">
                    <el-button type="text" @click="onChangePassword">重置密码</el-button>
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row type="flex" justify="center">
                <el-col :span="8">
                  <el-row type="flex" justify="center">
                    <el-form-item>
                      <el-button class="my-form-submit" @click="onSave">保存</el-button>
                    </el-form-item>
                  </el-row>
                </el-col>
              </el-row>
            </div>
          </el-form>
        <!-- </el-col> -->
        <!-- <el-col :span="6">
          <el-button type="primary" @click="onApply">申请代运营服务</el-button>
        </el-col> -->
      <!-- </el-row> -->
    </el-card>
  </div>
</template>

<script>
  import ImagesUpload from "@/components/custom/ImagesUpload";
  import ChangePasswordPage from "@/views/shared/account/password/ChangePasswordPage";

  export default {
    name: "MyPage",
    components: {
      ImagesUpload,
      ChangePasswordPage
    },
    computed: {
      // attachments: function () {
      //   if (this.$store.getters.currentUser.profilePicture != null) {
      //     return [this.$store.getters.currentUser.profilePicture];
      //   } else {
      //     return [];
      //   }
      // },
      //是否主账号
      isMainUser: function () {
        if (this.$store.getters.currentUser.mainUser) {
          return this.$store.getters.currentUser.mainUser;
        } else {
          return false;
        }
      },
      //是否已认证
      authenticated: function () {
        if (this.authenticationInfo == null) {
          return false;
        } else {
          if (
            this.authenticationInfo.companyState != null &&
            this.authenticationInfo.companyState == "SUCCESS"
          ) {
            return true;
          } else if (
            this.authenticationInfo.personalState != null &&
            this.authenticationInfo.personalState == "SUCCESS"
          ) {
            return true;
          } else {
            return false;
          }
        }
      },
    },
    methods: {
      onChangePassword() {
        this.dialogVisible = true;
      },
      onCancel() {
        this.dialogVisible = false;
      },
      async doChangePassword(oldPassword, newPassword) {
        const url = this.apis().changePassword(this.currentUser.uid);
        const result = await this.$http.put(url, null, {
          old: oldPassword,
          new: newPassword
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.dialogVisible = false;

        this.$message.success("密码修改成功");
      },
      async onSave() {
        let form = {
          name: this.form.name,
          contactPhone: this.form.contact,
          profilePicture: this.attachments[0],
        }
        const url = this.apis().updateUserInfo(this.currentUser.uid);
        const result = await this.$http.put(url, form);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        const uid = this.currentUser.uid;
        this.$store.dispatch("getProfile", {
          uid
        });
        this.$message.success("修改成功");
      },
      onApply () {
        this.$confirm('是否申请代运营服务？', '', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          this._onApply();
        });
      },
      async _onApply () {
        const url = this.apis().AgentOperationSubmit();
        const result = await this.$http.post(url, {});

        if (result.code === 1) {
          this.$message.success('操作成功！')
        } else if (result.code === 0) {
          this.$message.error(result.msg);
        } else if (result['errors']) {
          this.$message.error(result['error'][0].message);
        } else {
          this.$message.error("操作失败！");
        }
      }
    },
    data() {
      return {
        form: {
          name: this.$store.getters.currentUser.username,
          contact: this.$store.getters.currentUser.contactPhone
        },
        dialogVisible: false,
        currentUser: this.$store.getters.currentUser,
        authenticationInfo: this.$store.getters.authenticationInfo,
        rules: {
          companyOfSeller: [{
            required: true,
            message: "请填写合作商名称",
            trigger: "blur"
          }]
        },
        attachments: []
      };
    },
    created() {
      if (this.$store.getters.currentUser.profilePicture != null) {
        return this.attachments.push(this.$store.getters.currentUser.profilePicture);
      }
    }
  };

</script>
<style>
  .my-form-title {
    width: 100%;
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
    height: 14px;
  }

  .my-form-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .my-form-title-row {
    margin-bottom: 20px;
  }

  .my-form-body {
    width: 100%;
    /* padding: 10px 60px; */
  }

  /* .my-form-upload {
  margin-left: px;
} */

  .my-form-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .my-form-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .my-form-submit {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 150px;
  }

</style>
