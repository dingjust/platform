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
            <el-radio-group @change="selectedRole" v-model="sealRole" size="mini">
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
            <el-button size="mini" type="primary" @click="doSomething">保存印章</el-button>
          </el-row>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  import CDS from "./utils/canvasdrawseal.js";
  import http from '@/common/js/http';
  const {mapActions} = createNamespacedHelpers('ContractSealModule');

  export default {
    name: "SealManagement",
    data() {
      return {
        sealUrl: "",
        sealRole: "",
        sealShape: "",
        sealBorder: "",
        sealName: '',
        sealType: "",
        sealRemarks: "",
        currentUser: this.$store.getters.currentUser,
        imgFile:'',
      };
    },
    mounted() {
      this.sealUrl = CDS.companySeal(
        "XXXXXX有限公司",
        0,
        0,
        "横向文",
        "下弦文"
      );
    },
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
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
        this.imgFile = dataURLtoFile(this.sealUrl);
        // console.log(imgFile);
        // this.onUpload(imgFile);
      },
      doSomething(){
        this.onUpload(this.imgFile);
      },
      //上传
      async onUpload(file) {
        if(file != null){
          var fd=new FormData();
          fd.append('file',file);
          const result = await this.$http.formdataPost(this.mediaUploadUrl,fd);
          console.log(result);
          if(result != null){
            this.saveSeal(result);
          }
        }
      },
      selectedRole(){
        if(this.sealRole == 'sealRole0'){
          this.sealName = this.currentUser.companyName;
        }
        if(this.sealRole == 'sealRole1'){
          this.sealName = this.currentUser.username;
        }

        console.log(this.currentUser);
      },
      async saveSeal(item){
        const url = this.apis().saveSeal();
        const tempData = {
          name: this.sealName,
          media: item,
        };
        let formData = Object.assign({}, tempData);
        console.log(formData);
        const result = await http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success(result.msg);
        this.refresh();
        this.fn.closeSlider(true);
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
