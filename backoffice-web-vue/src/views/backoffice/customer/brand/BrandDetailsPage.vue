<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
        <span class="float-right">
          <el-button type="primary" size="mini" @click="onUpdateBrand">编辑</el-button>
        </span>
      </div>
      <brand-base-form :slot-data="slotData" :read-only="true"></brand-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>认证信息</span>
        <span class="float-right">
          <el-button type="primary" size="mini" @click="onUpdateBrandCertificate">编辑</el-button>
        </span>
      </div>
      <brand-certificate-form :slot-data="slotData" :read-only="true" :is-newly-created="false"></brand-certificate-form>
      <el-carousel :interval="4000" type="card" >
        <el-carousel-item v-for="media in slotData.certificate" :key="media.url">
          <img style="width:100%;height: 100%" :src="media.url">
        </el-carousel-item>
      </el-carousel>
    </el-card>
    <div class="pt-2"></div>
    <el-row :gutter="10" v-show="!preview">
      <el-col :span="24">
        <el-button class="btn-block" size="mini" @click="onClose">
          关闭
        </el-button>
      </el-col>
    </el-row>

    <el-dialog title="更新基本信息" width="90%"
               :visible.sync="brandFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <brand-Base-Form ref="BrandBaseForm"
                       :slot-data="slotData"
                       :read-only="false"
                       :is-newly-created="false">
      </brand-Base-Form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="onSubmitBaseForm(slotData)">确 定</el-button>
        <el-button @click="brandFormDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="更新认证信息" width="90%"
               :visible.sync="brandCertificateFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <brand-certificate-form ref="BrandCertificateForm"
                       :slot-data="slotData"
                       :read-only="false"
                       :is-newly-created="true">
      </brand-certificate-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="onSubmitCertificateForm(slotData)">确 定</el-button>
        <el-button @click="brandCertificateFormDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import axios from "axios";
  import BrandBaseForm from "./BrandBaseForm";
  import MembersRequestPage from "./MembersRequestPage";
  import BrandCertificateForm from "./BrandCertificateForm";

  export default {
    name: "BrandDetailsPage",
    props: ["slotData","isNewlyCreated"],
    components: {BrandCertificateForm, BrandBaseForm, MembersRequestPage},
    methods: {
      onUpdateBrand() {
        this.brandFormDialogVisible = true;
      },
      onUpdateBrandCertificate(){
        this.brandCertificateFormDialogVisible = true;
      },
      onSubmitBaseForm(data) {
        const baseForm = this.$refs["BrandBaseForm"];
        console.log(baseForm.getValue());
        console.log(this.slotData);
        axios.put("/djbrand/brand/uploadBase", baseForm.getValue())
          .then(() => {
            // Bus.$emit("refreshVal", "");
            this.$message({
              type: "success",
              message: "保存成功"
            });
            this.fn.closeSlider();
            // 刷新主体数据
          })
          .catch(error => {
            this.$message.error(error.response);
          });
      },
      onSubmitCertificateForm(data) {
        const certificateForm = this.$refs["BrandCertificateForm"];

        axios.put("/djbrand/brand/uploadCertificate", certificateForm.getValue())
          .then(() => {
            // Bus.$emit("refreshVal", "");
            this.$message({
              type: "success",
              message: "保存成功"
            });

            this.$refs.BrandCertificateForm.onSubmit();

            this.fn.closeSlider();
            // 刷新主体数据
          })
          .catch(error => {
            this.$message.error(error.response);
          });
      },
      onClose() {
        this.fn.closeSlider();
      }
    },
    data() {
      return {
        brandFormDialogVisible: false,
        brandCertificateFormDialogVisible:false
      };
    }
  };
</script>
