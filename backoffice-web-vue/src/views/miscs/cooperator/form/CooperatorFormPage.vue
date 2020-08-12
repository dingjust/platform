<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <div class="animated fadeIn">
        <el-form :model="formData" ref="form" label-position="left">
          <div class="cooperator-info-order-body">
            <el-row class="cooperator-info-title-row">
              <div class="cooperator-info-title">
                <h6 class="cooperator-info-title_text">添加合作商</h6>
              </div>
            </el-row>
            <el-row type="flex" class="row-title">
              <form-label label="基本信息" />
            </el-row>
            <el-row type="flex" justify="start" align="middle" :gutter="10">
              <el-col :span="9">
                <el-form-item prop="name" label="合作商名称" label-width="100px">
                  <el-select v-model="formData.name" multiple filterable remote reserve-keyword
                    @remove-tag="onRemoveTag" v-if="(formData.name instanceof Array)&&formData.name.length>0"
                    style="width:100%">
                  </el-select>
                  <el-input v-else v-model="formData.name"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="3">
                <el-button class="form-btn_select" @click="onUserSelect">选择平台用户</el-button>
              </el-col>
              <el-col :span="6">
                <el-form-item prop="contactPerson" label="联系人" label-width="80px">
                  <el-input placeholder="姓名" v-if="formData.partner != null" v-model="formData.partner.contactPerson"
                    :disabled="formData.partner != null" size="mini">
                  </el-input>
                  <el-input placeholder="姓名" v-else v-model="formData.contactPerson"
                    :disabled="formData.partner != null" size="mini">
                  </el-input>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item prop="contactPhone" label="联系方式" label-width="80px">
                  <el-input placeholder="电话号码" v-if="formData.partner != null" v-model="formData.partner.contactPhone"
                    :disabled="formData.partner != null" size="mini">
                  </el-input>
                  <el-input placeholder="电话号码" v-else v-model="formData.contactPhone"
                    :disabled="formData.partner != null" size="mini">
                  </el-input>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row type="flex" align="middle" :gutter="10">
              <el-col :span="12">
                <el-form-item label="身份类型" prop="category" label-width="80px">
                  <el-radio-group v-model="formData.category" style="padding-top:5px">
                    <el-radio v-for="item in cooperatorCategorys" :label="item.code" :key="item.code">{{item.name}}
                    </el-radio>
                  </el-radio-group>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item prop="remarks" label="备注" label-width="80px">
                  <el-row type="flex" align="middle">
                    <el-input v-model="formData.remarks" size="mini">
                    </el-input>
                  </el-row>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row type="flex">
              <h6 class="item-label">所在区域</h6>
              <address-form ref="addressForm" :slot-data="formData.address" />
            </el-row>
            <el-row class="row-title">
              <form-label label="公账信息" />
            </el-row>
            <el-row :gutter="10" type="flex" align="middle">
              <el-col :span="12">
                <el-form-item prop="taxNumber" label="户名" label-width="80px">
                  <el-input placeholder="户名" v-model="formData.detailedIdentity" size="mini">
                  </el-input>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item prop="taxNumber" label="税号" label-width="80px">
                  <el-input placeholder="税号" v-model="formData.taxNumber" size="mini">
                  </el-input>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row type="flex" justify="start" align="middle" :gutter="10">
              <el-col :span="12">
                <el-form-item prop="bankOfDeposit" label="开户行" label-width="80px">
                  <el-input placeholder="开户行" v-model="formData.bankOfDeposit" size="mini">
                  </el-input>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item prop="bankAccount" label="银行账号" label-width="80px">
                  <el-input placeholder="银行账号" v-model="formData.bankAccount" size="mini">
                  </el-input>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row type="flex" class="row-title">
              <form-label label="关联方案" />
            </el-row>
            <el-row type="flex" justify="start" align="middle" :gutter="10">
              <el-col :span="8">
                <el-input placeholder="" :value="formData.payPlan != null ? formData.payPlan.name : ''" size="mini"
                  :disabled="false">
                  <template slot="prepend">绑定财务方案</template>
                  <el-button slot="append" @click="payPlanSelectDialogVisible = !payPlanSelectDialogVisible">选择
                  </el-button>
                </el-input>
              </el-col>
              <el-col :span="8">
                <el-input placeholder="" :value="formData.payPlan != null ? formData.payPlan.name : ''" size="mini"
                  :disabled="false">
                  <template slot="prepend">绑定财务方案</template>
                  <el-button slot="append" @click="payPlanSelectDialogVisible = !payPlanSelectDialogVisible">选择
                  </el-button>
                </el-input>
              </el-col>
              <el-col :span="8">
                <el-input placeholder="" :value="formData.payPlan != null ? formData.payPlan.name : ''" size="mini"
                  :disabled="false">
                  <template slot="prepend">绑定财务方案</template>
                  <el-button slot="append" @click="payPlanSelectDialogVisible = !payPlanSelectDialogVisible">选择
                  </el-button>
                </el-input>
              </el-col>
            </el-row>
            <el-row type="flex" justify="center">
              <el-button class="cooperator-info-order-submit" @click="onSubmit()">确认创建</el-button>
            </el-row>
          </div>
        </el-form>
      </div>
    </el-card>
    <el-dialog :visible.sync="payPlanSelectDialogVisible" width="50%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <pay-plan-select :page="payPlanPage" @onSearch="onSearchPayPlan" @onSelect="onSelect" />
    </el-dialog>
    <el-dialog :visible.sync="companyDialogVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <company-select />
    </el-dialog>
  </div>


</template>

<script>
  import Vue from 'vue';
  import {
    createNamespacedHelpers
  } from 'vuex';
  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers('CooperatorModule');

  import {
    AddressForm,
    FormLabel,
    PayPlanSelect,
    CompanySelect
  } from '@/components/'

  export default {
    name: 'CooperatorFormPage',
    props: [],
    components: {
      FormLabel,
      PayPlanSelect,
      AddressForm,
      CompanySelect
    },
    computed: {
      ...mapGetters({
        formData: 'formData'
      }),
      ...createNamespacedHelpers('PayPlanModule').mapGetters({
        payPlanPage: 'page',
        queryFormData: 'queryFormData'
      })
    },
    methods: {
      ...mapMutations({
        currentPageNumber: 'currentPageNumber',
        currentPageSize: 'currentPageSize',
        setFormData: 'setFormData'
      }),
      ...mapActions({
        searchAdvanced: 'searchAdvanced',
        clearFormData: 'clearFormData'
      }),
      ...createNamespacedHelpers('PayPlanModule').mapActions({
        searchPayPlan: 'searchAdvanced'
      }),
      onSearch(page, size) {
        const queryFormData = this.queryFormData;

        const url = this.apis().getCooperators();
        this.searchAdvanced({
          url,
          queryFormData,
          page,
          size
        });
      },
      handleClick(tab, event) {
        // console.log(tab.name);
        this.queryFormData.statuses = [tab.name];
        if (tab.name === 'ALL') {
          this.onSearch('');
        } else {
          this.onAdvancedSearch();
        }
      },
      async querySearchAsync(queryString, cb) {
        this.isScrollEnd = false;
        this.keyword = queryString;
        this.pageNumber = 0;
        if (this.isBrand()) {
          const result = await this.$http.post(this.apis().getFactoriesByName(), null, {
            'keyword': queryString,
            page: this.pageNumber
          });
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.companies = result.content;
        } else if (this.isFactory()) {
          const result = await this.$http.post(this.apis().getBrandsByName(), null, {
            'keyword': queryString,
            page: this.pageNumber
          });
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.companies = result.content;
        }

        var results = this.companies;
        cb(results);
      },
      handleSelect(item) {
        this.formData.partner = {
          uid: item.uid,
          name: item.name,
          contactPerson: item.contactPerson,
          contactPhone: item.contactPhone
        };

        var input = document.getElementById('partnerInput');
        if (document.activeElement === input) {
          input.blur();
        }
      },
      handleClear() {
        this.formData.partner = null;
        this.formData.name = '';
      },
      handleFocus() {
        document.getElementById('partnerInput').blur();
      },
      async onSubmit() {
        // 提交数据
        const url = this.apis().createCooperator();
        const result = await this.$http.post(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$router.push('/account/cooperator');
      },
      async onSearchPayPlan(page, size) {
        const url = this.apis().getPayPlans();
        this.searchPayPlan({
          url,
          page,
          size
        });
      },    
      onSelect(item) {
        console.log(item);
        if (item != null && item != '') {
          this.formData.payPlan = item;
        }
        this.payPlanSelectDialogVisible = false;
      },
      getPaymentStatusTag(item) {
        if (item.approvalStatus == 'approved') {
          return 'static/img/certified.png';
        } else {
          return 'static/img/uncertified.png';
        }
      },
      onUserSelect() {
        // this.formData.name = ['qwewqe'];
        this.companyDialogVisible=true;
      },
      //名称标签移除
      onRemoveTag(tag) {
        //TODO:处理线上线下类型
        console.log(tag);
      }
    },
    data() {
      return {
        payPlanSelectDialogVisible: false,
        companyDialogVisible: false,
        cooperatorCategorys: this.$store.state.EnumsModule.CooperatorCategory,
        companies: [],
        payPlans: [],
        keyword: '',
        pageNumber: 0,
        isScrollEnd: false,
        options: [],
      };
    },
    created() {

    },
    destroyed() {
      this.clearFormData();
      console.log(this.formData);
    },
    watch: {
      // 关闭弹窗时清空表单数据
      payPlanSelectDialogVisible: {
        handler(val, oldVal) {
          if (val === false) {
            this.queryFormData.keyword = '';
          } else {
            this.onSearchPayPlan();
          }
        },
        deep: true
      }
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


  .cooperator-info-order-body {
    width: 100%;
    /*padding: 10px 60px;*/
  }

  .el-input.is-disabled .el-input__inner {
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

  .form-btn_select {
    background-color: #FFD60C;
    border-color: #FFD60C;
    margin-bottom: 25px;
    color: #000;
  }

  .item-label {
    width: 80px;
    padding-top: 5px;
  }

  .row-title {
    margin-bottom: 20px
  }

</style>
