<template>
  <view class="register">
    <view>
      <view class="at-row at-row__justify--center">
        <view class="at-col at-col-1 at-col--auto">
          <h6>邀请您注册使用钉单</h6>
        </view>
      </view>
      <view class="at-row at-row__justify--center">
        <view class="at-col at-col-1 at-col--auto">
          <AtAvatar
            size="large"
            circle
            :image="user.profilePicture.url"
          ></AtAvatar>
        </view>
      </view>
      <view class="at-row at-row__justify--center">
        <view class="register-company-name">
          <h6>{{ user.name }}</h6>
        </view>
      </view>
      <AtForm>
        <View class="panel">
          <View class="panel_title">选择注册类型</View>
          <View>
            <AtRadio
              :options="typeOptions"
              :value="form.type"
              :onClick="handleRadioChange"
            />
          </View>
        </View>
        <View class="panel">
          <View class="panel_title">基本信息</View>
          <AtInput
            required
            type="phone"
            title="手机号"
            placeholder="请输入手机号"
            :value="form.phone"
            :onChange="(val) => onValChange('phone', val)"
          >
            <div
              :style="{
                color: disable ? '#FF4949' : '',
              }"
              @click="onSendCode"
            >
              {{ showText }}
            </div>
          </AtInput>
          <AtInput
            required
            title="验证码"
            type="text"
            placeholder="输入验证码"
            :value="form.code"
            :onChange="(val) => onValChange('code', val)"
          />
          <AtInput
            required
            type="text"
            title="联系人"
            placeholder="请输入联系人名称"
            :value="form.contactPerson"
            :onChange="(val) => onValChange('contactPerson', val)"
          />
          <AtInput
            required
            type="text"
            title="公司名称"
            placeholder="请输入公司名称"
            :value="form.companyName"
            :onChange="(val) => onValChange('companyName', val)"
          />
          <AtInput
            required
            type="password"
            title="密码"
            :error="form.password.length < 8"
            placeholder="请输入密码"
            :value="form.password"
            :onChange="(val) => onValChange('password', val)"
            :onErrorClick="() => showToast('密码长度不小于8位')"
          />
          <AtInput
            required
            :error="form.password !== form.againPassword"
            type="password"
            title="确认密码"
            placeholder="请再次输入密码"
            :value="form.againPassword"
            :onChange="(val) => onValChange('againPassword', val)"
            :onErrorClick="() => showToast('密码不一致')"
          />
        </View>
        <Protocol />
        <AtButton
          formType="submit"
          class="register-submit-btn"
          :onClick="onSubmit"
          >注册</AtButton
        >
      </AtForm>
    </view>
    <AtToast
      :isOpened="toastState.isOpened"
      :text="toastState.text"
      :duration="toastState.duration"
      :status="toastState.status"
      :hasMask="toastState.hasMask"
      :onClose="handleClose"
    ></AtToast>
    <AtModal :isOpened="modalShow" :onClose="handleModalClose">
      <AtModalHeader>确认注册</AtModalHeader>
      <AtModalContent>
        是否确认注册为<span style="color: red">{{
          form.type == "BRAND" ? "品牌商" : "工厂"
        }}</span
        >?
      </AtModalContent>
      <AtModalAction>
        <Button @click="handleModalClose">取消</Button>
        <Button @click="submitForm">确定</Button>
      </AtModalAction>
    </AtModal>
    <AtMessage />
  </view>
</template>

<script>
import Taro from "@tarojs/taro";
// 按需引入, 更小的应用体积
import {
  AtForm,
  AtInput,
  AtButton,
  AtRadio,
  AtAvatar,
  AtModal,
  AtModalHeader,
  AtModalContent,
  AtModalAction,
  AtMessage,
  AtToast,
} from "taro-ui-vue";

import Protocol from "./protocol";

import "./register.scss";
export default {
  name: "Register",
  components: {
    AtForm,
    AtInput,
    AtButton,
    AtRadio,
    AtAvatar,
    AtModal,
    AtModalHeader,
    AtModalContent,
    AtModalAction,
    Protocol,
    AtMessage,
    AtToast,
  },
  computed: {
    showText: function () {
      return this.disable ? this.sencond + "s" : "发送验证码";
    },
  },
  data() {
    return {
      code: "",
      user: {
        name: "",
        profilePicture: {
          url: "http://cdn-oss.nbyjy.net/logo.jpg",
        },
      },
      form: {
        type: "BRAND",
        phone: "",
        code: "",
        password: "",
        againPassword: "",
        companyName: "",
        contactPerson: "",
      },
      disable: false,
      sencond: 60,
      typeOptions: [
        {
          label: "品牌商",
          value: "BRAND",
          desc:
            "服装品牌商、贴牌贸易商、设计工作室、批发档口、电商网红等，需要在钉单APP寻找优质工厂或者服装款式服务的企业或个人，选择“品牌商”注册。",
        },
        {
          label: "工厂",
          value: "FACTORY",
          desc:
            "服装生产工厂，需要在钉单APP上寻找各类服装加工订单，管理生产进度的企业选择“工厂”注册。",
        },
      ],
      toastState: {
        text: "",
        duration: 3000,
        status: "",
        isOpened: false,
        hasMask: false,
      },
      toastShow: false,
      modalShow: false,
    };
  },
  methods: {
    async getRecommedInfo() {
      const url = this.$apis.recommendCodeInfo(this.code);
      try {
        await Taro.request({
          url: url,
          method: "GET",
          success: (res) => {
            this.user = res.data.data;
          },
          fail: (res) => {
            console.log(res);
          },
        });
      } catch (e) {
        console.log(e);
      } finally {
        return false;
      }
    },
    onSendCode() {
      if (this.form.phone.length < 11) {
        this.showToast("请输入正确手机号码");
      } else {
        this.sendCode();
      }
    },
    async sendCode() {
      if (!this.disable) {
        const url = this.$apis.sendCaptcha(this.form.phone);
        const res = await Taro.request({
          url: url,
          method: "GET",
          responseType: "text",
          dataType: "其他",
          success: (res) => {
            this.disable = true;
            const timer = setInterval(() => {
              if (this.sencond > 0) {
                this.$set(this, "sencond", this.sencond - 1);
              } else {
                this.disable = false;
                this.$set(this, "sencond", 60);
                clearInterval(timer);
              }
            }, 1000);
          },
        });
      }
    },
    onValChange(key, val) {
      this.$set(this.form, key, val);
    },
    handleRadioChange(val) {
      this.$set(this.form, "type", val);
    },
    validateForm() {
      if (
        this.form.phone.length == 11 &&
        this.form.code != "" &&
        this.form.password != "" &&
        this.form.password == this.form.againPassword &&
        this.form.companyName != "" &&
        this.form.contactPerson != ""
      ) {
        return true;
      } else {
        this.showToast("请完善基本信息");
        return false;
      }
    },
    onSubmit() {
      // if (this.validateForm()) {
      this.modalShow = true;
      // }
    },
    async submitForm() {
      this.modalShow = false;
      this.showLoading();
      let form = {
        mobileNumber: this.form.phone,
        password: this.form.password,
        name: this.form.companyName,
        contactPerson: this.form.contactPerson,
        contactPhone: this.form.phone,
        captchaCode: this.form.code,
        recommendCode: this.code,
      };
      const url = this.$apis.fastRegister(this.form.type);
      try {
        const res = await Taro.request({
          url: url,
          method: "POST",
          data: form,
          dataType: "其他",
          success: (res) => {
            Taro.navigateTo({
              url: "/pages/index/index",
            });
          },
          fail: (res) => {
            Taro.atMessage({
              message: "注册失败",
              type: "error",
            });
          },
        });
      } finally {
        this.handleClose();
      }
    },
    showToast(val) {
      this.toastState = {
        text: val,
        duration: 3000,
        status: "",
        isOpened: true,
        hasMask: false,
      };
    },
    showLoading() {
      this.toastState = {
        text: "",
        duration: 0,
        status: "loading",
        isOpened: true,
        hasMask: true,
      };
    },
    handleClose() {
      this.toastState = {
        text: "",
        duration: 3000,
        status: "",
        isOpened: false,
        hasMask: false,
      };
    },
    handleModalClose() {
      console.log("asdadadsad");
      this.modalShow = false;
    },
  },
  created() {
    this.code = Taro.getCurrentInstance().router.params["code"];
    //获取邀请信息
    if (this.code != "" && this.code != null) {
      this.getRecommedInfo();
    }
  },
};
</script>
