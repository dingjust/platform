<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <el-row :gutter="20">
        <el-col :span="8">
          <div class="seal-form_img">
            <img :src="sealUrl" />
          </div>
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
        // console.log(this.sealUrl);
        var imgFile = dataURLtoFile(this.sealUrl);
        console.log(imgFile);
        this.onUpload(imgFile);
      },
      //上传
      async onUpload(file) {
        var fd=new FormData();
        fd.append('file',file);
        const result = await this.$http.post(this.mediaUploadUrl, fd,{},{
          'Content-Type':'multipart/form-data'
        });
        console.log(result);
      }
    }
  };

  function dataURLtoFile(dataurl, filename = 'file') {
    let arr = dataurl.split(',')
    let mime = arr[0].match(/:(.*?);/)[1]
    let suffix = mime.split('/')[1]
    let bstr = atob(arr[1])
    let n = bstr.length
    let u8arr = new Uint8Array(n)
    while (n--) {
      u8arr[n] = bstr.charCodeAt(n)
    }
    return new File([u8arr], `${filename}.${suffix}`, {
      type: mime
    })
  }

</script>

<style lang="scss" scoped>
  .seal_custom-row {
    text-align: left;
    margin: 10px 0;
  }

  .seal-form_img {
    border-right: 1px solid #E6E6E6;
  }

</style>
