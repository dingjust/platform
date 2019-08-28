<template>
  <div class="info-detail-body">
    <el-row class="info-detail-title-row">
      <div class="info-detail-title">
        <h6 class="info-title_text">合作商信息</h6>
      </div>
    </el-row>
    <el-row type="flex" justify="space-between" align="center" class="info-row">
      <orders-info-item :slotData="'合作商'">{{name}}</orders-info-item>
    </el-row>
    <el-row type="flex" justify="space-between" align="center" class="info-row">
      <orders-info-item :slotData="'联系人'">{{contactPerson}}</orders-info-item>
      <orders-info-item :slotData="'联系方式'">{{contactPhone}}</orders-info-item>
    </el-row>
  </div>
</template>

<script>
  import OrdersInfoItem from '@/components/custom/OrdersInfoItem';

  export default {
    name: 'PurchaseOrderInfoSupplier',
    props: ['slotData'],
    components: {
      OrdersInfoItem,
    },
    mixins: [],
    computed: {
      name: function () {
        if (this.slotData.purchaser != null) {
          return this.slotData.purchaser.name;
        } else {
          return this.slotData.companyOfSeller;
        }
      },
      contactPerson: function () {
        if (this.slotData.purchaser != null) {
          return this.slotData.purchaser.contactPerson;
        } else {
          return this.slotData.contactPersonOfSeller;
        }
      },
      contactPhone: function () {
        if (this.slotData.purchaser != null) {
          return this.slotData.purchaser.contactPhone;
        } else {
          return this.slotData.contactOfSeller;
        }
      }
    },
    methods: {},
    data() {
      return {}
    },
    created() {}
  }

</script>
<style>
  .info-detail-body {
    width: 100%;

  }

  .info-detail-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
  }

  .info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.85;
  }

  .info-row {
    margin-top: 5px;
  }

</style>
