<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="production-order-list-title">
            <h6>生产任务明细</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6>任务单号：{{code}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>订单状态：{{getEnum('purchaseOrderStatuses', formData.status)}}</h6>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row class="production-order-basic-row">
        <production-order-top-info :slotData="formData" />
        <div style="margin-top: 50px" v-if="formData.materialsSpecEntries!=null">
          <el-row style="margin-top:20px;">
            <sample-attach-orders-form :entries.sync="formData.materialsSpecEntries" :medias.sync="formData.medias" :isRead="true"
              :productionProcessContent.sync="formData.productionProcessContent" :productsColors="colors" />
          </el-row>
        </div>
         <production-progress-order-info :slotData="formData" @refreshData="getDetail" />
        <production-order-relation-info :slotData="formData" />
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'ProductionOrderModule'
  );

  import ProductionOrderTopInfo from '../info/ProductionOrderTopInfo';
  import ProductionProgressOrderInfo from '../info/ProductionProgressOrderInfo';
  import ProductionOrderRelationInfo from '../info/ProductionOrderRelationInfo';
  import SampleAttachOrdersForm from '@/views/product/sample/form/SampleAttachOrdersForm';

  export default {
    name: 'ProductionOrderDetail',
    props: ['code'],
    components: {
      ProductionOrderRelationInfo,
      ProductionProgressOrderInfo,
      ProductionOrderTopInfo,
      SampleAttachOrdersForm,
    },
    computed: {
      ...mapGetters({
        formData: 'formData'
      }),
      colors: function () {
        var colors = [];
        if (this.formData.colorSizeEntries!= null) {
          this.formData.colorSizeEntries.forEach(entry => {
            let index = colors.findIndex(color => color.code == entry.color.code);
            if (index == -1) {
              colors.push(entry.color);
            }
          });
        }
        return colors;
      },
    },
    methods: {
      async getDetail() {
        const url = this.apis().getProductionOrderDetail(this.code);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$store.state.ProductionOrderModule.formData = Object.assign({}, result);
      },
    },
    data() {
      return {}
    },
    mounted() {},
    created() {
      this.getDetail();
    }
  }

</script>

<style scoped>
  .production-order-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
