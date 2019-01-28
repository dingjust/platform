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
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    name: 'ConsignmentOrderSearchForm',
    props: ['slotData'],
    components: {},
    methods: {
      validate (callback) {
        this.$refs['form'].validate(callback);
      },
      onFilter (query) {
        this.orders = [];
        if (query !== '') {
          axios.get('/djbackoffice/order', {
            params: {
              code: query
            }
          }).then(response => {
            this.orders = response.data.content;
          }).catch(error => {
            console.log(JSON.stringify(error));
            this.$message.error(error.response.data);
          }).finally(() => {
            this.loading = false;
          });
        }
      },
      onOrderSelected (current) {
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

          console.log('consignmentEntries: ' + JSON.stringify(consignmentEntries));

          this.$set(slotData, 'consignmentEntries', consignmentEntries);
        });
      }
    },
    computed: {},
    data () {
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
