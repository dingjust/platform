<template>
  <div class="outbound-order-table">
    <div>
      <img :src="product.product.thumbnail ? product.product.thumbnail.url : 'static/img/nopicture.png'"
        style="width: 100px;height: 100px;border-radius: 8px;" />
      <el-row type="flex" justify="center" style="margin-top:10px">
        <h6 :title="product.product.skuID" class="table-title">货号：{{product.product.skuID}}</h6>
      </el-row>
    </div>
    <div style="margin-left: 20px;width: 100%">
      <color-size-table :data="product.colorSizeEntries" :readOnly="!isFromProduct"
        :hideEmptyColors="!isFromProduct" />
    </div>
  </div>
</template>

<script>
  import {
    ColorSizeTable
  } from '@/components'
  export default {
    name: 'OutboundOrderColorSizeTable',
    props: {
      product: {
        required: true
      },
      isFromProduct: {
        type: Boolean,
        default: false
      }
    },
    components: {
      ColorSizeTable
    },
    computed: {},
    methods: {}
  }

</script>

<style scoped>
  /deep/ .el-table--enable-row-hover .el-table__body tr:hover>td {
    background-color: #FFFFFF !important;
  }

  .outbound-order-table {
    margin-left: 30px;
    display: flex;
    justify-content: flex-start;
    align-items: flex-start;
  }

  .table-title {
    width: 100px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

</style>
