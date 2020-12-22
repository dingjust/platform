<template>
  <div class="pp-order-top">
    <el-row type="flex" justify="space-between" align="middle">
      <el-col :span="4">
        <h6 style="margin-bottom: 0px;margin-top: 2px;">生产进度工单</h6>
      </el-col>
      <el-col :span="2">
        <authorized :permission="['PROGRESS_WORK_ORDER_CREATE']">
          <el-button class="pp-edit-btn" @click="onEdit" v-if="canEdit">编辑</el-button>
        </authorized>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" class="pp-basic-row">
      <el-col :span="23">
        <el-card>
          <production-progress-node v-if="hasData" :slotData="slotData" :canEdit="canEdit" @callback="onCallBack" />
          <el-row v-else type="flex" justify="center">暂无数据</el-row>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import ProductionProgressNode from './ProductionProgressNode';
  export default {
    name: 'ProgressOrder',
    components: {
      ProductionProgressNode
    },
    props: {
      slotData: {
        type: Object,
        default: () => {
          return {
            code: '',
            creationtime: '',
            expectedDeliveryDate: '',
            id: '',
            machiningType: "",
            modifiedtime: '',
            partyACompany: '',
            partyBCompany: '',
            personInCharge: '',
            progresses: [],
            skuID: "",
          };
        }
      },
      order: {
        type: Object
      },
      formData: {
        type: Object
      }
    },
    computed: {
      hasData: function () {
        if (this.slotData != null && this.slotData.code != null && this.slotData.code != '') {
          return true;
        } else {
          return false;
        }
      },
      canEdit: function () {
        if (this.order != null) {
          let isOperator = false;
          let operators = [
            this.order.merchandiser ? this.order.merchandiser.uid : '',
            this.order.productionLeader ? this.order.productionLeader.uid : '',
            this.order.personInCharge ? this.order.personInCharge.uid : ''
          ];
          isOperator = operators.findIndex(item => item == this.$store.getters.currentUser.uid) != -1;
          return (this.order.state == 'TO_BE_PRODUCED' ||
            this.order.state == 'PRODUCING' ||
            this.order.state == 'IN_PRODUCTION') && isOperator
        }
      }
    },
    methods: {
      onEdit() {
        // this.$router.push('/sales/progressOrder/' + this.slotData.code);        
        if (this.slotData.code != null && "" != this.slotData.code) {
          this.$router.push('/sales/progressOrder/' + this.slotData.code + '/edit');
        } else if (this.slotData.code == '') {
          this.$router.push({
            name: '创建进度工单',
            params: {
              order: this.formData
            }
          })
        }
      },
      onCallBack(data) {
        this.$emit('callback', data);
      }
    },
    created() {}
  }

</script>

<style scoped>
  .pp-order-top {
    margin-top: 20px;
  }

  .pp-edit-btn {
    width: 90px;
  }

  .pp-basic-row {
    margin-top: 20px;
  }

</style>
