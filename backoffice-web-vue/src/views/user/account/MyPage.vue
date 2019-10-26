<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
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
                <images-upload class="my-form-upload" :slot-data="form.attachments" :limit="1" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex" justify="center">
            <el-col :span="8">
              <el-form-item label="账号:">
                <el-input v-model="account" :disabled="true"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex" justify="center">
            <el-col :span="8">
              <el-form-item label="名称:">
                <el-input v-model="form.name"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex" justify="center">
            <el-col :span="8">
              <el-form-item label="联系方式:">
                <el-input v-model="form.contact"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex" justify="center">
            <el-col :span="8">
              <el-form-item label="账户密码:">
                <el-button type="text">重置密码</el-button>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex" justify="center">
            <el-col :span="8">
              <el-row type="flex" justify="center">
                <el-form-item>
                  <el-button class="my-form-submit">保存</el-button>
                </el-form-item>
              </el-row>
            </el-col>
          </el-row>
        </div>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import ImagesUpload from "@/components/custom/ImagesUpload";

export default {
  name: "MyPage",
  components: {
    ImagesUpload
  },
  computed: {},
  methods: {},
  data() {
    return {
      form: {
        attachments: [],
        name: "",
        contact: ""
      },
      account: this.$store.getters.currentUser.mobileNumber,
      rules: {
        companyOfSeller: [
          {
            required: true,
            message: "请填写合作商名称",
            trigger: "blur"
          }
        ]
      }
    };
  },
  created() {}
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
