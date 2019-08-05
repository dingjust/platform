<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <el-row :gutter="20">
        <el-col :span="8">
          <img :src="sealUrl" />
        </el-col>
        <el-col :span="8">
          <el-row class="seal_custom-row">
            <span>角色：</span>
            <el-radio-group v-model="sealRole" size="mini">
              <el-radio-button label="sealRole0">公司</el-radio-button>
              <el-radio-button label="sealRole1">个人</el-radio-button>
            </el-radio-group>
          </el-row>
          <el-row class="seal_custom-row">
            <span>形状：</span>
            <el-radio-group v-model="sealShape" size="mini">
              <el-radio-button :disabled="sealRole == 'sealRole1'" label="sealShape0">圆形</el-radio-button>
              <el-radio-button :disabled="sealRole == 'sealRole1'" label="sealShape1">椭圆</el-radio-button>
              <el-radio-button :disabled="sealRole == 'sealRole0'" label="sealShape2">长方形</el-radio-button>
              <el-radio-button :disabled="sealRole == 'sealRole0'" label="sealShape3">正方形</el-radio-button>
            </el-radio-group>
          </el-row>
          <el-row class="seal_custom-row">
            <span>边框：</span>
            <el-radio-group :disabled="sealRole == 'sealRole0'" v-model="sealBorder" size="mini">
              <el-radio-button label="sealBorder0">有</el-radio-button>
              <el-radio-button label="sealBorder1">无</el-radio-button>
            </el-radio-group>
          </el-row>
          <el-row class="seal_custom-row" type="flex" align="middle">
            <el-col :span="3">
              <span>名称：</span>
            </el-col>
            <el-col :span="21">
              <el-input size="mini" disabled placeholder="请输入名称" v-model="sealName"></el-input>
            </el-col>
          </el-row>
          <el-row class="seal_custom-row" type="flex" align="middle">
            <el-col :span="4">
              <span>横向文：</span>
            </el-col>
            <el-col :span="20">
              <el-input :disabled="sealRole == 'sealRole1'" size="mini" placeholder="请输入横向文" v-model="sealType">
              </el-input>
            </el-col>
          </el-row>
          <el-row class="seal_custom-row" type="flex" align="middle">
            <el-col :span="4">
              <span>下弦文：</span>
            </el-col>
            <el-col :span="20">
              <el-input :disabled="sealRole == 'sealRole1'" size="mini" placeholder="请输入下弦文" v-model="sealRemarks">
              </el-input>
            </el-col>
          </el-row>
          <el-row class="seal_custom-row" type="flex" justify="center" align="middle">
            <el-button size="mini" type="success" @click="createSeal">生成印章</el-button>
          </el-row>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import CDS from "./utils/canvasdrawseal.js";
  export default {
    name: "SealManagement",
    data() {
      return {
        sealUrl: "",
        sealRole: "",
        sealShape: "",
        sealBorder: "",
        sealName: "宁波衣加衣供应链有限公司",
        sealType: "",
        sealRemarks: ""
      };
    },
    mounted() {
      console.log(CDS.colors[1]);
      this.sealUrl = CDS.companySeal(
        "宁波衣加衣供应链有限公司",
        0,
        0,
        "横向文",
        "下弦文"
      );
    },
    methods: {
      createSeal() {
        if (this.sealRole == "sealRole0") {
          if (this.sealShape == "sealShape0") {
            this.sealUrl = CDS.companySeal(
              this.sealName,
              0,
              0,
              this.sealType,
              this.sealRemarks
            );
          } else if (this.sealShape == "sealShape1") {
            this.sealUrl = CDS.companyEllipse(
              this.sealName,
              this.sealRemarks,
              0,
              0,
              this.sealType
            );
          }
        } else if (this.sealRole == "sealRole1") {
          let shape = this.sealShape == "sealShape2" ? 0 : 1,
            border = this.sealBorder == "sealBorder0" ? 0 : 1;
          this.sealUrl = CDS.personal(this.sealName, 0, 0, shape, border);
        }
      }
    }
  };

</script>

<style lang="scss" scoped>
  .seal_custom-row {
    text-align: left;
    margin: 10px 0;
  }

</style>
