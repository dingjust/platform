<template>
  <view class="index">
    <view class="index">
      <view class="head at-row at-row__justify--center">
        <img :src="backgroundImg" />
      </view>
      <view class="foot">
        <AtButton :circle="true" :on-click="openApp" class="open-btn">
          打开钉单
        </AtButton>
      </view>
      <AtToast :is-opened="show" :text="msg" :on-close="handleClose"></AtToast>
    </view>
  </view>
</template>

<script>
// 按需引入, 更小的应用体积
import { AtButton, AtToast, AtNoticebar, AtAvatar } from "taro-ui-vue";

import openApp from "../../common/openApp";
import backgroundImg from "../../assets/images/background.png";

// import "taro-ui-vue/dist/style/components/button.scss";
// import "taro-ui-vue/dist/style/components/toast.scss";
// import "taro-ui-vue/dist/style/components/noticebar.scss";
import "./index.scss";
export default {
  components: {
    AtButton,
    AtToast,
    AtNoticebar,
    AtAvatar,
  },
  data() {
    return {
      backgroundImg: backgroundImg,
      msg: "Hello world!",
      show: false,
    };
  },
  methods: {
    handleClick() {
      this.show = true;
    },
    handleClose() {
      this.show = false;
    },
    openApp() {
      openApp();
    },
  },
  created() {
    this.openApp();
  },
};
</script>
