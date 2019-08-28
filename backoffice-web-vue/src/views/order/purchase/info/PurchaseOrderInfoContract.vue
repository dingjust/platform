<template>
  <div class="info-detail-staff-body">
    <el-row type="flex" justify="space-between" align="middle" class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">合同（待签署）</h6>
      </div>
      <el-button type="text" class="info-detail-logistics_info-btn2">签署合同</el-button>
    </el-row>
    <el-row type="flex" justify="center">
      <img src="static/img/word.png" class="info-img-word" alt="" />
    </el-row>
    <el-row type="flex" justify="center">
      <el-col :span="16">
        <h6 class="info-template-name">衣加衣电子合同</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'PurchaseOrderInfoContract',
    props: ['slotData'],
    components: {},
    mixins: [],
    computed: {

    },
    methods: {},
    data() {
      return {}
    },
    created() {}
  }

</script>
<style>
  .info-detail-staff-body {
    width: 100%;
    margin-top: 20px;
  }

  .info-row {
    margin-top: 5px;
  }

  .info-template-name {
    text-align: center;
    font-size: 12px;
  }

  .info-img-word {
    width: 50px;
    height: 50px;
    margin-bottom: 5px;
  }

</style>
