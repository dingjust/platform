<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="sales-plan-form-title">
            <h6>生产任务明细</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <!-- <h6>任务单号:&#12288;{{formData.entries[0].productionTask.code}}</h6> -->
        </el-col>
        <el-col :span="6">
          <!-- <h6>订单状态:&#12288;{{getEnum('ProductionState', scope.row.state)}}</h6> -->
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <receiving-details-form :slotData="formData"/>
      <div style="margin-top: 50px" v-if="formData.entries[0]!=null">
        <el-row style="margin-top:20px;">
          <sample-attach-orders-form :entries.sync="formData.entries[0].materialsSpecEntries"
            :medias.sync="formData.entries[0].medias" :isRead="true"
            :productionProcessContent.sync="formData.entries[0].productionProcessContent" :productsColors="colors" />
        </el-row>
        <accounting-sheet-btn :slotData="formData.entries[0].costOrder" :unitPrice="formData.entries[0].unitPrice"
                              :isOutboundRead="isOutboundRead"/>
      </div>
      <div v-if="!isOutboundRead">
        <production-task :slotData="formData.entries[0].productionTask" ref="taskComp" v-if="formData.entries[0]!=null"
          :productionLeader="formData.productionLeader" :readOnly="true" />
      </div>
      <div style="margin-top:40px">
        <el-row>
          <el-col :span="4">关联订单</el-col>
        </el-row>
        <context-info-tab style="margin-top:20px" :dispatchOrders="[]" :purchaseOrders="[]" :profitOrders="[]"
          :logs="[]" />
      </div>
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
    'ProductionTasksModule'
  );


  import ReceivingDetailsForm from '../form/ReceivingDetailsForm';
  import ProductionTask from '../../components/ProductionTask';
  import ContextInfoTab from '../../components/context-order-tab/ContextInfoTab';
  import SampleAttachOrdersForm from '@/views/product/sample/form/SampleAttachOrdersForm';
  import AccountingSheetBtn from '@/views/product/sample/components/AccountingSheetBtn';

  export default {
    name: 'ProductionTaskDetails',
    props: {
      id: {
        require: true
      },
      isOutboundRead: {
        type: Boolean,
        default: false
      }
    },
    components: {
      ReceivingDetailsForm,
      ProductionTask,
      SampleAttachOrdersForm,
      AccountingSheetBtn,
      ContextInfoTab
    },
    computed: {
      ...mapGetters({
        formData: 'formData'
      }),
      colors: function () {
        var colors = [];
        if (this.formData.entries[0] != null) {
          this.formData.entries[0].colorSizeEntries.forEach(entry => {
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
      async getDetails() {
        const url = this.apis().getProductionTaskDetails(this.id);
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$store.state.ProductionTasksModule.formData = Object.assign({}, result.data);
      },
      onConfirm() {

      },
      onCreate() {}
    },
    data() {
      return {

      }
    },
    created() {
      this.getDetails();
    }
  }

</script>

<style scoped>
  .sales-plan-form-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .purchase-product-img {
    width: 120px;
    height: 120px;
    border-radius: 10px;
    margin-right: 20px;
  }

  .info-basic-row {
    margin-top: 10px;
  }

  .border-container {
    border: 1px solid #DCDFE6;
    border-radius: 5px;
    padding-top: 10px;
  }

  .production-task-btn {
    background-color: #ffd60c;
    border-color: #DCDFE6;
    width: 100px;
    height: 40px;
    color: #606266;
  }

</style>
