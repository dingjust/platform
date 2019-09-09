<template>
  <div class="info-detail-body">
    <el-row class="info-detail-title-row">
      <div class="info-detail-title">
        <h6 class="info-title_text">合作商信息</h6>
      </div>
    </el-row>
    <el-row type="flex" justify="space-between" align="center" class="info-row">
      <orders-info-item :slotData="'合作商'">{{cooperator.name}}</orders-info-item>
    </el-row>
    <el-row type="flex" justify="space-between" align="center" class="info-row">
      <orders-info-item :slotData="'联系人'">{{cooperator.contactPerson}}</orders-info-item>
      <orders-info-item :slotData="'联系方式'">{{cooperator.contactPhone}}</orders-info-item>
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
      cooperator: function () {
        if (this.isBrand()) {
          if (this.slotData.belongTo != null) {
            return {
              name: this.slotData.belongTo.name,
              contactPerson: this.slotData.belongTo.contactPerson,
              contactPhone: this.slotData.belongTo.contactPhone
            };
          } else {
            return {
              name: this.slotData.companyOfSeller,
              contactPerson: this.slotData.contactPersonOfSeller,
              contactPhone: this.slotData.contactOfSeller
            };
          }
        } else {
          if (this.slotData.purchaser != null) {
            return {
              name: this.slotData.purchaser.name,
              contactPerson: this.slotData.purchaser.contactPerson,
              contactPhone: this.slotData.purchaser.contactPhone
            };
          } else {
            return {
              name: this.slotData.companyOfSeller,
              contactPerson: this.slotData.contactPersonOfSeller,
              contactPhone: this.slotData.contactOfSeller
            };
          }
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
