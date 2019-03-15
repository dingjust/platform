<template>
  <div class="animated fadeIn">
    单价：<el-input-number v-model="basePrice"
                        @change="onPriceChanged">
  </el-input-number>，数量： {{totalQuantity}}，总价： {{totalPrice}}
  </div>
</template>

<script>
  export default {
    name: 'OrderEntriesSummaryForm',
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
    methods: {
      onPriceChanged(value) {
        this.$emit('onPriceChanged', value);
      }
    },
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
