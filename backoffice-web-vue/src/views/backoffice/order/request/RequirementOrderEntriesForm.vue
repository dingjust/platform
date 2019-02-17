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
                   :disabled="readOnly">统一设置供货价</el-button>
      </el-col>
    </el-row>
    <el-table stripe show-summary
              :data="slotData.entries"
              :summary-method="getSummaries"
              :disabled="readOnly">
      <el-table-column label="产品编号" width="160">
        <template slot-scope="scope">
          <span>{{scope.row.product.code}}</span>
        </template>
      </el-table-column>
      <el-table-column label="产品名称">
        <template slot-scope="scope">
          <span>{{scope.row.product.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="供应商商品编号" width="120">
        <template slot-scope="scope">
          <span>{{scope.row.product.skuID}}</span>
        </template>
      </el-table-column>
      <el-table-column label="颜色" width="80">
        <template slot-scope="scope">
          <span>{{scope.row.product.color.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="尺码" width="80">
        <template slot-scope="scope">
          <span>{{scope.row.product.size.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="供货价" prop="basePrice" width="160">
        <template slot-scope="scope">
          <el-input-number class="w-100"
                           v-model="scope.row.basePrice"
                           :min="0"
                           :precision="2"
                           :disabled="readOnly">
          </el-input-number>
        </template>
      </el-table-column>
      <el-table-column label="数量" prop="quantity" width="160">
        <template slot-scope="scope">
          <el-input-number class="w-100"
                           v-model="scope.row.quantity"
                           :min="1"
                           :precision="0"
                           :disabled="readOnly">
          </el-input-number>
        </template>
      </el-table-column>
      <el-table-column label="总价" width="100">
        <template slot-scope="scope">
          <!--<span>{{multiply(scope.row.basePrice, scope.row.quantity)}}</span>-->
          <span>{{scope.row.basePrice * scope.row.quantity}}</span>
        </template>
      </el-table-column>
      <el-table-column width="80" :label="readOnly? '': '操作'" v-show="!readOnly">
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit"
                     :disabled="readOnly || scope.row.id != null"
                     @click="onRemoveRow(scope.row)">
            删除
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-row :gutter="10" v-show="!readOnly">
      <el-col :span="18">
        <el-select class="w-100"
                   v-model="product"
                   filterable
                   remote
                   @change="selectChange"
                   reserve-keyword
                   placeholder="请输入产品编码"
                   :remote-method="onFilterProducts"
                   :loading="loading"
                   :disabled="readOnly">
          <el-option
            v-for="item in products"
            :key="item.code"
            :label="item.skuID + ' - ' + item.name"
            :value="item.code">
          </el-option>
        </el-select>
      </el-col>
      <el-col :span="6">
        <el-button type="primary" class="btn-block" icon="el-icon-plus" @click="onAddRow">添加行</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import axios from 'axios';

  function removeRow(array, row) {
    const length = array.length;
    for (let i = 0; i < length; i++) {
      const entry = array[i];
      if (entry === row) {
        if (i === 0) {
          array.shift(); // 删除并返回数组的第一个元素
          return array;
        } else if (i === length - 1) {
          array.pop();  // 删除并返回数组的最后一个元素
          return array;
        } else {
          array.splice(i, 1); // 删除下标为i的元素
          return array;
        }
      }
    }
  }

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
    name: 'RequirementOrderEntriesForm',
    props: ['slotData', 'readOnly'],
    methods: {
      multiply(num1, num2) {
        const num1Digits = (num1.toString().split('.')[1] || '').length;
        const num2Digits = (num2.toString().split('.')[1] || '').length;
        const baseNum = Math.pow(10, Math.max(num1Digits, num2Digits));
        return ((num1 * baseNum) * (num2 * baseNum)) / (baseNum * 100);
      },
      selectChange(val) {
        this.product = val;
      },
      validate(noCheckEmptyRows) {
        if (!this._validateRows()) {
          return false;
        }

        if (this.slotData.entries.length <= 0 && !noCheckEmptyRows) {
          this.$message.error('订单行不允许为空');
          return false;
        }

        return true;
      },
      onAddRow() {
        // 验证之前添加的行是否齐全
        if (!this._validateRows()) {
          return;
        }

        if (!this.product) {
          this.$message.error('请先选择产品');
          return;
        }

        if (this.slotData.entries && this.slotData.entries.length) {
          const item = this.slotData.entries[0];
          if (item.product.baseProduct !== this.product) {
            this.$message.error('只允许选择一款产品');
            return;
          }
        }

        if (this.product !== '') {
          axios.get('/djbackoffice/product/variant', {
            params: {
              code: this.product
            }
          }).then(response => {
            this.variants = response.data.content;
            let formEntries = this.slotData.entries;
            for (const item in this.variants) {
              this.variants[item]['todo'] = true;
              for (const form in formEntries) {
                if (this.variants[item].code === formEntries[form].product.code) {
                  this.variants[item]['todo'] = false;
                  continue;
                }
              }
            }
            for (const item in this.variants) {
              if (this.variants[item]['todo']) {
                this.slotData.entries.push({
                  basePrice: 0,
                  quantity: 1,
                  totalPrice: 0,
                  product: {
                    code: this.variants[item].code,
                    skuID: this.variants[item].skuID,
                    name: this.variants[item].name,
                    color: this.variants[item].color,
                    size: this.variants[item].size,
                    price: this.variants[item].baseProduct.price,
                    baseProduct: this.variants[item].baseProduct.code
                  }
                });
              }
            }
          }).catch(error => {
            this.$message.error(error.response.data);
          }).finally(() => {
            this.loading = false;
          });
        }


        this.product = null;
      },
      onRemoveRow(row) {
        removeRow(this.slotData.entries, row);
      },
      onFilterProducts(query) {
        this.products = [];
        if (query !== '') {
          axios.get('/djbackoffice/product', {
            params: {
              code: query,
              page: 0,
              size: 50
            }
          }).then(response => {
            this.products = response.data.content;
          }).catch(error => {
            this.$message.error(error.response.data);
          }).finally(() => {
            this.loading = false;
          });
        }
      },
      getSummaries(param) {
        const {columns, data} = param;
        const sums = [];

        sums[0] = '总计';
        sums[1] = '';
        sums[2] = '';
        sums[3] = '';
        sums[4] = '';
        sums[5] = '';
        const totalCount = data.map(item => Number(item['quantity']));
        sums[6] = sum(totalCount);
        const totalPrices = data.map(item => Number(item['basePrice']) * Number(item['quantity']));
        sums[7] = sum(totalPrices);

        return sums;
      },
      _validateRows() {
        let pass = false;

        // 空，验证通过
        if (this.slotData.entries.length === 0) {
          pass = true;
        } else {
          pass = this.slotData.entries.every(entry => {
            return entry.product && entry.quantity > 0;
          });
        }

        if (!pass) {
          this.$message.error('已有行数据验证不通过，请完善后再添加');
        }

        return pass;
      },
      onSetPrice() {
        this.$set(this.slotData, 'entries', [...this.slotData.entries]);
        for (const index in this.slotData.entries) {
          this.slotData.entries[index].basePrice = this.price;
        }
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {
        loading: false,
        product: null,
        products: [],
        variants: [],
        price: 0
      }
    },
    created() {
      // this.entries = this.slotData.entries;
    }
  }
</script>
