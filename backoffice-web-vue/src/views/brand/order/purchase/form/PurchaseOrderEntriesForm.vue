<template>
  <div class="animated fadeIn">
    <product-select v-if="!readOnly" @onSelected="onProductSelected"/>
    <apparel-product-stock-level-input v-if="variants.length"
                                       :read-only="readOnly"
                                       :variants="variants">
      <template slot='summary'>
        <purchase-order-entries-summary-form :read-only="readOnly"
                                             :variants="variants"
                                             :unit-price="unitPrice"/>
      </template>
    </apparel-product-stock-level-input>
  </div>
</template>

<script>
  import {ProductSelect, ApparelProductStockLevelInput} from "@/views/shared/";

  import PurchaseOrderEntriesSummaryForm from "./PurchaseOrderEntriesSummaryForm";

  export default {
    name: 'PurchaseOrderEntriesForm',
    props: ['slotData', 'readOnly'],
    components: {PurchaseOrderEntriesSummaryForm, ProductSelect, ApparelProductStockLevelInput},
    mixins: [],
    computed: {

    },
    methods: {
      onProductSelected(product) {
        console.log(JSON.stringify(product));

        this.variants = [
          {
            color: {
              code: 'C01',
              name: '红色'
            },
            sizes: [
              {
                code: 'S01',
                name: 'XL',
                quantity: 1
              },
              {
                code: 'S02',
                name: 'X',
                quantity: 2
              }
            ]
          },
          {
            color: {
              code: 'C02',
              name: '黄色'
            },
            sizes: [
              {
                code: 'S02',
                name: 'XXL',
                quantity: 1
              },
              {
                code: 'S03',
                name: 'X',
                quantity: 2
              }
            ]
          }
        ];
      }
    },
    data() {
      return {
        variants: [],
        unitPrice: 0
      }
    },
    created() {
    }
  }
</script>
