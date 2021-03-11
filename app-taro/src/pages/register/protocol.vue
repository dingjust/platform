<template>
  <view class="at-row at-row__justify--center register-protocol-row">
    <view class="at-col at-col-10 at-col--wrap at-radio__desc">
      完成注册即视用户同意《<span
        class="protocol"
        @click="onUrl('/pages/protocol/privacy')"
        >钉单隐私政策协议</span
      >》、《<span class="protocol" @click="onUrl('/pages/protocol/service')"
        >钉单平台服务协议</span
      >》与《<span class="protocol" @click="onUrl('/pages/protocol/payment')"
        >钉单平台货款代收代付服务协议</span
      >》
    </view>
  </view>
</template>
<script>
import Taro from "@tarojs/taro";

export default {
  name: "Protocol",
  methods: {
    onUrl(url) {
      Taro.navigateTo({
        url: url,
      });
    },
  },
};
</script>
