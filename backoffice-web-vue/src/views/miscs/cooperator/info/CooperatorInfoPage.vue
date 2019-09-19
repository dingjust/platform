<template>
    <div class="cooperator-info-order-body">
      <el-row type="flex">
        <el-col :span="11">
          <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
            <el-col :span="8">合作商类型</el-col>
            <el-col :span="16">{{getEnum('CooperatorType',itemData.type)}}</el-col>
          </el-row>
          <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
            <el-col :span="8">合作商名称</el-col>
            <el-col :span="16">{{itemData.partner == null ? itemData.name : itemData.partner.name}}</el-col>
          </el-row>
          <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
            <el-col :span="8">联系人</el-col>
            <el-col :span="16">{{itemData.partner == null ? itemData.contactPerson : itemData.partner.contactPerson}}</el-col>
          </el-row>
          <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
            <el-col :span="8">联系方式</el-col>
            <el-col :span="16">{{itemData.partner == null ? itemData.contactPhone : itemData.partner.contactPhone}}</el-col>
          </el-row>
          <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
            <el-col :span="8">身份类型</el-col>
            <el-col :span="16">
              {{getEnum('CooperatorCategory',itemData.category)}}
              <span v-if="itemData.detailedIdentity != null">{{'('}}{{itemData.detailedIdentity}}{{')'}}</span>
            </el-col>
          </el-row>
        </el-col>
        <el-col :span="2">
          <el-divider direction="vertical"></el-divider>
        </el-col>
        <el-col :span="11">
          <div class="grid-content bg-purple-light">
            <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
              <el-col :span="8">开户行</el-col>
              <el-col :span="16">{{itemData.bankOfDeposit}}</el-col>
            </el-row>
            <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
              <el-col :span="8">银行账号</el-col>
              <el-col :span="16">{{itemData.bankAccount}}</el-col>
            </el-row>
            <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
              <el-col :span="8">税号</el-col>
              <el-col :span="16">{{itemData.taxNumber}}</el-col>
            </el-row>
            <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
              <el-col :span="8">绑定账务方案</el-col>
              <el-col :span="16">{{itemData.payPlan != null ? itemData.payPlan.name : ''}}</el-col>
            </el-row>
            <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
              <el-col :span="8">备注</el-col>
              <el-col :span="16">{{itemData.remarks}}</el-col>
            </el-row>
          </div>
        </el-col>
      </el-row>
    </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('CooperatorModule');

  export default {
    name: 'CooperatorInfoPage',
    props: ['itemData'],
    components: {},
    computed: {
      ...mapGetters({
      })
    },
    methods: {
      ...mapActions({
      }),
    },
    data() {
      return {
      };
    },
    created() {

    }
  };
</script>

<style scoped>
  .cooperator-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .cooperator-info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    width: 60px;
    font-weight: bold;
    font-size: 10px;
  }

  .cooperator-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .cooperator-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .cooperator-info-title-row {
    margin-bottom: 20px;
  }

  .cooperator-info-order-row {
    margin-bottom: 20px;
  }

  .cooperator-info-order-body {
    width: 100%;
    /*padding: 10px 60px;*/
    line-height: normal;
  }



  label {
    margin-bottom: 0px !important;
  }

  .el-input.is-disabled .el-input__inner {
    cursor: pointer;
    background-color: #fff;
  }

  .cooperator-form-item small.el-form-item {
    margin-bottom: 0px !important;
  }

  .cooperator-form-item .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 0px !important;
  }

  .cooperator-info-order-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
    margin-top: 30px;
  }

  .el-divider--vertical{
    height: 13em;
  }
</style>
