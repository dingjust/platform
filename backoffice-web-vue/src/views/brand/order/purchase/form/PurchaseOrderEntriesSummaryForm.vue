<template>
  <div class="animated fadeIn">
    生产单价：
    <el-input-number v-model="basePrice"></el-input-number>
    ，生产数量： {{totalQuantity}}，生产总价： {{totalPrice}}
  </div>
</template>

<script>
  export default {
    name: 'PurchaseOrderEntriesSummaryForm',
    props: ['variants', 'readOnly', 'unitPrice'],
    mixins: [],
    computed: {
      totalPrice: function () {
        return this.basePrice * this.totalQuantity;
      },
      totalQuantity: function () {
        let result = 0;

        for (let variant of this.variants) {
          for (let size of variant.sizes) {
            result += size.quantity;
          }
        }

        return result;
      }
    },
    methods: {},
    data() {
      return {
        basePrice: 0
      }
    },
    created() {
      this.basePrice = this.unitPrice || 0;
    }
  }
</script>
