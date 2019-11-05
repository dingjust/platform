<template>
  <div class="animated fadeIn requirement-detail">
    <div class="box" v-if="!readOnly">
      <div class="boxButton" @click="onInvitation" v-if="slotData.status == 'PENDING_QUOTE'">
        <el-row type="flex" justify="center">
          <div class="buttonIconClass">
            <svg t="1570870182765" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4529" width="100%" height="100%">
              <path d="M481.83 855.3c16.21 0 29.25 12.82 29.25 28.52s-13.14 28.53-29.25 28.53H306.06c-80.82 0.09-146.43-63.9-146.43-142.72V255.4c0-78.83 65.61-142.82 146.43-142.82h410c80.92 0 146.43 64 146.43 142.82v228.49c0 15.81-13.14 28.53-29.25 28.53S804 499.6 804 483.89V255.4c0-47.32-39.33-85.67-87.84-85.67h-410c-48.52 0-87.84 38.36-87.84 85.67v514.23c0 47.32 39.32 85.67 87.84 85.67zM364.65 284h292.86c16.2 0 29.25 12.82 29.25 28.53s-13.14 28.53-29.25 28.53H364.65c-16.21 0-29.25-12.82-29.25-28.53s13-28.53 29.25-28.53z m0 171.34h292.86c16.2 0 29.25 12.82 29.25 28.52s-13 28.62-29.25 28.62H364.65c-16.21 0-29.25-12.82-29.25-28.53s13-28.62 29.25-28.62z m0 171.44h117.18c16.21 0 29.25 12.82 29.25 28.53s-13.14 28.52-29.25 28.52H364.65c-16.21 0-29.25-12.81-29.25-28.52s13-28.53 29.25-28.53z m0 0" fill="#505766" p-id="4530"></path><path d="M768.87 781.1l85.07 83a28 28 0 0 1 0 40.38 29.74 29.74 0 0 1-41.4 0l-85.07-83-85.08 83a29.74 29.74 0 0 1-41.4 0 28 28 0 0 1 0-40.38l85.07-83-85.07-83a28 28 0 0 1 0-40.38 29.75 29.75 0 0 1 41.4 0l85.08 83 85.07-83a29.75 29.75 0 0 1 41.4 0 28 28 0 0 1 0 40.38z m0 0" fill="#FFD60C" p-id="4531"></path>
            </svg>
          </div>
        </el-row>
        <el-row type="flex" justify="center">
          <span class="buttonTextClass">邀请报价</span>
        </el-row>
      </div>
      <div class="boxButton" @click="onEdit" v-if="slotData.status == 'PENDING_QUOTE' && quotePage.totalElements <= 0">
        <el-row type="flex" justify="center">
          <div class="buttonIconClass">
            <svg t="1570872740453" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4753" width="100%" height="100%">
              <path d="M878.706111 98.25436m23.273401 21.962441l0 0q23.273401 21.962441 1.310961 45.235842l-488.369182 517.520441q-21.962441 23.273401-45.235842 1.310961l0 0q-23.273401-21.962441-1.310961-45.235842l488.369182-517.520441q21.962441-23.273401 45.235842-1.310961Z" fill="#FFD60C" p-id="4754"></path><path d="M835.65 455.5a28.17 28.17 0 0 0-28.36 28.17v334.65c0 19.8-14.47 36.16-32.74 36.16H246.8c-18.27 0-32.74-16.37-32.74-36.16V285.59c0-19.8 14.47-36.16 32.74-36.16H485c14.47 0 27-12.56 27-27s-12.56-27-27-27H246.8c-49.11 0-87.18 40-87.18 90.6v536.48a87.18 87.18 0 0 0 87.18 87.18h529.65c47.21 0 87.18-40 87.18-90.6V483.67a28.17 28.17 0 0 0-28-28.17z" fill="#505766" p-id="4755"></path>
            </svg>
          </div>
        </el-row>
        <el-row type="flex" justify="center">
          <span class="buttonTextClass">修改</span>
        </el-row>
      </div>
      <div class="boxButton" @click="onCancel" v-if="slotData.status == 'PENDING_QUOTE'">
        <el-row type="flex" justify="center">
          <div class="buttonIconClass">
            <svg t="1572935017200" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="40774" width="100%" height="100%">
              <path d="M481.83 855.3c16.21 0 29.25 12.82 29.25 28.52s-13.14 28.53-29.25 28.53H306.06c-80.82 0.09-146.43-63.9-146.43-142.72V255.4c0-78.83 65.61-142.82 146.43-142.82h410c80.92 0 146.43 64 146.43 142.82v228.49c0 15.81-13.14 28.53-29.25 28.53S804 499.6 804 483.89V255.4c0-47.32-39.33-85.67-87.84-85.67h-410c-48.52 0-87.84 38.36-87.84 85.67v514.23c0 47.32 39.32 85.67 87.84 85.67zM364.65 284h292.86c16.2 0 29.25 12.82 29.25 28.53s-13.14 28.53-29.25 28.53H364.65c-16.21 0-29.25-12.82-29.25-28.53s13-28.53 29.25-28.53z m0 171.34h292.86c16.2 0 29.25 12.82 29.25 28.52s-13 28.62-29.25 28.62H364.65c-16.21 0-29.25-12.82-29.25-28.53s13-28.62 29.25-28.62z m0 171.44h117.18c16.21 0 29.25 12.82 29.25 28.53s-13.14 28.52-29.25 28.52H364.65c-16.21 0-29.25-12.81-29.25-28.52s13-28.53 29.25-28.53z m0 0" fill="#505766" p-id="40775"></path><path d="M768.87 781.1l85.07 83a28 28 0 0 1 0 40.38 29.74 29.74 0 0 1-41.4 0l-85.07-83-85.08 83a29.74 29.74 0 0 1-41.4 0 28 28 0 0 1 0-40.38l85.07-83-85.07-83a28 28 0 0 1 0-40.38 29.75 29.75 0 0 1 41.4 0l85.08 83 85.07-83a29.75 29.75 0 0 1 41.4 0 28 28 0 0 1 0 40.38z m0 0" fill="#FFD60C" p-id="40776"></path>
            </svg>
          </div>
        </el-row>
        <el-row type="flex" justify="center">
          <span class="buttonTextClass">关闭</span>
        </el-row>
      </div>

      <!--<div class="boxButton">-->
        <!--<el-row type="flex" justify="center">-->
          <!--<div class="buttonIconClass">-->
            <!--<svg t="1570870292198" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4641" width="100%" height="100%">-->
              <!--<path d="M306.16 170.54c-48.52 0-87.84 38.26-87.84 85.46v513c0 47.2 39.32 85.46 87.84 85.46h410c48.52 0 87.84-38.26 87.84-85.46V541c0-15.67 13.14-28.46 29.25-28.46S862.5 525.23 862.5 541v228c0 78.63-65.51 142.46-146.43 142.46h-410c-80.82 0-146.43-63.83-146.43-142.46V256c0-78.63 65.61-142.46 146.43-142.37h175.76c16.11 0 29.25 12.69 29.25 28.46s-13 28.45-29.25 28.45z m58.49 569.86c-16.21 0-29.25-12.79-29.25-28.45s13-28.45 29.25-28.45h292.86c16.1 0 29.25 12.79 29.25 28.45s-13 28.45-29.25 28.45z m0-170.92c-16.21 0-29.25-12.88-29.25-28.55s13-28.45 29.25-28.45H476.2c16.2 0 29.25 12.88 29.25 28.55s-13 28.45-29.25 28.45z m0-171" fill="#505766" p-id="4642"></path><path d="M856.39 170.53a14 14 0 0 0-5.3-9.48l-56.38-44.28a14.8 14.8 0 0 0-10.71-3.06 14.61 14.61 0 0 0-9.76 5.18l-237 284.88a14.32 14.32 0 0 0-2.55 4.71l-0.07 0.25-22.9 72.27a13.88 13.88 0 0 0 4.75 15.11l11.27 8.89a14.85 14.85 0 0 0 16.21 1.32l67.87-36.93 0.24-0.14a14.72 14.72 0 0 0 4.21-3.41l237-284.88a13.82 13.82 0 0 0 3.12-10.43z" fill="#FFD60C" p-id="4643"></path>-->
            <!--</svg>-->
          <!--</div>-->
        <!--</el-row>-->
        <!--<el-row type="flex" justify="center">-->
          <!--<span class="buttonTextClass">重新发布</span>-->
        <!--</el-row>-->
      <!--</div>-->
    </div>
    <el-row class="factory-info-title-row" type="flex" justify="space-between">
      <div class="factory-info-title">
        <h6 class="factory-info-title_text">需求订单详情</h6>
      </div>
      <!--<i class="el-icon-edit" @click="onEdit" style="cursor:pointer;font-size: 20px"></i>-->
    </el-row>
    <el-row type="flex" align="middle" style="margin-bottom: 20px">
      <el-col :span="6">
        <span>需求编号：{{slotData.code}}</span>
      </el-col>
      <el-col :span="6">
        <span>当前状态：<span :style="{color: statusColor}">{{getEnum('requirementOrderStatuses',slotData.status)}}</span></span>
      </el-col>
      <el-col :span="6">
        <el-row type="flex" justify="end">
          <span>发布日期：{{slotData.creationtime | formatDate}}</span>
        </el-row>
      </el-col>
      <el-col :span="6">
        <el-row type="flex" justify="end">
          <span>有效期限：{{getEnum('EffectiveDays',slotData.details.effectiveDays == null ? 'null': slotData.details.effectiveDays.toString())}}</span>
        </el-row>
      </el-col>
    </el-row>
    <!--<el-divider></el-divider>-->

    <div class="titleCardClass">
      <el-row type="flex">
        <el-col :span="18">
          <el-row>
            <div class="titleClass">
              <h6>需求信息</h6>
            </div>
          </el-row>
          <requirement-order-basic-info-page :slotData="slotData" style="padding:10px"/>
        </el-col>
        <el-divider direction="vertical"></el-divider>
        <el-col :span="6">
          <el-row>
            <div class="titleClass">
              <h6>发布需求者</h6>
            </div>
          </el-row>
          <requirement-order-belong-to-info-page :slotData="slotData" style="margin: 20px 0px 10px 10px;"/>
        </el-col>
      </el-row>
      <el-divider ></el-divider>
      <el-row v-if="!readOnly">
        <div class="titleClass">
          <h6>报价详情</h6>
        </div>
      </el-row>
      <requirement-order-quote-list :page="quotePage" @onSearch="onSearchQuotes" v-if="!readOnly" style="margin-left: 10px">
        <!--<template slot="operations" slot-scope="props">-->
          <!--<el-button type="text" style="padding: 5px 15px;background-color: #ffd60c;color: black;">-->
            <!--确认工厂-->
          <!--</el-button>-->
          <!--<el-button type="text" style="padding: 5px 15px;background-color: red;color: white;">-->
            <!--拒绝工厂-->
          <!--</el-button>-->
          <!--&lt;!&ndash;<el-button type="text" icon="el-icon-edit" @click="onDetails(props.item)">&ndash;&gt;-->
        <!--&lt;!&ndash;查看详细报价&ndash;&gt;-->
        <!--&lt;!&ndash;</el-button>&ndash;&gt;-->
        <!--</template>-->
      </requirement-order-quote-list>
    </div>
    <el-dialog :visible.sync="detailsDialogVisible" width="80%"  class="purchase-dialog" :append-to-body="true">
      <quote-details-page :slotData="quoteData" :readOnly="true">

      </quote-details-page>
    </el-dialog>

    <el-dialog :visible.sync="factoryListDialogVisible" width="80%"  class="purchase-dialog" append-to-body>
      <factory-cooperator-transfer v-if="factoryListDialogVisible"
                                   @onSubmit="onInvitationFactories"
                                   :selectedTip="tip"
                                   :selectUids="selectUids">

      </factory-cooperator-transfer>
    </el-dialog>

    <el-dialog :visible.sync="formDialogVisible" width="80%"  class="purchase-dialog" append-to-body>
      <requirement-order-form v-if="formDialogVisible" :formData="formData" @onSave="onSave">

      </requirement-order-form>
    </el-dialog>


  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  import RequirementOrderBasicInfoPage from '../info/RequirementOrderBasicInfoPage';
  import RequirementOrderBelongToInfoPage from '../info/RequirementOrderBelongToInfoPage';
  import RequirementOrderQuoteList from '../list/RequirementOrderQuoteList';
  import QuoteDetailsPage from '../../quote/details/QuoteDetailsPage';
  import FactoryCooperatorTransfer from '../../../../components/custom/FactoryCooperatorTransfer';
  import RequirementOrderForm from '../form/RequirementOrderForm';

  const {mapGetters, mapMutations, mapActions} = createNamespacedHelpers('RequirementOrdersModule');

  export default {
    name: 'RequirementOrderDetailsPage',
    props: {
      slotData: {
        type: Object,
        required: true
      },
      readOnly: {
        type: Boolean,
        default: true
      }
    },
    components: {
      RequirementOrderForm,
      FactoryCooperatorTransfer,
      QuoteDetailsPage,
      RequirementOrderQuoteList,
      RequirementOrderBelongToInfoPage,
      RequirementOrderBasicInfoPage

    },
    computed: {
      ...mapGetters({
        quotePage: 'quotePage',
        formData: 'formData',
        regions: 'regions'
      }),
      statusColor: function () {
        var color = '';
        switch (this.slotData.status) {
          case 'PENDING_QUOTE':
            color = 'red';
            break;
          case 'COMPLETED':
            color = 'green';
            break;
          case 'CANCELLED':
            color = 'grey';
            break;
        }
        return color;
      }
    },
    methods: {
      ...mapMutations({
        setRegions: 'regions',
        setFormData: 'formData'
      }),
      ...mapActions({
      }),
      async onDetails (item) {
        const url = this.apis().getQuote(item.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.quoteData = result;
        this.detailsDialogVisible = !this.detailsDialogVisible;
      },
      onSearchQuotes (page, size) {
        this.$emit('onSearchQuotes', page, size);
      },
      async onInvitation () {
        const url = this.apis().getRecommendFactories(this.slotData.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.selectUids = result;
        if (this.regions.length <= 0) {
          this.getRegions();
        }

        this.factoryListDialogVisible = !this.factoryListDialogVisible;
      },
      async getRegions () {
        const url = this.apis().getRegions();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setRegions(result);
      },
      // 邀请工厂报价
      async onInvitationFactories (uids) {
        if (uids == null || uids.length <= 0) {
          this.$message.error('请选择工厂');
          return;
        }
        var uidStr = '';
        for (let uid of uids) {
          uidStr += uid + ',';
        }
        if (uidStr.length > 0) {
          uidStr = uidStr.slice(0, uidStr.lastIndexOf('，'));
        }

        const url = this.apis().recommendRequirementOrderToFactory(this.slotData.code, uidStr);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.factoryListDialogVisible = false;
        this.$message.success('邀请工厂报价成功');
      },
      async onEdit () {
        const url = this.apis().getRequirementOrder(this.slotData.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        result.details.effectiveDays = result.details.effectiveDays == null ? 'null' : result.details.effectiveDays.toString();
        this.setFormData(Object.assign({}, this.formData, result));
        this.formDialogVisible = !this.formDialogVisible;
      },
      async onSave (factories, phoneNumbers) {
        console.log(factories);
        var params = {};
        if (factories != null) {
          var text = '';
          for (let uid of factories) {
            text += uid;
            text += ',';
          }
          text = text.slice(0, text.length - 1);
        }
        console.log(text);
        params['factories'] = text;
        const url = this.apis().updateRequirementOrder(this.formData.code);
        const result = await this.$http.put(url, this.formData, params);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('需求订单修改成功');
        this.formDialogVisible = !this.formDialogVisible;
        this.$emit('onRefresh', this.formData.code);
      },
      onCancel () {
        this.$confirm('是否确认关闭该订单', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(async () => {
          const url = this.apis().cancelledRequirementOrder(this.slotData.code);
          const result = await this.$http.delete(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.$message.success('需求关闭成功');
          this.$emit('onRefresh', this.formData.code);
        });
      }
    },
    data () {
      return {
        detailsDialogVisible: false,
        factoryListDialogVisible: false,
        formDialogVisible: false,
        selectUids: [],
        quoteData: '',
        tip: '该工厂已邀请'
      }
    },
    created () {
    },
    destroyed () {
    }
  }
</script>

<style scoped>
  .requirement-detail .factory-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .requirement-detail .factory-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .requirement-detail .factory-info-title-row {
    margin-bottom: 20px;
  }

  .requirement-detail .el-divider--horizontal{
    margin: 0px 0px -1px 0px;
  }

  .requirement-detail .buttonClass{
    padding: 8px 35px 8px 35px;
    margin-bottom: 10px;
    background-color: #ffd60c;
    color: #0b0e0f;
  }

  .requirement-detail .box{
    width: 50px;
    position: fixed;
    right: 152px;
    top: 300px;
    z-index:1;
  }
  .requirement-detail .boxButton{
    width: 50px;
    height: 50px;
    font-size: 10px;
    cursor: pointer;
    border: 1px solid #DCDFE6;
  }

  .requirement-detail .buttonIconClass{
    width: 30px;
    height: 30px;
    margin-bottom: 8px;
  }

  .requirement-detail .buttonTextClass{
    transform:scale(0.7);
  }

  .requirement-detail .titleClass{
    padding: 10px 0px 1px 10px;
    background-color: #F0F0F0;
  }

  .requirement-detail .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }

  .requirement-detail .el-divider--vertical{
    height: auto;
    margin: 0px;
  }
</style>
