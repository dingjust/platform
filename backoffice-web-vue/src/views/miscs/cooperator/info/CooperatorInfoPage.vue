<template>
  <div class="animated fadeIn ">
    <div class="cooperator-info-order-body">
      <el-row type="flex">
        <el-col :span="11">
          <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
            <el-col :span="6">合作商类型</el-col>
            <el-col :span="18">{{getEnum('CooperatorType',itemData.type)}}</el-col>
          </el-row>
          <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
            <el-col :span="6">合作商名称</el-col>
            <el-col :span="18">
              <el-row type="flex" justify="space-between" v-if="itemData.type == 'ONLINE'">
                <div>
                  {{itemData.partner == null ? itemData.name : itemData.partner.name}}
                  <template v-if="itemData.partner!=null">
                    <el-tag type="success" v-if="itemData.partner.approvalStatus === 'approved'">已认证</el-tag>
                    <el-tag type="info" v-else>未认证</el-tag>
                  </template>
                </div>
                <el-button v-if="itemData.partner.type === 'FACTORY'" class="btn-class" style="padding: 3px 4px;"
                  @click="onFactoryDetail">
                  查看公司详情
                </el-button>
                <el-button v-else class="btn-class" style="padding: 3px 4px;" @click="onBrandDetail">
                  查看公司详情
                </el-button>
              </el-row>
              <div v-else>
                {{itemData.partner == null ? itemData.name : itemData.partner.name}}
              </div>
            </el-col>
          </el-row>
          <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
            <el-col :span="6">联系人</el-col>
            <el-col :span="18">{{itemData.partner == null ? itemData.contactPerson : itemData.partner.contactPerson}}
            </el-col>
          </el-row>
          <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
            <el-col :span="6">联系方式</el-col>
            <el-col :span="18">{{itemData.partner == null ? itemData.contactPhone : itemData.partner.contactPhone}}
            </el-col>
          </el-row>
          <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
            <el-col :span="6">身份类型</el-col>
            <el-col :span="18">
              {{getEnum('CooperatorCategory',itemData.category)}}
              <span
                v-if="itemData.detailedIdentity != null && itemData.detailedIdentity != ''">{{'('}}{{itemData.detailedIdentity}}{{')'}}</span>
            </el-col>
          </el-row>
        </el-col>
        <el-divider direction="vertical"></el-divider>
        <el-col :span="12">
          <div class="grid-content bg-purple-light">
            <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
              <el-col :span="6">开户行</el-col>
              <el-col :span="18">{{itemData.bankOfDeposit}}</el-col>
            </el-row>
            <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
              <el-col :span="6">银行账号</el-col>
              <el-col :span="18">{{itemData.bankAccount}}</el-col>
            </el-row>
            <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
              <el-col :span="6">税号</el-col>
              <el-col :span="18">{{itemData.taxNumber}}</el-col>
            </el-row>
            <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
              <el-col :span="6">绑定账务方案</el-col>
              <el-col :span="18">{{itemData.payPlan != null ? itemData.payPlan.name : ''}}</el-col>
            </el-row>
            <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
              <el-col :span="6">备注</el-col>
              <el-col :span="18">{{itemData.remarks}}</el-col>
            </el-row>
          </div>
        </el-col>
      </el-row>
    </div>
    <el-dialog :visible.sync="factoryDetailsDialogVisible" v-if="factoryDetailsDialogVisible" width="80%"
      class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <div class="pt-3"></div>
      <factory-from :slotData="factoryDetailsData" :readOnly="readOnly"></factory-from>
    </el-dialog>
    <el-dialog :visible.sync="brandDetailsDialogVisible" v-if="brandDetailsDialogVisible" width="80%"
      class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <brand-from1 :slotData="brandDetailsData" :read-only="readOnly"></brand-from1>
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import FactoryFrom from '../../../user/company/factory/form/FactoryForm';
  import BrandFrom1 from '../../../user/company/brand/form/BrandForm1';

  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers('CooperatorModule');

  export default {
    name: 'CooperatorInfoPage',
    props: ['itemData'],
    components: {
      BrandFrom1,
      FactoryFrom
    },
    computed: {
      ...mapGetters({})
    },
    methods: {
      ...mapActions({}),
      async onFactoryDetail() {
        let url = this.apis().getFactory(this.itemData.partner.uid);
        if (this.isTenant()) {
          url += '?sort=creationtime,desc';
        }
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        if (result.duties == null || result.duties == undefined) {
          result.duties = '经理';
        }

        this.factoryDetailsData = result;
        this.readOnly = true;
        this.factoryDetailsDialogVisible = !this.factoryDetailsDialogVisible;
      },
      async onBrandDetail() {
        let url = this.apis().getBrand(this.itemData.partner.uid);
        if (this.isTenant()) {
          url += '?sort=creationtime,desc';
        }
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.duties == null || result.duties == undefined) {
          result.duties = '经理';
        }

        this.brandDetailsData = result;
        this.readOnly = true;
        this.brandDetailsDialogVisible = !this.brandDetailsDialogVisible;
      },
    },
    data() {
      return {
        factoryDetailsDialogVisible: false,
        factoryDetailsData: '',
        brandDetailsDialogVisible: false,
        brandDetailsData: '',
        readOnly: false
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

  /deep/ .el-input.is-disabled .el-input__inner {
    cursor: pointer;
    background-color: #fff;
  }


  .cooperator-info-order-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
    margin-top: 30px;
  }

  .el-divider--vertical {
    height: auto;
  }

</style>
