<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <div class="animated fadeIn">
        <el-form ref="form" :model="formData" :inline="true" hide-required-asterisk label-position="left">
          <div class="payPlan-info-order-body">
            <el-row class="payPlan-info-title-row">
              <div class="payPlan-info-title">
                <h6 class="payPlan-info-title_text">添加新方案</h6>
              </div>
            </el-row>

            <el-row class="payPlan-info-order-row" type="flex" justify="start" align="top">
              <el-form-item prop="name" :rules="[{ required: true, message: '请填写财务方案名称', trigger: 'blur'}]" label-width="65px">
                <template slot="label">
                  <h6 class="payPlan-info-input-prepend" style="width: ">方案名称</h6>
                </template>
                <el-input placeholder="请输入方案名称" v-model="formData.name">
                </el-input>
              </el-form-item>
            </el-row>
            <el-row class="payPlan-info-order-row" type="flex" justify="start" align="top">
            <h6 class="payPlan-info-input-prepend" >备注</h6>
            <el-input type="textarea" :rows="3" placeholder="请输入备注留言..." v-model="formData.remarks">
            </el-input>
          </el-row>

            <pay-plan-form :formData="formData"></pay-plan-form>

            <el-row type="flex" justify="center" class="payPlan-info-order-row">
              <el-button class="payPlan-info-order-submit" @click="onSubmit()">确认创建</el-button>
            </el-row>
          </div>
        </el-form>
      </div>
    </el-card>
  </div>


</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  const {mapGetters, mapMutations} = createNamespacedHelpers('PayPlanModule');
  import PayPlanForm from '../../../../components/custom/PayPlanForm';

  export default {
    name: 'PayPlanFormPage',
    props: [],
    components: {PayPlanForm},
    computed: {
      ...mapGetters({
        formData: 'formData'
      })
    },
    methods: {
      ...mapMutations({
        setFormData: 'setFormData'
      }),
      onSubmit () {
        this.$refs.form.validate((valid) => {
          if (valid) {
            this._onSubmit();
          } else {
            this.$message.error('请完善表单信息！');
            return false;
          }
        });
      },
      async _onSubmit () {
        if (this.formData.name.trim() === '') {
          this.$message.error('请输入财务方案名称');
          return;
        }
        this.formData.previewText.replace(/\//g, '/\n');
        // 提交数据
        const url = this.apis().createPayPlan();
        const result = await this.$http.post(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$router.push('/account/setting/payPlan');
        this.$message.success('创建账务方案成功');
      }
    },
    data () {
      return {
      };
    },
    created () {

    },
    destroyed () {
      this.setFormData({
        id: null,
        name: '',
        payPlanType: 'PHASEONE',
        isHaveDeposit: false,
        remarks: '',
        payPlanItems: []
      });
    }
  };
</script>

<style scoped>
  .payPlan-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
  .payPlan-info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    width: 60px;
    font-weight: bold;
    font-size: 10px;
  }
  .payPlan-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .payPlan-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .payPlan-info-title-row {
    margin-bottom: 20px;
  }
  .payPlan-info-order-row {
    margin-bottom: 20px;
  }

  .payPlan-info-order-body {
    width: 100%;
    /*padding: 10px 60px;*/
  }

  .el-input.is-disabled .el-input__inner {
    cursor: pointer;
    background-color: #fff;
  }

  .payPlan-form-item small.el-form-item {
    margin-bottom: 0px !important;
  }

  .payPlan-form-item .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 0px !important;
  }

  .payPlan-info-order-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
    margin-top: 30px;
  }
</style>
