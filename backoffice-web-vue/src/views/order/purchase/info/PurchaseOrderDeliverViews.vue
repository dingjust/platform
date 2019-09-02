<template>
  <div class="info-receive-body">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">查看发货单</h6>
      </div>
    </el-row>
    <el-tabs v-model="activeOrder" type="card">
      <template v-for="(order,index) in slotData.shippingOrders">
        <el-tab-pane :label="''+(index+1)" :name="order.code">
          <deliver-view :slotData="order" />
        </el-tab-pane>
      </template>
    </el-tabs>
    <el-row type="flex" justify="end" class="info-receive-row">
      <h6 class="order-table-info">品牌跟单员： xxx</h6>
      <h6 class="order-table-info">工厂跟单员： {{slotData.user.name}}</h6>
      <h6 class="order-table-info">发货日期： {{slotData
        .creationtime | timestampToTime}}</h6>
    </el-row>
  </div>
</template>

<script>
  import OrdersInfoItem from '@/components/custom/OrdersInfoItem';
  import FormLabel from '@/components/custom/FormLabel';
  import DeliverView from '../components/DeliverView';
  import Bus from '@/common/js/bus.js';

  export default {
    name: 'PurchaseOrderInfoDeliver',
    props: ['slotData'],
    components: {
      OrdersInfoItem,
      FormLabel,
      DeliverView
    },
    mixins: [],
    computed: {
      sizes: function () {
        var sizes = new Set([]);
        this.slotData.entries.forEach(element => {
          sizes.add(element.product.size.name);
        });
        return sizes;
      },
      colors: function () {
        var colors = new Set([]);
        this.slotData.entries.forEach(element => {
          colors.add(element.product.color.name);
        });
        return colors;
      },
      totalAmout: function () {
        var totalAmount = 0;
        this.form.entries.forEach(sizeArray => {
          sizeArray.forEach(item => {
            if (item.num != '') {
              totalAmount += parseInt(item.num);
            }
          })
        });
        return totalAmount;
      }
    },
    methods: {
      countRowAmount(rowIndex) {
        var amount = 0;
        this.form.entries[rowIndex].forEach(element => {
          if (element.num != '') {
            let num = parseInt(element.num);
            amount = amount + num;
          }
        });
        return amount;
      },
      getColspanLength() {
        return this.colors.size + 2;
      },
      async onSubmit() {
        //组合订单行参数
        var entries = [];
        this.form.entries.forEach(variants => {
          variants.forEach(variant => {
            if (variant.num != '' && variant.num > 0) {
              let item = {
                quantity: variant.num,
                color: variant.color,
                size: variant.size
              }
              entries.push(item);
            }
          })
        });
        //表单参数
        var form = {
          withdrawalQuality: this.form.returnNum,
          defectiveQuality: this.form.imperfectionsNum,
          consignorName: this.form.consignorName,
          consignorPhone: this.form.consignorPhone,
          consigneeName: this.form.consigneeName,
          consigneePhone: this.form.consigneePhone,
          consigneeAddress: this.form.consigneeAddress,
          isOfflineConsignment: this.form.isOfflineConsignment,
          entries: entries,
          remarks: this.form.remarks
        };

        const url = this.apis().createShippingOrder(this.slotData.code);
        const result = await this.$http.post(url, form);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('创建成功');
        //刷新数据
        this.refreshData();
      },
      async refreshData() {
        const url = this.apis().getPurchaseOrder(this.slotData.code);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$set(this, 'slotData', result);
        Bus.$emit('msg', '我要传给兄弟组件们，你收到没有')
        // this.slotData=result;
      }
    },
    data() {
      return {
        receiveFormVisible: false,
        activeForm: '1',
        mockData: [],
        form: {
          consignorName: "",
          consignorPhone: "",
          receiveCode: "",
          isOfflineConsignment: false,
          consigneeName: "",
          consigneePhone: "",
          consigneeAddress: "",
          productBrandName: "",
          productSKU: "",
          remarks: "",
          imperfectionsNum: '',
          returnNum: '',
          deliverWay: '',
          entries: []
        },
        activeOrder:this.slotData.shippingOrders[0].code
      }
    },
    created() {
      //初始化表格
      this.form.entries = [];
      this.colors.forEach(color => {
        var sizeArray = [];
        this.sizes.forEach(size => {
          sizeArray.push({
            'size': size,
            'color': color,
            'num': '',
          })
        });
        this.form.entries.push(sizeArray);
      });
    },
    watch: {
      colors: {
        handler(val, oldVal) {
          this.form.entries = [];
          this.colors.forEach(color => {
            var sizeArray = [];
            this.sizes.forEach(size => {
              sizeArray.push({
                'size': size,
                'color': color,
                'num': '',
              })
            });
            this.form.entries.push(sizeArray);
          });
        },
        deep: true
      },
      sizes: {
        handler(val, oldVal) {
          this.form.entries = [];
          this.colors.forEach(color => {
            var sizeArray = [];
            this.sizes.forEach(size => {
              sizeArray.push({
                'size': size,
                'color': color,
                'num': '',
              })
            });
            this.form.entries.push(sizeArray);
          });
        },
        deep: true
      }
    },
    mounted() {}
  }

</script>
<style>
  .info-receive-body {
    width: 100%;
  }

  .info-receive-row {
    margin-bottom: 20px;
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    width: 80px;
    font-weight: bold;
    font-size: 12px;
  }

  .info-row_width50 {
    width: 50%;
  }

  .checkbox-text .el-checkbox__label {
    font-size: 12px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.45);
  }

  .order-table {
    /* width: 600px;
    height: 600px; */
    border-collapse: collapse;
    margin-bottom: 20px;
  }

  .order-table tr td,
  .order-table tr th {
    border: 1px solid rgba(0, 0, 0, 0.15);
    text-align: center;
    height: 50px;
    font-size: 10px;
  }

  /* .order-table-th_row {
    height: 80px;
  } */

  .order-table-input .el-input__inner {
    /* width: 60px; */
    border: 0px solid #fff;
  }

  .order-table-btn {
    padding-left: 10px;
    width: 30px;
  }

  .order-table-info {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    margin-left: 20px;
  }

  .order-table-btn_add {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
  }

  .info-receive-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
  }

</style>
