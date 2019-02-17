<template>
  <div class="animated fadeIn">
    <div class="pt-2"></div>
    <el-form ref="form">
      <el-form-item label="">
        <el-select class="w-100"
                   placeholder="请输入订单编号查询"
                   filterable
                   remote
                   reserve-keyword
                   v-model="slotData.order.code"
                   :remote-method="onFilter"
                   :loading="loading"
                   @change="onOrderSelected">
          <el-option
            v-for="item in orders"
            :key="item.code"
            :label="item.code"
            :value="item.code">
          </el-option>
        </el-select>
      </el-form-item>
    </el-form>
    <div class="pt-2"></div>
    <order-details-page ref="orderDetailsPage"
                        v-show="showDetails"
                        :slot-data="order"
                        :read-only="true">
    </order-details-page>
  </div>
</template>

<script>
  import OrderDetailsPage from '../order/OrderDetailsPage';

  export default {
    name: 'ConsignmentOrderSearchForm',
    props: ['slotData'],
    components: {OrderDetailsPage},
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
      async onFilter(query) {
        this.orders = [];
        if (query !== '') {
          const result = await this.$http.get('/djbackoffice/order', {
            code: query
          });
          if (result["errors"]) {
            this.$message.error(result["errors"][0].message);
            return;
          }

          this.orders = result.content;
        }
      },
      onOrderSelected(current) {
        const slotData = this.slotData;
        this.orders.filter(value => {
          return current === value.code;
        }).forEach(order => {
          this.showDetails = true;
          this.order = order;
          this.$set(slotData, 'order', order);

          let consignmentEntries = [];

          order.entries.forEach(entry => {
            consignmentEntries.push({
              orderEntry: entry,
              quantity: entry.quantity,
              shippedQuantity: entry.quantity,
              price: entry.basePrice,
              tailorQuantity: 0
            });
          });

          this.$set(slotData, 'consignmentEntries', consignmentEntries);
        });
      }
    },
    computed: {},
    data() {
      return {
        text: '',
        showDetails: false,
        order: {
          deliveryAddress: {
            fullname: '',
            title: {
              code: '',
              name: ''
            },
            region: {
              isocode: '',
              name: ''
            },
            city: {
              code: '',
              name: ''
            },
            cityDistrict: {
              code: '',
              name: ''
            },
            line1: '',
            remarks: ''
          }
        },
        orders: [],
        loading: false
      }
    }
  }
</script>
