<template>
  <view class="requirement">
    <view class="index">
      <AtList>
        <AtListItem
          :title="order.details.productName"
          :note="'发布于：' + formatDate(order.creationtime)"
        />
        <AtListItem title="品类" :extraText="order.details.category.name" />
        <AtListItem
          title="数量"
          :extraText="order.details.expectedMachiningQuantity + '件'"
        />
        <AtListItem title="期望价格" :extraText="expectPrice" />
        <AtListItem
          title="交货日期"
          :extraText="formatDate(order.details.expectedDeliveryDate)"
        />
      </AtList>
      <AtListItem
        title="加工类型"
        :extraText="machiningType[order.details.machiningType]"
      />
      <AtListItem title="质量等级" :extraText="qualityLevelStrs" />
      <AtListItem title="工厂区域" :extraText="productiveDistricts" />
      <AtListItem
        title="是否开票"
        :extraText="order.details.invoiceNeeded ? '是' : '否'"
      />
      <AtListItem
        title="是否打样"
        :extraText="order.details.proofingNeeded ? '是' : '否'"
      />
      <AtListItem title="有效期限" :extraText="effectiveDays" />
      <AtListItem
        title="订单尺码"
        :extraText="orderSizes[order.details.sizeType]"
      />
      <AtListItem
        title="订单颜色"
        :extraText="orderColors[order.details.colorType]"
      />
      <AtListItem
        title="工厂规模"
        :extraText="populationScale[order.details.populationScale]"
      />
      <AtListItem title="参考图片：" :hasBorder="false" />
      <view class="at-row at-row--wrap at-row__justify--around">
        <view v-for="(item, index) in pictures" :key="index">
          <view class="at-col">
            <el-image
              style="width: 80px; height: 80px"
              :src="item"
              fits="cover"
              :preview-src-list="pictures"
            >
            </el-image>
          </view>
        </view>
      </view>
      <view class="divider" />
      <AtListItem title="备注：" :hasBorder="false" />
      <view class="remarks">{{ order.remarks }}</view>
      <view class="at-row at-row__justify--around bottom">
        <view class="at-col at-col-5">
          <AtButton type="primary" :on-click="call">联系对方 </AtButton>
          <a href="" v-show="false" ref="tels"></a>
        </view>
        <view class="at-col at-col-5">
          <AtButton type="secondary" :on-click="openApp">打开APP</AtButton>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
const IMG_CDN = "https://ht.nbyjy.net";
import Taro from "@tarojs/taro";
// 按需引入, 更小的应用体积
import { AtList, AtListItem, AtButton } from "taro-ui-vue";

import openApp from "../../common/openApp";

import "./requirement.scss";
export default {
  components: {
    AtList,
    AtListItem,
    AtButton,
  },
  computed: {
    //期望价格
    expectPrice: function () {
      return this.order.details.maxExpectedPrice > 0
        ? this.order.details.maxExpectedPrice
        : "面议";
    },
    //品质
    qualityLevelStrs: function () {
      if (this.order.details.salesMarket == null) {
        return "";
      }

      return this.order.details.salesMarket
        .map((e) => this.qualityLevel[e])
        .join("、");
    },
    //工厂区域
    productiveDistricts: function () {
      if (this.order.details.productiveDistricts == null) {
        return "";
      }

      return this.order.details.productiveDistricts
        .map((e) => e.name)
        .join("、");
    },
    //有效期限
    effectiveDays: function () {
      return this.order.details.effectiveDays > 0
        ? this.order.details.effectiveDays.toString() + "天"
        : "长期有效";
    },
    //参考图片
    pictures: function () {
      if (this.order.details.pictures == null) {
        return [];
      }
      return this.order.details.pictures.map((e) => IMG_CDN + e.url);
    },
  },
  data() {
    return {
      machiningType: {
        LIGHT_PROCESSING: "清加工",
        LABOR_AND_MATERIAL: "包工包料",
      },
      qualityLevel: {
        A_CHAIN: "一线品牌",
        REGIONAL_CHAIN: "区域品牌",
        STALL_WHOLESALE: "档口精品",
        ELECTRONIC_COMMERCE_QUALITY: "电商品质",
        WHOLESALE_TRADE: "外贸批发",
        LEVEL01: "二线品牌",
        LEVEL02: "三线品牌",
        LEVEL03: "三线以下",
        LEVEL04: "档口跑量",
        LEVEL05: "电商高品质",
        LEVEL06: "电商跑量",
        LEVEL07: "跨境电商",
      },
      orderSizes: {
        FREE_SIZE: "均码",
        MULTIPLE_SIZE: "多码",
        UNKOWN: "未知",
      },
      orderColors: {
        SINGLE_COLOR: "单色",
        MULTIPLE_COLOR: "多色",
        UNKOWN: "未知",
      },
      populationScale: {
        N01: "50人以下",
        N02: "51~100人",
        N03: "101~200人",
        N04: "200人以上",
        N05: "20人以下",
        N06: "21至35人",
        N07: "36人至50人",
      },
      order: {
        details: {
          category: {
            name: "",
          },
          productName: "",
        },
      },
      url: "https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg",
      srcList: [
        "https://fuss10.elemecdn.com/8/27/f01c15bb73e1ef3793e64e6b7bbccjpeg.jpeg",
        "https://fuss10.elemecdn.com/1/8e/aeffeb4de74e2fde4bd74fc7b4486jpeg.jpeg",
      ],
    };
  },
  methods: {
    async getRequirementInfo() {
      const url = this.$apis.requirementWithoutLogin(this.code);
      try {
        await Taro.request({
          url: url,
          method: "GET",
          success: (res) => {
            this.order = res.data;
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
    formatDate(date) {
      var date = new Date(date);
      var YY = date.getFullYear() + "-";
      var MM =
        (date.getMonth() + 1 < 10
          ? "0" + (date.getMonth() + 1)
          : date.getMonth() + 1) + "-";
      var DD = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
      return YY + MM + DD;
    },
    call() {
      console.log(this.order.details.contactPhone);
      this.$refs.tels.href = "tel://" + this.order.details.contactPhone;
      this.$refs.tels.click();
    },
    openApp() {
      openApp();
    },
  },
  created() {
    this.code = Taro.getCurrentInstance().router.params["code"];
    //获取需求信息
    if (this.code != "" && this.code != null) {
      this.getRequirementInfo();
    }
  },
};
</script>
