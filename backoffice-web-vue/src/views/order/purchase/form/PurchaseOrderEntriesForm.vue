<template>
  <div class="animated fadeIn">
    <product-select v-if="!readOnly" @onSelected="onProductSelected"/>
    <apparel-product-stock-level-input v-if="variants.length"
                                       :read-only="readOnly"
                                       :variants="variants"
                                       @onQuantityChanged="onQuantityChanged">
      <template slot='summary'>
        <order-entries-summary-form :read-only="readOnly"
                                    :variants="variants"
                                    :unit-price="slotData.unitPrice"
                                    @onPriceChanged="onPriceChanged"/>
      </template>
    </apparel-product-stock-level-input>
  </div>
</template>

<script>
  import {
    ProductSelect,
    ApparelProductStockLevelInput,
    OrderEntriesSummaryForm
  } from "@/views/shared/";

  export default {
    name: 'PurchaseOrderEntriesForm',
    props: ['slotData', 'readOnly'],
    components: {
      ProductSelect,
      ApparelProductStockLevelInput,
      OrderEntriesSummaryForm,
    },
    mixins: [],
    computed: {},
    methods: {
      onProductSelected(product) {
        // console.log(JSON.stringify(product));

        this.initializeVariantsFormProduct(product);
        this._updateEntries();
        console.log('entries:' + JSON.stringify(this.slotData.entries));
      },
      onQuantityChanged(value) {
        // console.log('value: ' + value);
        this._updateQuantityOfEntries();
      },
      onPriceChanged(value) {
        // console.log('value: ' + value);

        this.$set(this.slotData, 'unitPrice', value);

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
        const code = product.code;
        const color = product.color;
        const size = product.size;

        const _variants = [...this.variants];
        this._updateVariants(_variants, color, size, quantity, code);
      },
      _updateVariants(_variants, color, size, quantity, code) {
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
            productCode: code,
            code: size.code,
            name: size.name,
            quantity: quantity
          });

          return;
        }

        this.variants.push({
          color: color,
          sizes: [{
            productCode: code,
            code: size.code,
            name: size.name,
            quantity: quantity
          }]
        });
      },
      _updateQuantityOfEntries() {
        this.$set(this.slotData, 'entries', []);
        // 使用variants同步更新slotData.entries中的数量
        console.log('variants: ' + JSON.stringify(this.variants));

        this._updateEntries();

        console.log('entries:' + JSON.stringify(this.slotData.entries));
      },
      _updatePriceOfEntries() {
        this.$set(this.slotData, 'entries', []);
        // 使用variants同步更新slotData.entries中的单价
        console.log('variants: ' + JSON.stringify(this.variants));

        this._updateEntries();

        console.log('entries:' + JSON.stringify(this.slotData.entries));
      },
      _updateEntries() {
        let entries = [];

        let entryNumber = 0;
        for (let variant of this.variants) {
          for (let size of variant.sizes) {
            entries.push({
              entryNumber: entryNumber,
              quantity: size.quantity,
              basePrice: this.slotData.unitPrice,
              product: {
                code: size.productCode
              }
            });

            entryNumber++;
          }
        }

        this.$set(this.slotData, 'entries', entries);
      }
    },
    data() {
      return {
        variants: []
      }
    },
    created() {
      this.initializeVariantsFromSlotData();
    }
  }
</script>
