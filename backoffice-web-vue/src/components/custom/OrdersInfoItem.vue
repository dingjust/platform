<template>
  <el-row type="flex" justify="start">
    <h6 class="info-item-label">{{slotData}}:</h6>
    <h6 class="info-item-value">
    <slot></slot>
    </h6>
  </el-row>
</template>

<script>
  export default {
    name: "OrdersInfoItem",
    props: ['slotData'],
    components: {},
    computed: {},
    methods: {},
    data() {
      return {};
    },
    created() {}
  };

</script>
<style>
  .info-item-label {
    font-size: 10px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    margin-right: 7px;
  }

  .info-item-value {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

</style>
