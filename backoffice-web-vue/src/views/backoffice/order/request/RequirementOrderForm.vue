<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>订单</span>
      </div>
      <div class="pt-2"></div>
      <el-steps finish-status="success" align-center :active="active">
        <el-step title="基本信息"></el-step>
        <el-step title="合同上传"></el-step>
        <el-step title="完成"></el-step>
      </el-steps>
      <div class="pt-2"></div>
      <div v-show="active === 0">
        <requirement-order-base-form ref="requirementOrderBase"
                                     :slot-data="slotData"
                                     :read-only="false"
                                     :belong-to-editable="isNewlyCreated">
        </requirement-order-base-form>
        <hr/>
        <requirement-order-delivery-address-form ref="deliveryAddressForm"
                                                 :slot-data="slotData"
                                                 :read-only="false">
        </requirement-order-delivery-address-form>
        <hr/>
        <requirement-order-request-form ref="requestForm"
                                        :slot-data="slotData"
                                        :read-only="false">
        </requirement-order-request-form>
        <hr/>
        <requirement-order-entries-form ref="entriesForm"
                                        :slot-data="slotData"
                                        :read-only="false">
        </requirement-order-entries-form>
        <div class="pt-2"></div>
        <el-row :gutter="10">
          <el-col :span="12">
            <el-button class="btn-block" size="mini" type="primary" @click="onSubmit()">提交</el-button>
          </el-col>
          <el-col :span="12">
            <el-button class="btn-block" size="mini" @click="onCancel">取消</el-button>
          </el-col>
        </el-row>
      </div>
      <div v-show="active === 1">
        <requirement-order-media-upload-form ref="mediaUploadForm"
                                             :slot-data="slotData"
                                             :read-only="false">
        </requirement-order-media-upload-form>
        <div class="pt-2"></div>
        <el-row :gutter="10">
          <el-col :span="12">
            <el-button class="btn-block bg-primary" size="mini" @click="onMediaUpload">上传</el-button>
          </el-col>
          <el-col :span="12">
            <el-button class="btn-block" size="mini" type="primary" @click="onStep(2)">下一步</el-button>
          </el-col>
        </el-row>
      </div>
      <div v-show="active === 2">
        <requirement-order-details-page ref="detailsPage"
                                        :slot-data="slotData"
                                        :preview="true"
                                        :read-only="true">
        </requirement-order-details-page>
        <div class="pt-2"></div>
        <el-row :gutter="10">
          <el-col :span="12">
            <el-button class="btn-block" size="mini" @click="onStep(1)">上一步</el-button>
          </el-col>
          <el-col :span="12">
            <el-button class="btn-block" type="primary" size="mini" @click="onComplete()">完成</el-button>
          </el-col>
        </el-row>
      </div>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('RequirementOrdersModule');

  import RequirementOrderBaseForm from './RequirementOrderBaseForm';
  import RequirementOrderMediaUploadForm from './RequirementOrderMediaUploadForm';
  import RequirementOrderDeliveryAddressForm from './RequirementOrderDeliveryAddressForm';
  import RequirementOrderRequestForm from './RequirementOrderRequestForm';
  import RequirementOrderDetailsPage from './RequirementOrderDetailsPage';
  import RequirementOrderEntriesForm from './RequirementOrderEntriesForm';

  export default {
    name: 'RequirementOrderFrom',
    components: {
      RequirementOrderMediaUploadForm,
      RequirementOrderBaseForm,
      RequirementOrderDeliveryAddressForm,
      RequirementOrderRequestForm,
      RequirementOrderDetailsPage,
      RequirementOrderEntriesForm
    },
    props: ['slotData'],
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onSubmit() {
        this.$refs['deliveryAddressForm'].validate((valid) => {
            if (!valid) {
              return false;
            }

            const address = this.slotData.deliveryAddress;
            if (!address.region.isocode || !address.city.code) {
              this.$message.error('请输入省份和市区');
              return false;
            }

            if (!this.$refs['entriesForm'].validate(true)) {
              return false;
            }

            this.$refs['requestForm'].validate((valid) => {
                if (!valid) {
                  return false;
                }

                this._onSubmit();

                return true;
              }
            );

            return true;
          }
        );
      },
      async _onSubmit() {
        let formData = this.slotData;
        const result = await this.$http.post('/djbackoffice/requirementOrder/new', formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('需求订单创建成功，订单编号： ' + result);
        this.$set(this.slotData, 'code', result);
        this.active = 1;
        // this.refresh();
        this.$refs['detailsPage'].refresh();
      },
      onMediaUpload() {
        this.$refs['mediaUploadForm'].onSubmit();
      },
      onComplete() {
        this.fn.closeSlider(true);
      },
      onCancel() {
        this.fn.closeSlider();
      },
      onStep(active) {
        this.active = active;
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {
        active: 0
      }
    }
  }
</script>
