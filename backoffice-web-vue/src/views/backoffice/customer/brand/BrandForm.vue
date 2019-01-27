<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>账号</span>
      </div>
      <brand-account-form ref="accountForm"
                          :slot-data="slotData"
                          :is-newly-created="isNewlyCreated">
      </brand-account-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <brand-base-form ref="baseForm"
                       :slot-data="slotData"
                       :is-newly-created="isNewlyCreated">
      </brand-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>认证信息</span>
      </div>
      <brand-certificate-form ref="certificateForm"
      :slot-data="slotData"
      :is-newly-created="isNewlyCreated">
      </brand-certificate-form>
    </el-card>

    <el-row :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" size="mini" type="primary"
                   @click="onSubmit">
          确定
        </el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" size="mini" @click="onCancel">取消</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import axios from "axios";

  import BrandBaseForm from "./BrandBaseForm";
  import BrandAccountForm from "./BrandAccountForm";
  import BrandCertificateForm from "./BrandCertificateForm";

  export default {
    name: "BrandForm",
    components: {BrandAccountForm, BrandBaseForm, BrandCertificateForm},
    props: ["slotData"],
    methods: {
      onSubmit() {
        const accountForm = this.$refs["accountForm"];
        accountForm.validate(valid => {
          if (!valid) {
            return false;
          }

          const baseForm = this.$refs["baseForm"];
          baseForm.validate(valid => {
            if (!valid) {
              return false;
            }

            //const certificateForm = this.$refs["certificateForm"];

            let request = axios.post;
            if (!this.isNewlyCreated) {
              request = axios.put;
            }

            request("/djbrand/brand", accountForm.getValue())
              .then(response => {
                this.$message.success("创建成功，请在待审核页面查看");

                this.$set(this.slotData,"uid",response.data.uid);

                console.log(this.slotData);

                this.$refs.certificateForm.onSubmit();

                // 刷新主体数据
                this.fn.closeSlider(true);
              }).catch(error => {
                this.$message.error(error.response.data);
              }
            );
            return true;
          });

          return true;
        });
      },
      onCancel() {
        this.fn.closeSlider();
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    watch: {
      "$store.state.sideSliderState": function (value) {
        if (!value) {
          this.onSearch();
        }
      }
    },
    data() {
      return {

      };
    }
  };
</script>
