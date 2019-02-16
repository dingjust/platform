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
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('FactoriesModule');

  import FactoryBaseForm from "./FactoryBaseForm";
  import FactoryAccountForm from "./FactoryAccountForm";
  import FactoryCertificateForm from "./FactoryCertificateForm";

  export default {
    name: "FactoryForm",
    components: {FactoryCertificateForm, FactoryAccountForm, FactoryBaseForm},
    props: ["slotData"],
    methods: {
      ...mapActions({
        refresh: "refresh"
      }),
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

            this._onSubmit(accountForm.getValue());

            return true;
          });

          return true;
        });
      },
      onCancel() {
        this.fn.closeSlider();
      },
      async _onSubmit(value) {
        let request = this.$http.post;
        if (!this.isNewlyCreated) {
          request = this.$http.put;
        }
        const result = await request("/djfactory/factory", value);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success("创建成功，请在待审核页面查看");
        this.refresh();
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
