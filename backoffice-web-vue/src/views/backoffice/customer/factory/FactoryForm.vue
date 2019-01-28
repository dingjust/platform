<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>账号</span>
      </div>
      <factory-account-form ref="accountForm"
                            :slot-data="slotData"
                            :is-newly-created="isNewlyCreated">
      </factory-account-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <factory-base-form ref="baseForm"
                         :slot-data="slotData"
                         :is-newly-created="isNewlyCreated">
      </factory-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>认证信息</span>
      </div>
      <factory-certificate-form ref="certificateForm"
                                :slot-data="slotData"
                                :is-newly-created="isNewlyCreated">
      </factory-certificate-form>
    </el-card>

    <el-row :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" size="mini" type="primary" @click="onSubmit">确定</el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" size="mini" @click="onCancel">取消</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import axios from "axios";
  import Bus from "common/js/bus.js";

  import FactoryBaseForm from "./FactoryBaseForm";
  import FactoryAccountForm from "./FactoryAccountForm";
  import FactoryCertificateForm from "./FactoryCertificateForm";

  export default {
    name: "FactoryForm",
    components: {FactoryCertificateForm, FactoryAccountForm, FactoryBaseForm},
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

            let request = axios.post;
            if (!this.isNewlyCreated) {
              request = axios.put;
            }
            request("/djfactory/factory", accountForm.getValue())
              .then(() => {
                Bus.$emit("refreshVal", "");
                this.$message({
                  type: "success",
                  message: "创建成功，请在待审核页面查看"
                });
                this.fn.closeSlider();
                // 刷新主体数据
              })
              .catch(error => {
                this.$message.error(error.response.data);
              }).finally(() => {
            });
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
    data() {
      return {};
    }
  };
</script>
