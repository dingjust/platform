<template>
  <div class="animated fadeIn">
    <el-row :gutter="10" v-show="!readOnly">
      <el-col :span="12"></el-col>
      <el-col :span="8">
        <el-input-number class="w-100"
                         v-model="price"
                         :min="0.00"
                         :precision="2"
                         :disabled="readOnly">
        </el-input-number>
      </el-col>
      <el-col :span="4">
        <el-button type="primary" class="btn-block" @click="onSetPrice"
                   :disabled="readOnly">统一设置合同价
        </el-button>
      </el-col>
    </el-row>
    <el-table stripe show-summary
              :data="slotData.consignmentEntries"
              :summary-method="getSummaries"
              :disabled="readOnly">
      <el-table-column label="产品编号" width="160" fixed>
        <template slot-scope="scope">
          <span>{{scope.row.orderEntry.product.code}}</span>
        </template>
      </el-table-column>
      <el-table-column label="产品名称" width="180" fixed>
        <template slot-scope="scope">
          <span>{{scope.row.orderEntry.product.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="供应商产品编号" width="120" fixed>
        <template slot-scope="scope">
          <span>{{scope.row.orderEntry.product.skuID}}</span>
        </template>
      </el-table-column>
      <el-table-column label="颜色" width="80">
        <template slot-scope="scope">
          <span>{{scope.row.orderEntry.product.color.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="尺码" width="80">
        <template slot-scope="scope">
          <span>{{scope.row.orderEntry.product.size.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="预计发货数量" prop="quantity" width="100"></el-table-column>
      <el-table-column label="实际发货数量" prop="shippedQuantity" width="160">
        <template slot-scope="scope">
          <el-input-number v-model="scope.row.shippedQuantity"
                           :min="1"
                           :max="scope.row.quantity"
                           :precision="0"
                           :disabled="readOnly">
          </el-input-number>
        </template>
      </el-table-column>
      <el-table-column label="合同价" prop="price" width="160">
        <template slot-scope="scope">
          <el-input-number v-model="scope.row.price"
                           :min="0"
                           :precision="2"
                           :disabled="readOnly">
          </el-input-number>
        </template>
      </el-table-column>
      <el-table-column label="接单价" prop="orderEntry.basePrice" width="160"></el-table-column>
      <el-table-column label="裁剪数量" prop="tailorQuantity" width="80"></el-table-column>
    </el-table>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  function sum(values) {
    let result = 'N/A';
    if (!values.every(value => isNaN(value))) {
      result = values.reduce((prev, curr) => {
        const value = Number(curr);
        if (!isNaN(value)) {
          return prev + curr;
        } else {
          return prev;
        }
      }, 0);
    }

    return result;
  }

  export default {
    name: 'ConsignmentEntriesForm',
    props: ['slotData', 'readOnly'],
    methods: {
      validate() {
        if (!this._validateRows()) {
          return false;
        }

        if (this.slotData.consignmentEntries.length <= 0) {
          this.$message.error('发货行不允许为空');
          return false;
        }

        return true;
      },
      getSummaries(param) {
        const {columns, data} = param;
        const sums = [];

        sums[0] = '总计';
        sums[1] = '';
        sums[2] = '';
        sums[3] = '';
        sums[4] = '';
        const totalQuantity = data.map(item => Number(item['quantity']));
        sums[5] = sum(totalQuantity);
        const totalShippingQuantity = data.map(item => Number(item['shippedQuantity']));
        sums[6] = sum(totalShippingQuantity);
        const totalPrices = data.map(item => Number(item['shippedQuantity']) * Number(item['price']));
        sums[7] = sum(totalPrices);

        return sums;
      },
      _validateRows() {
        let pass = false;

        // 空，验证通过
        if (this.slotData.consignmentEntries.length === 0) {
          pass = true;
        } else {
          pass = this.slotData.consignmentEntries.every(entry => {
            return entry.shippedQuantity > 0 && entry.quantity >= entry.shippedQuantity;
          });
        }

        if (!pass) {
          this.$message.error('已有行数据验证不通过，请完善后再添加');
        }

        return pass;
      },
      onSetPrice() {
        console.log(this.slotData);
        //this.$set(this.slotData, 'consignmentEntries', [...this.slotData.consignmentEntries]);
        for (const index in this.slotData.consignmentEntries) {
          this.slotData.consignmentEntries[index].price = this.price;
        }
        console.log(this.slotData);
      }
    },
    computed: {
      // 显示过滤的行，编辑时编辑完整的行，后台要传空行过来
      filteredEntries: function () {
        return this.slotData.consignmentEntries.filter(entry => {
          return entry.shippedQuantity > 0;
        });
      }
    },
    data() {
      return {
        price: 0
      }
    }
  }
</script>
