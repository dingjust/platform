<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>销售订单</span>
      </div>
      <order-base-form ref="orderBaseForm"
                       :slot-data="slotData"
                       :read-only="false">
      </order-base-form>
      <hr/>
      <order-delivery-address-form ref="orderDeliveryAddressForm"
                                   :slot-data="slotData"
                                   :read-only="false">
      </order-delivery-address-form>
      <hr/>
      <order-entries-form ref="orderEntriesForm" :slot-data="slotData" :read-only="false"/>
      <div class="pt-2"></div>
      <el-row :gutter="10">
        <el-col :span="12">
          <el-button class="btn-block" type="primary" size="mini" @click="onComplete">提交</el-button>
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

  const {mapActions} = createNamespacedHelpers('SalesOrdersModule');

  import OrderBaseForm from './OrderBaseForm';
  import OrderEntriesForm from './OrderEntriesForm';
  import OrderDeliveryAddressForm from './OrderDeliveryAddressForm';
  import OrderDetailsPage from './OrderDetailsPage';

  export default {
    name: 'OrderForm',
    components: {OrderBaseForm, OrderEntriesForm, OrderDeliveryAddressForm, OrderDetailsPage},
    props: ['slotData'],
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onCancel() {
        this.fn.closeSlider();
      },
      onStep(active) {
        this.active = active;
      },
      onUpdateBase() {
        this.active = 1;
      },
      onAddEntries() {
        this.$refs['orderBaseForm'].validate((valid) => {
          if (valid) {
            if (!this.$refs['orderEntriesForm'].validate()) {
              return;
            }

            this.active = 2;

            return true;
          }

          return false;
        });
      },
      onAddAddress() {
        this.$refs['orderDeliveryAddressForm'].validate((valid) => {
            if (!valid) {
              return false;
            }

            this.active = 3;

            this.$refs['orderDetailsPage'].refresh();

            return true;
          }
        );
      },
      onComplete() {
        this.$refs['orderBaseForm'].validate((valid) => {
          if (valid) {
            if (!this.$refs['orderEntriesForm'].validate()) {
              return;
            }

            this.$refs['orderDeliveryAddressForm'].validate((valid) => {
                if (!valid) {
                  return false;
                }

                const address = this.slotData.deliveryAddress;
                if (!address.region.isocode || !address.city.code) {
                  this.$message.error('请输入省份和市区');
                  return false;
                }

                this._onSubmit();

                return true;
              }
            );

            return true;
          }

          return false;
        });
      }
    },
    async _onSubmit() {
      let formData = this.slotData;

      const result = await this.$http.post('/djbackoffice/salesOrder', formData);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.$message.success('订单创建成功，订单编号： ' + result);
      this.refresh();
      this.fn.closeSlider(true);
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
