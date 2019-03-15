<template>
  <div class="animated fadeIn">
    <product-select v-if="!readOnly" @onSelected="onProductSelected"/>
    <apparel-product-stock-level-input v-if="variants.length"
                                       :read-only="readOnly"
                                       :variants="variants"
                                       @onQuantityChanged="onQuantityChanged">
      <template slot='summary'>
        <purchase-order-entries-summary-form :read-only="readOnly"
                                             :variants="variants"
                                             :unit-price="unitPrice"
                                             @onPriceChanged="onPriceChanged"/>
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
    components: {
      ProductSelect,
      ApparelProductStockLevelInput,
      PurchaseOrderEntriesSummaryForm,
    },
    mixins: [],
    computed: {},
    methods: {
      onProductSelected(product) {
        // console.log(JSON.stringify(product));

        this.initializeVariantsFormProduct(product);

        // console.log('variants: ' + JSON.stringify(this.variants));
      },
      onQuantityChanged(value) {
        console.log('value: ' + value);
        this._updateQuantityOfEntries();
      },
      onPriceChanged(value) {
        console.log('value: ' + value);
        this._updatePriceOfEntries();
      },
      initializeVariantsFormProduct(product) {
        this.variants = [];

        for (let variant of product.variants) {
          this._initializeVariantsFormVariantProduct(variant, 1)
        }
      },
      initializeVariantsFromSlotData() {
        this.variants = [];
        let entries = this.slotData.entries || [];

        for (let entry of entries) {
          const quantity = entry.quantity;

          this._initializeVariantsFormVariantProduct(entry.product, quantity);
        }
      },
      _initializeVariantsFormVariantProduct(product, quantity) {
        const color = product.color;
        const size = product.size;

        const _variants = [...this.variants];
        this._updateVariants(_variants, color, size, quantity);
      },
      _updateVariants(_variants, color, size, quantity) {
        let index = -1;
        for (let i = 0; i < _variants.length; i++) {
          let variant = _variants[i];
          if (variant.color.code === color.code) {
            index = i;
            break;
          }
        }

        // 已存在
        if (index !== -1) {
          this.variants[index].sizes.push({
            code: size.code,
            name: size.name,
            quantity: quantity
          });

          return;
        }

        this.variants.push({
          color: color,
          sizes: [{
            code: size.code,
            name: size.name,
            quantity: quantity
          }]
        });
      },
      _updateQuantityOfEntries() {
        // TODO: 使用variants同步更新slotData.entries中的数量
      },
      _updatePriceOfEntries() {
        // TODO: 使用variants同步更新slotData.entries中的单价
      }
    },
    data() {
      return {
        variants: [],
        unitPrice: 0
      }
    },
    created() {
      this.initializeVariantsFromSlotData();
    }
  }
</script>
