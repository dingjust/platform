<template>
  <div class="animated fadeIn content ttt1">
    <el-card class="box-card">
      <div class="animated fadeIn">
        <el-form :model="formData">
          <div class="cooperator-info-order-body">
            <el-row class="cooperator-info-title-row">
              <div class="cooperator-info-title">
                <h6 class="cooperator-info-title_text">编辑合作商</h6>
              </div>
            </el-row>
            <el-row type="flex">
              <form-label label="基本信息" />
            </el-row>
            <el-row type="flex" style="margin-top: 20px;margin-bottom: 10px;font-size: 12px">
              <el-col :span="12">
                <el-row type="flex" justify="end">
                  <span>{{formData.partner ? '线上合作商': '自定义合作商'}}</span>
                </el-row>
              </el-col>
            </el-row>
            <el-row class="cooperator-info-order-row" type="flex" justify="start" align="middle" :gutter="10">
              <el-col :span="12">
                <el-form-item prop="name" class="cooperator-form-item">
                  <el-row type="flex" align="middle">
                    <h6 class="cooperator-info-input-prepend">合作商名称</h6>
                    <el-autocomplete v-if="formData.partner != null" style="width: 100%"
                                     id="partnerInput"
                                     v-model="formData.partner.name"
                                     :fetch-suggestions="querySearchAsync"
                                     placeholder="请输入合作商名称"
                                     @select="handleSelect"
                                     @clear="handleClear"
                                     @focus="handleFocus"
                                     value-key = "name"
                                     :disabled = "isOnline"
                                     :trigger-on-focus="false">
                    </el-autocomplete>
                    <el-autocomplete v-else style="width: 100%"
                                     id="partnerInput"
                                     v-model="formData.name"
                                     :fetch-suggestions="querySearchAsync"
                                     placeholder="请输入合作商名称"
                                     @select="handleSelect"
                                     :highlight-first-item="true"
                                     :trigger-on-focus="false">
                      <template slot-scope="{ item }">
                        <el-row type="flex">
                          <el-col :span="16">
                            <span >{{ item.name }}</span>
                          </el-col>
                          <el-col :span="4">
                            <span >{{ item.contactPerson }}</span>
                          </el-col>
                          <el-col :span="4">
                            <span>{{ item.contactPhone }}</span>
                          </el-col>
                        </el-row>

                      </template>
                    </el-autocomplete>
                  </el-row>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item prop="contactPerson" class="cooperator-form-item">
                  <el-row type="flex" align="middle">
                    <h6 class="cooperator-info-input-prepend">联系人</h6>
                    <el-input placeholder="姓名"
                              v-model="formData.partner != null ? formData.partner.contactPerson : formData.contactPerson"
                              :disabled="formData.partner != null"
                              size="mini">
                    </el-input>
                  </el-row>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item prop="contactPhone" class="cooperator-form-item">
                  <el-row type="flex" align="middle">
                    <h6 class="cooperator-info-input-prepend">联系方式</h6>
                    <el-input placeholder="电话号码"
                              v-model="formData.partner != null ? formData.partner.contactPhone : formData.contactPhone"
                              :disabled="formData.partner != null"
                              size="mini">
                    </el-input>
                  </el-row>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="10">
              <el-col :span="12">
                <el-form-item label="" prop="category">
                  <el-row type="flex" align="middle">
                    <h6 class="cooperator-info-input-prepend">身份类型</h6>
                    <el-radio-group v-model="formData.category">
                      <el-radio v-for="item in cooperatorCategorys" :label="item.code">{{item.name}}</el-radio>
                    </el-radio-group>
                  </el-row>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item prop="detailedIdentity" class="cooperator-form-item">
                  <el-row type="flex" align="middle">
                    <h6 class="cooperator-info-input-prepend">详细身份</h6>
                    <el-input placeholder="如面料供应商、辅料供应商等......" v-model="formData.detailedIdentity" size="mini">
                    </el-input>
                  </el-row>
                </el-form-item>
              </el-col>
            </el-row>

            <el-row class="cooperator-info-order-row">
              <form-label label="公账信息" />
            </el-row>
            <el-row class="cooperator-info-order-row" type="flex" justify="start" align="middle" :gutter="10">
              <el-col :span="12">
                <el-form-item prop="bankOfDeposit" class="cooperator-form-item">
                  <el-row type="flex" align="middle">
                    <h6 class="cooperator-info-input-prepend">开户行</h6>
                    <el-input placeholder="开户行" v-model="formData.bankOfDeposit" size="mini">
                    </el-input>
                  </el-row>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item prop="bankAccount" class="cooperator-form-item">
                  <el-row type="flex" align="middle">
                    <h6 class="cooperator-info-input-prepend">银行账号</h6>
                    <el-input placeholder="银行账号" v-model="formData.bankAccount" size="mini">
                    </el-input>
                  </el-row>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="10">
              <el-col :span="12">
                <el-form-item prop="taxNumber" class="cooperator-form-item">
                  <el-row type="flex" align="middle">
                    <h6 class="cooperator-info-input-prepend">税号</h6>
                    <el-input placeholder="税号" v-model="formData.taxNumber" size="mini">
                    </el-input>
                  </el-row>
                </el-form-item>
              </el-col>
            </el-row>

            <el-row class="cooperator-info-order-row" style="margin-top: 20px">
              <form-label label="其他信息" />
            </el-row>
            <el-row class="cooperator-info-order-row" type="flex" justify="start" align="middle" :gutter="10">
              <el-col :span="12">
                <el-row type="flex" align="middle">
                  <h6 class="cooperator-info-input-prepend">绑定账务方案</h6>
                  <el-input placeholder="" :value="formData.payPlan != null ? formData.payPlan.name : ''" size="mini" :disabled="false">
                    <el-button slot="append" @click="payPlanSelectDialogVisible = !payPlanSelectDialogVisible">选择</el-button>
                  </el-input>
                </el-row>
              </el-col>
            </el-row>
            <el-row :gutter="10">
              <el-col :span="24">
                <el-form-item prop="remarks" class="cooperator-form-item">
                  <el-row type="flex" align="middle">
                    <h6 class="cooperator-info-input-prepend">备注</h6>
                    <el-input placeholder="备注" v-model="formData.remarks" size="mini">
                    </el-input>
                  </el-row>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row type="flex" justify="center" class="cooperator-info-order-row">
              <el-button class="cooperator-info-order-submit" @click="onSubmit()">确认保存</el-button>
            </el-row>
          </div>
        </el-form>
      </div>
    </el-card>

    <el-dialog :visible.sync="payPlanSelectDialogVisible" width="50%" class="purchase-dialog" append-to-body>
        <pay-plan-select :page="payPlanPage" @onSearch="onSearchPayPlan" @onSelect="onSelect"/>
    </el-dialog>
  </div>


</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  const {mapGetters, mapActions, mapMutations} = createNamespacedHelpers('CooperatorModule');
  import FormLabel from '@/components/custom/FormLabel';
  import PayPlanSelect from '@/components/custom/PayPlanSelect';

  export default {
    name: 'CooperatorEditFormPage',
    props: [],
    components: {FormLabel, PayPlanSelect},
    computed: {
      ...mapGetters({
        formData: 'editFormData'
      }),
      ...createNamespacedHelpers('PayPlanModule').mapGetters({
        payPlanPage: 'page',
        queryFormData: 'queryFormData'
      }),
    },
    methods: {
      ...mapMutations({
        setFormData: 'setFormData',
        currentPageNumber: 'currentPageNumber',
        currentPageSize: 'currentPageSize'
      }),
      ...mapActions({
        searchAdvanced: 'searchAdvanced'
      }),
      ...createNamespacedHelpers('PayPlanModule').mapActions({
        searchPayPlan: 'searchAdvanced'
      }),
      onSearch (page, size) {
        const queryFormData = this.queryFormData;

        const url = this.apis().getCooperators();
        this.searchAdvanced({url, queryFormData, page, size});
      },
      handleClick (tab, event) {
        // console.log(tab.name);
        this.queryFormData.statuses = [tab.name];
        if (tab.name === 'ALL') {
          this.onSearch('');
        } else {
          this.onAdvancedSearch();
        }
      },
      async querySearchAsync (queryString, cb) {
        if (this.isBrand()) {
          const result = await this.$http.post(this.apis().getFactories(), {'keyword': queryString});
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          console.log(result);
          this.companies = result.content;
        } else if (this.isFactory()) {
          const result = await this.$http.post(this.apis().getBrands(), {'keyword': queryString});
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.companies = result.content;
        }

        var results = this.companies;
        cb(results);
      },
      handleSelect (item) {
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
      handleClear () {
        this.formData.partner = null;
        this.formData.name = '';
      },
      handleFocus () {
        document.getElementById('partnerInput').blur();
      },
      async onSubmit () {
        // 提交数据
        const url = this.apis().updateCooperator();
        const result = await this.$http.put(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$router.push('/miscs/cooperator');
      },
      async onSearchPayPlan (page, size) {
        const url = this.apis().getPayPlans();
        this.searchPayPlan({url, page, size});
      },
      onSelect (item) {
        this.formData.payPlan = item;
        this.payPlanSelectDialogVisible = false;
      }
    },
    data () {
      return {
        payPlanSelectDialogVisible: false,
        cooperatorCategorys: this.$store.state.EnumsModule.CooperatorCategory,
        companies: [],
        payPlans: [],
        isOnline: false,
      };
    },
    created () {
      if (this.formData.partner != null){
        this.isOnline = true;
      }
    },
    watch: {
      // 关闭弹窗时清空表单数据
      payPlanSelectDialogVisible: {
        handler (val, oldVal) {
          if (val === false) {
            this.queryFormData.keyword = '';
          }else{
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
  .cooperator-info-order-row {
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
</style>
