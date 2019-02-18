<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :disabled="readOnly">
      <el-table :data="slotData.staircasePrices" :disabled="readOnly" style="width: 100%">
        <el-form-item label="价格" prop="price">
          <el-table-column label="价格">
            <template slot-scope="scope">
              <el-input-number class="w-100" v-model="scope.row.price" :min="1" :precision="2" :disabled="readOnly">
              </el-input-number>
            </template>
          </el-table-column>
        </el-form-item>
        <el-form-item label="非会员起订量（最小值）" prop="minQuantity">
          <el-table-column label="非会员起订量（最小值）">
            <template slot-scope="scope">
              <el-input-number class="w-100" @change="checkData(scope.row.minQuantity,scope.row.maxQuantity)"
                               v-model="scope.row.minQuantity" :min="0" :disabled="readOnly">
              </el-input-number>
            </template>
          </el-table-column>
        </el-form-item>
        <el-form-item label="非会员起订量（最大值）" prop="maxQuantity">
          <el-table-column label="非会员起订量（最大值）">
            <template slot-scope="scope">
              <el-input-number class="w-100" @change="checkData(scope.row.minQuantity,scope.row.maxQuantity)"
                               v-model="scope.row.maxQuantity" :min="0" :disabled="readOnly">
              </el-input-number>
            </template>
          </el-table-column>
        </el-form-item>
        <el-table-column :label="readOnly? '': '操作'" v-show="!readOnly">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-edit"
                       :disabled="readOnly || scope.row.id != null"
                       @click="onRemoveRow(scope.row)">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-form>
    <div class="pt-2"></div>
    <el-row :gutter="10" v-show="!readOnly">
      <el-col :span="18">

      </el-col>
      <el-col :span="6">
        <el-button type="primary" class="btn-block" icon="el-icon-plus" @click="onAddRow">
          非会员起订量价格管理
        </el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
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

  export default {
    name: 'ProductPricesEntriesForm',
    props: ['slotData', 'readOnly'],
    methods: {
      checkData(min, max) {
        if (max <= min) {
          this.$message.error('非会员起订价（最大值）必须大于非会员起订价（最小值）');
          return false;
        }
      },
      validate() {
        return true;
      },
      onAddRow() {
        if (this.rowCount < 3) {
          this.slotData.staircasePrices.push({
            id: null,
            minQuantity: 0,
            maxQuantity: 0,
            price: 0.0
          });
          this.rowCount++;
        }


      },
      onRemoveRow(row) {
        removeRow(this.slotData.staircasePrices, row);
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {
        rowCount: 0
      }
    },
    created() {
    }
  }
</script>
