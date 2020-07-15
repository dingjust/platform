<template>
  <div class="animated fadeIn content">
    <el-card>
      <div class="sales-plan-triangle_box" v-if="isMySelf">
        <div class="sales-plan-triangle" :style="isShowTag ? '#ffd60c': '#ffffff'">
          <h6 class="sales-plan-triangle_text">{{orderType}}</h6>
        </div>
      </div>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="production-order-list-title">
            <h6>生产工单明细</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6>工单号：{{formData.taskOrderEntries!=null?formData.taskOrderEntries[0].code:''}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>订单状态：{{orderState}}</h6>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row class="production-order-basic-row">
        <production-order-top-info :slotData="formData" />
        <!-- <div style="margin-top: 50px" v-if="formData.materialsSpecEntries!=null">
          <el-row style="margin-top:20px;">
            <sample-attach-orders-form :entries.sync="formData.materialsSpecEntries" :medias.sync="formData.medias"
              :isRead="true" :productionProcessContent.sync="formData.productionProcessContent"
              :productsColors="colors" />
          </el-row>
        </div> -->
        <progress-order :slotData="progressOrder" :order="productionOrder" @callback="onCallBack" :formData="formData"/>
        <production-order-relation-info :slotData="formData" :id="id"/>
        <!-- <production-order-button-group style="margin-top:50px" :slotData="formData" @callback="getDetail" /> -->
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
  import ProgressOrder from '../../components/progress-order';
  import ProductionOrderRelationInfo from '../info/ProductionOrderRelationInfo';
  import ProductionOrderButtonGroup from '../info/ProductionOrderButtonGroup';
  import SampleAttachOrdersForm from '@/views/product/sample/form/SampleAttachOrdersForm';

  export default {
    name: 'ProductionOrderDetail',
    props: ['id'],
    components: {
      ProductionOrderRelationInfo,
      ProgressOrder,
      ProductionOrderTopInfo,
      SampleAttachOrdersForm,
      ProductionOrderButtonGroup
    },
    computed: {
      ...mapGetters({
        formData: 'formData'
      }),
      colors: function () {
        var colors = [];
        if (this.formData.colorSizeEntries != null) {
          this.formData.colorSizeEntries.forEach(entry => {
            let index = colors.findIndex(color => color.code == entry.color.code);
            if (index == -1) {
              colors.push(entry.color);
            }
          });
        }
        return colors;
      },
      //生产进度工单
      progressOrder: function () {
        if (this.formData.taskOrderEntries != null && this.formData.taskOrderEntries.length > 0) {
          return this.formData.taskOrderEntries[0].progressWorkSheet;
        } else {
          return null;
        }
      },
      // 生产工单
      productionOrder: function () {
        if (this.formData.taskOrderEntries != null && this.formData.taskOrderEntries.length > 0) {
          return this.formData.taskOrderEntries[0];
        } else {
          return null;
        }
      },
      orderType: function () {
        if (!this.formData.taskOrderEntries) {
          return;
        }
        if (this.formData.taskOrderEntries[0].type == 'SELF_PRODUCED') {
          this.isShowTag = true;
          return '自\xa0\xa0\xa0\xa0\xa0产';
        } else if (this.formData.taskOrderEntries[0].type == 'FOUNDRY_PRODUCTION' && this.formData.taskOrderEntries[0].outboundOrderCode) {
          this.isShowTag = true; 
          return '已外发'; 
        } else {
          this.isShowTag = false;
        }
      },
      isMySelf: function () {
        if (!this.formData.taskOrderEntries) {
          return;
        }
        return this.formData.taskOrderEntries[0].belongTo.uid == this.$store.getters.currentUser.companyCode;
      },
      orderState: function () {
        if (!this.formData.taskOrderEntries) {
          return;
        }
        if (this.formData.taskOrderEntries[0].state == 'TO_BE_ALLOCATED') {
          return this.isMySelf ? '待分配' : '待生产';
        }
        return this.getEnum('ProductionTaskOrderState', this.formData.taskOrderEntries[0].state)
      }
    },
    methods: {
      async getDetail(id) {
        const url = this.apis().getProductionOrderDetail(id);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$store.state.ProductionOrderModule.formData = Object.assign({}, result.data);
      },
      onCallBack(data) {
        if (data != null) {
          this.$store.state.ProductionOrderModule.formData = Object.assign({}, data);
        } else {
          this.getDetail(this.id);
        }
      }
    },
    data() {
      return {
        isShowTag: false
      }
    },
    mounted() {

    },
    created() {
      this.getDetail(this.id);
    },
    beforeRouteUpdate (to, from, next) {
      if (to.name === from.name && to.params.id != from.params.id) {
        this.getDetail(to.params.id);
      }
      next();
    },
  }

</script>

<style scoped>
  .production-order-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .sales-plan-triangle_box {
    margin-top: 1px;
    position: absolute;
    right: 0;
    top: 0;
  }

  .sales-plan-triangle {
    width: 0;
    height: 0;
    border-right: 70px solid #ffffff;
    border-bottom: 70px solid transparent;
    z-index: 0;
  }

  .sales-plan-triangle_text {
    width: 80px;
    padding-top: 10px;
    padding-left: 35px;
    transform: rotateZ(45deg);
    color: white;
    font-size: 12px;
  }
</style>
