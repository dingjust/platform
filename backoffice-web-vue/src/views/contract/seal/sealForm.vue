<template>
  <div>
    <!-- <el-card class="box-card"> -->
      <el-row type="flex" justify="center" align="middle" style="margin-bottom: 20px">
        <h6 style="font-size: 16px">新建印章</h6>
      </el-row>
      <el-form ref="form" :model="formData" :hide-required-asterisk="true">
        <el-row :gutter="20">
          <el-col :span="8" class="seal-form_img">
            <div>
              <img :src="sealUrl" />
            </div>
          </el-col>
          <el-col :span="16" style="border-left: 1px solid #E6E6E6;">
            <el-row type="flex" align="middle">
              <el-form-item style="width: 100%" prop="name" :rules="[{required: true, message: '请填写印章名称', trigger: 'change'}]">
                <el-input placeholder="请输入名称" v-model="formData.name">
                  <template slot="prepend">
                    <span>印章名称<span style="color: #F56C6C">*</span></span>
                  </template>
                </el-input>
              </el-form-item>
            </el-row>
            <!--<el-row class="seal_custom-row">-->
            <!--<span>角色：</span>-->
            <!--<el-radio-group @change="selectedRole" v-model="sealRole" :disabled="true" size="mini">-->
            <!--<el-radio-button label="sealRole0">公司</el-radio-button>-->
            <!--<el-radio-button label="sealRole1">个人</el-radio-button>-->
            <!--</el-radio-group>-->
            <!--</el-row>-->
            <!-- <el-row class="seal_custom-row">
              <span>形状：</span>
              <el-radio-group @change="createSeal" v-model="sealShape" size="mini">
                <el-radio-button :disabled="sealRole == 'sealRole1'" label="sealShape0">圆形</el-radio-button>
                <el-radio-button :disabled="sealRole == 'sealRole1'" label="sealShape1">椭圆</el-radio-button>
                <el-radio-button :disabled="sealRole == 'sealRole0'" label="sealShape2">长方形</el-radio-button>
                <el-radio-button :disabled="sealRole == 'sealRole0'" label="sealShape3">正方形</el-radio-button>
              </el-radio-group>
            </el-row> -->
            <!-- <el-row class="seal_custom-row">
              <span>边框：</span>
              <el-radio-group @change="createSeal" :disabled="sealRole == 'sealRole0'" v-model="sealBorder" size="mini">
                <el-radio-button label="sealBorder0">有</el-radio-button>
                <el-radio-button label="sealBorder1">无</el-radio-button>
              </el-radio-group>
            </el-row> -->
            <el-row type="flex" align="middle">
              <el-form-item style="width: 100%">
                <el-input @input="createSeal" :disabled="sealRole == 'sealRole1'" placeholder="请输入横向文" v-model="sealType">
                  <template slot="prepend">
                    <span>横向文</span>
                  </template>
                </el-input>
              </el-form-item>
            </el-row>
            <el-row type="flex" align="middle">
              <el-form-item style="width: 100%">
                <el-input @input="createSeal" :disabled="sealRole == 'sealRole1'" placeholder="请输入下弦文" v-model="sealRemarks">
                  <template slot="prepend">
                    <span>下弦文</span>
                  </template>
                </el-input>
              </el-form-item>
            </el-row>
            <el-row type="flex" align="middle" justify="start">
              <div style="margin-left: 20px;">
                <h6>印章样式</h6>
              </div>
              <template v-for="item in shapeType">
                <div :key="item.code" class="shape-type-btn" @click="handleChangeShape(item.code)" 
                  :style="isSelect(item.code) ? 'box-shadow: 0px 0px 8px #888888' : ''">
                  <div class="shape-type-btn_inside">
                    <i v-if="isSelect(item.code)" class="el-icon-circle-check select-icon" />
                    <img :src="item.url" style="width: 100px"/>
                  </div>
                </div>
              </template>
            </el-row>
          </el-col>
        </el-row>
        <el-row class="seal-sumbit-row" type="flex" justify="center" align="middle">
          <!--<el-button size="mini" type="success" @click="createSeal">生成印章</el-button>-->
          <el-button class="basic-btn" @click="onCancel">放弃</el-button>
          <el-button class="basic-btn submit-btn" @click="doSomething">保存</el-button>
        </el-row>
      </el-form>
    <!-- </el-card> -->
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import CDS from "./utils/canvasdrawseal.js";
  import http from '@/common/js/http';
  import Bus from '@/common/js/bus.js';
  const {
    mapActions
  } = createNamespacedHelpers('ContractSealModule');

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
        imgFile: '',
        personalState: '',
        companyState: '',
        formData: {
          name: ''
        },
        shapeType: []
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
      this.shapeType.push({
        code: 'sealShape0',
        url: CDS.companySeal(
          "XXXXXX有限公司",
          0,
          0,
          "横向文",
          "下弦文"
        )
      });
      this.shapeType.push({
        code: 'sealShape1',
        url: CDS.companyEllipse(
          "XXXXXX有限公司",
          "下弦文",
          0,
          0,
          "横向文"
        )
      })
    },
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      isSelect (code) {
        return code === this.sealShape;
      },
      handleChangeShape (code) {
        this.sealShape = code;
        this.createSeal();
      },
      onCancel () {
        this.$emit('closeDialog');
      },
      createSeal() {
        if (this.sealRole == "sealRole0") {
          if (this.sealShape == "sealShape0") {
            if (this.sealRemarks == ''||this.sealRemarks.length==1) {
              this.sealUrl = CDS.companySeal(
                this.sealName,
                0,
                0,
                this.sealType,
                this.sealRemarks+'  '
              );
            } else {
              this.sealUrl = CDS.companySeal(
                this.sealName,
                0,
                0,
                this.sealType,
                this.sealRemarks
              );
            }
          } else if (this.sealShape == "sealShape1") {
            if (this.sealRemarks == '') {
              this.sealUrl = CDS.companyEllipse(
                this.sealName,
                '  ',
                0,
                0,
                this.sealType
              );
            } else {
              this.sealUrl = CDS.companyEllipse(
                this.sealName,
                this.sealRemarks,
                0,
                0,
                this.sealType
              );
            }
          }
        } else if (this.sealRole == "sealRole1") {
          let shape = this.sealShape == "sealShape2" ? 0 : 1,
            border = this.sealBorder == "sealBorder0" ? 0 : 1;
          this.sealUrl = CDS.personal(this.sealName, 0, 0, shape, border);
        }
        this.imgFile = dataURLtoFile(this.sealUrl);
        // this.onUpload(imgFile);
      },
      doSomething() {
        this.$refs.form.validate((valid) => {
          if (valid) {
            this.onUpload(this.imgFile);
          } else {
            this.$message.error('请完善表单信息！');
            return false;
          }
        });
      },
      //上传
      async onUpload(file) {
        if (file != null) {
          var fd = new FormData();
          fd.append('file', file);
          const result = await this.$http.formdataPost(this.mediaUploadUrl, fd);
          if (result != null) {
            this.saveSeal(result);
          }
        }
      },
      selectedRole() {
        if (this.sealRole == 'sealRole0') {
          this.sealName = this.currentUser.companyName;
        }
        if (this.sealRole == 'sealRole1') {
          this.sealName = this.currentUser.username;
        }
        this.createSeal();
      },
      async saveSeal(item) {
        const url = this.apis().saveSeal();
        const tempData = {
          name: this.formData.name,
          media: item,
        };
        let formData = Object.assign({}, tempData);
        const result = await http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result.msg);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success(result.msg);
        Bus.$emit('closeFrom');
        this.refresh();
        this.fn.closeSlider(true);
        this.$emit('callback');
      },
      async getAuthenticationState() {
        const url = this.apis().getAuthenticationState();
        const result = await http.get(url);
        this.personalState = result.data.personalState;
        this.companyState = result.data.companyState;
        if (this.personalState != 'UNCERTIFIED' && this.personalState != 'FAILED') {

          this.sealRole = 'sealRole1';
          this.sealName = this.currentUser.username;
          this.sealShape = "sealShape2";
          this.sealBorder = "sealBorder0";
        }
        if (this.companyState != 'UNCERTIFIED' && this.companyState != 'FAILED') {
          this.sealRole = 'sealRole0';
          this.sealName = this.currentUser.companyName;
          this.sealShape = "sealShape0";
        }
        this.createSeal();
      },
    },
    created() {
      this.getAuthenticationState();
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

<style scoped>
  .seal-form-item {
    margin: 0px;
  }

  .seal_custom-row {
    /* // text-align: left; */
    /* // margin: 10px 0; */
  }

  .seal-sumbit-row {
    margin-top: 30px;
  }

  .seal-form_img {
    display: flex;
    justify-content: center;
  }

  /deep/ .el-input-group__prepend {
    width: 100px
  }

  .shape-type-btn {
    margin-left: 30px;
    width: 100px;
    height: 100px;
    display: flex;
    align-items: center;
  }

  .shape-type-btn_inside {
    position: absolute;
    width: 100px;
    height: 100px;
    display: flex;
    align-items: center;
  }

  .shape-type-btn:hover {
    box-shadow: 0px 0px 8px #888888;
  }

  .select-icon {
    position: absolute;
    right: -3px;
    top: -3px;
    font-size: 20px;
  }

  .basic-btn {
    width: 90px;
    border-radius: 5px;
    color: #606266;
    background-color: #fff;
    border: 1px solid #DCDFE6;
  }

  .submit-btn {
    background-color: #ffd60c;
    margin-left: 50px;
  }
</style>
