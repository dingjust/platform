<template>
  <div class="animated fadeIn">
    <table class="table table-bordered">
      <thead>
      <tr>
        <th v-for="header in headers" scope="col">{{header}}</th>
      </tr>
      </thead>
      <tbody>
      <template v-for="variant in variants">
        <tr v-for="(size, index) in variant.sizes">
          <td v-if="index === 0" :rowspan="variant.sizes.length">{{variant.color.name}}</td>
          <td>{{size.name}}</td>
          <td>
            <el-input-number v-model="size.quantity"
                             :disabled="readOnly"
                             @change="onQuantityChanged">
            </el-input-number>
          </td>
        </tr>
      </template>
      </tbody>
      <tfoot>
      <tr>
        <td colspan="3">
          <slot name="summary"></slot>
        </td>
      </tr>
      </tfoot>
    </table>
  </div>
</template>

<script>
  export default {
    name: 'ApparelProductStockLevelInput',
    props: ['readOnly', 'variants'],
    components: {},
    mixins: [],
    computed: {},
    methods: {
      onQuantityChanged(value) {
        this.$emit('onQuantityChanged', value);
      }
    },
    data() {
      return {
        headers: ['颜色', '尺码', '数量'],
      }
    },
    created() {
    }
  }
</script>
