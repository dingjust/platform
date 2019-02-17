<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>订单</span>
      </div>
      <div class="pt-2"></div>
      <requirement-order-base-form ref="requirementOrderBase"
                                   :slot-data="slotData"
                                   :read-only="false">
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
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('BrandRequirementOrdersModule');

  import RequirementOrderBaseForm from './RequirementOrderBaseForm';
  import RequirementOrderMediaUploadForm from './RequirementOrderMediaUploadForm';
  import RequirementOrderDeliveryAddressForm from './RequirementOrderDeliveryAddressForm';
  import RequirementOrderRequestForm from './RequirementOrderRequestForm';
  import RequirementOrderDetailsPage from './RequirementOrderDetailsPage';
  import RequirementOrderEntriesForm from './RequirementOrderEntriesForm';

  import {OrderMixin} from '../../../../mixins';

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
    mixins: [OrderMixin],
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
      onCancel() {
        this.fn.closeSlider();
      },
      async _onSubmit() {
        let formData = this.slotData;
        const result = await this.$http.post('/djbrand/processes/requirementOrder/publish/nosku', formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('发布需求成功，订单编号： ' + result);
        this.$set(this.slotData, 'code', result);
        this.fn.closeSlider(true);
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {}
    }
  }
</script>
