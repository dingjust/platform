<!--
* @Description: 样衣详情关联成本模块
* @Date 2021/03/29 18:07
* @Author L.G.Y
-->
<template>
  <div>
    <el-row class="basic-form-row" type="flex" align="middle">
      <el-col :span="2">
        <h6 class="info-input-prepend">关联成本单</h6>
      </el-col>
      <el-col :span="20">
        <el-tag
          v-for="tag in costList.filter(item => item.status !== 'CANCELLED')"
          :key="tag.id"
          closable
          @close="handleClose(tag)"
          type="info">
          <el-button type="text" class="tag-btn" @click="onCostDetail(tag)">{{tag.title}}</el-button>
        </el-tag>
        <el-button @click="onCreateCost">创建成本单</el-button>
      </el-col>
    </el-row>
    <!-- <el-dialog :visible.sync="formVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <cost-order-form v-if="formVisible" :product="product" @callback="searchCostOrderBySkuID"/>
    </el-dialog> -->
    <el-dialog :visible.sync="detailVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <cost-order-detail v-if="detailVisible" :id="costId" :isFormDialog="true" @callback="callback"/>
    </el-dialog>
  </div>
</template>

<script>
import CostOrderForm from '@/views/purchase/cost/form/CostOrderForm'
import CostOrderDetail from '@/views/purchase/cost/details/CostOrderDetail'
export default {
  name: 'SampleProductCostPart',
  props: ['slotData'],
  components: {
    CostOrderForm,
    CostOrderDetail
  },
  computed: {
    product: function () {
      return {
        id: this.slotData.id,
        code: this.slotData.code,
        skuID: this.slotData.skuID
      }
    }
  },
  data () {
    return {
      formVisible: false,
      detailVisible: false,
      costList: []
    }
  },
  methods: {
    async searchCostOrderBySkuID () {
      const url = this.apis().searchCostOrderBySkuID(this.slotData.skuID);
      const result = await this.$http.post(url, {});

      if (!result['errors']) {
        this.costList = result.data;
      }
      this.formVisible = false;
    },
    onCreateCost () {
      this.$router.push({
        name: '创建成本单',
        params: {
          product: this.product
        }
      })
    },
    onCostDetail (cost) { 
      this.costId = cost.id;
      this.detailVisible = true;
    },
    handleClose (cost) {
      this.$confirm('是否执行删除成本单操作?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onCancel(cost.id);
      });
    },
    async _onCancel (id) {
      const url = this.apis().cancelCostOrder(id);
      const result = await this.$http.put(url);

      if (result.code === 1) {
        this.$message.success('成本单取消成功！');
        this.searchCostOrderBySkuID();
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      }
    },
    callback () {
      this.detailVisible = false;
      this.searchCostOrderBySkuID();
    }
  },
  created () {
    this.searchCostOrderBySkuID();
  }
}
</script>

<style scoped>
  .basic-form-row {
    padding-left: 30px;
    margin-bottom: 20px;
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    /* margin-top: 5px; */
    width: 60px;
    font-size: 12px;
    font-weight: 500;
  }

  /deep/ .el-tag {
    margin-right: 10px;
  }

  .tag-btn {
    padding: 0px;
  }
</style>