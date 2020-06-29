<template>
  <div class="pp-order-top">
    <el-row type="flex" justify="space-between" align="middle">
      <el-col :span="4">
        <h6 style="margin-bottom: 0px;margin-top: 2px;">生产进度工单</h6>
      </el-col>
      <el-col :span="2">
        <el-button class="pp-edit-btn" @click="onEdit">编辑</el-button>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" class="pp-basic-row">
      <el-col :span="23">
        <el-card>
          <production-progress-node v-if="hasData" :slotData="slotData"
            @callback="onCallBack" />
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
      }
    },
    computed: {
      hasData: function () {
        if (this.slotData != null && this.slotData.code != null && this.slotData.code != '') {
          return true;
        } else {
          return false;
        }
      }
    },
    methods: {
      onEdit() {
        // this.$router.push('/sales/progressOrder/' + this.slotData.code);        
        if (this.slotData.code != null && "" != this.slotData.code) {
          this.$router.push('/sales/progressOrder/' + this.slotData.code + '/edit');

        }
      },
      onCallBack() {
        this.$emit('callback');
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
