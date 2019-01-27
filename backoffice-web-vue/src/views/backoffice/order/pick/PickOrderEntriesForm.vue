<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
      <el-table :data="slotData.entries" :disabled="readOnly" border>
        <el-form-item label="面辅料" prop="material">
          <el-table-column label="面辅料">
            <template slot-scope="scope">
              <span>{{scope.row.material.code}} - {{scope.row.material.name}}</span>
            </template>
          </el-table-column>
        </el-form-item>
        <el-form-item label="单位耗量" prop="quantity" :rules="rules">
          <el-table-column label="单位耗量" width="160px">
            <template slot-scope="scope">
              <el-input-number v-model="scope.row.quantity" :min="1" :precision="2" :disabled="readOnly">
              </el-input-number>
            </template>
          </el-table-column>
        </el-form-item>
        <el-form-item label="单位" prop="unit" :rules="rules">
          <el-table-column label="单位">
            <template slot-scope="scope">
              <el-select v-model="scope.row.unit.code">
                <el-option v-for="item in units" :key="item.code" :label="item.name" :value="item.code">
                </el-option>
              </el-select>
            </template>
          </el-table-column>
        </el-form-item>
        <el-form-item label="使用部位" prop="part" :rules="rules">
          <el-table-column label="使用部位">
            <template slot-scope="scope">
              <el-input v-model="scope.row.part"></el-input>
            </template>
          </el-table-column>
        </el-form-item>
        <el-form-item label="幅宽/规格" prop="widthh" :rules="rules">
          <el-table-column label="幅宽/规格">
            <template slot-scope="scope">
              <el-input v-model="scope.row.width"></el-input>
            </template>
          </el-table-column>
        </el-form-item>
        <el-form-item label="配色一" prop="color1" :rules="rules">
          <el-table-column label="配色一">
            <template slot-scope="scope">
              <el-input v-model="scope.row.color1"></el-input>
            </template>
          </el-table-column>
        </el-form-item>
        <el-form-item label="配色二" prop="color2">
          <el-table-column label="配色二">
            <template slot-scope="scope">
              <el-input v-model="scope.row.color2"></el-input>
            </template>
          </el-table-column>
        </el-form-item>
        <el-form-item label="配色三" prop="color3">
          <el-table-column label="配色三">
            <template slot-scope="scope">
              <el-input v-model="scope.row.color3"></el-input>
            </template>
          </el-table-column>
        </el-form-item>
        <el-form-item label="配色四" prop="color4">
          <el-table-column label="配色四">
            <template slot-scope="scope">
              <el-input v-model="scope.row.color4"></el-input>
            </template>
          </el-table-column>
        </el-form-item>
        <el-form-item label="配色五" prop="color5">
          <el-table-column label="配色五">
            <template slot-scope="scope">
              <el-input v-model="scope.row.color5"></el-input>
            </template>
          </el-table-column>
        </el-form-item>
        <el-table-column width="120" :label="readOnly? '': '操作'" v-show="!readOnly">
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
        <el-select class="w-100"
                   v-model="product"
                   filterable
                   remote
                   reserve-keyword
                   placeholder="请输入物料编码"
                   :remote-method="onFilterProducts"
                   :loading="loading"
                   :disabled="readOnly">
          <el-option
            v-for="item in products"
            :key="item.code"
            :label="item.code + ' - ' + item.name "
            :value="item">
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

  export default {
    name: 'PickOrderEntriesForm',
    props: ['slotData', 'readOnly'],
    methods: {
      validate() {
        if (!this._validateRows()) {
          return false;
        }

        if (this.slotData.entries.length <= 0) {
          this.$message.error('面辅料行不允许为空');
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
          this.$message.error("请先选择产品");
          return;
        }

        this.slotData.entries.push({
          quantity: '',
          unit: {
            code: '',
            name: ''
          },
          part: '',
          width: '',
          color1: '',
          color2: '',
          color3: '',
          color4: '',
          color5: '',
          material: {
            code: this.product.code,
            name: this.product.name
          }
        });

        this.product = null;
        this.unit = null;
      },
      onRemoveRow(row) {
        removeRow(this.slotData.entries, row);
      },
      getUnits() {
        axios.get("/djbackoffice/product/unit")
          .then(response => {
            this.units = response.data;
          }).catch(error => {
            this.$message.error(error.response.statusText);
          }
        );
      },
      onFilterProducts(query) {
        this.products = [];
        if (query !== '') {
          axios.get('/djbackoffice/product/fabric', {
            params: {
              code: query
            }
          }).then(response => {
            this.products = response.data.content;

          }).catch(error => {
            console.log(JSON.stringify(error));
            this.$message.error(error.response.data);
          }).finally(() => {
            this.loading = false;
          });
        }
      },
      _validateRows() {
        let pass = false;
        console.log(this.slotData.entries);
        // 空，验证通过
        if (this.slotData.entries.length === 0) {
          pass = true;
        } else {
          pass = this.slotData.entries.every(entry => {
            return entry.material && entry.quantity > 0
              && entry.unit.code !== '' && entry.part !== ''
              && entry.width !== '' && entry.color1 !== '';
          });
        }

        if (!pass) {
          this.$message.error('已有行数据验证不通过，请完善后再添加');
        }

        return pass;
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
        fabrics: [],
        units: [],
        unit: null,
        rules: {
          order: [{required: true, message: "必填", trigger: "blur"}],
          unit: [{required: true, message: "必选", trigger: "blur"}],
          part: [{required: true, message: "必填", trigger: "blur"}],
          width: [{required: true, message: "必填", trigger: "blur"}],
          color1: [{required: true, message: "必填", trigger: "blur"}]
        }
      }
    },
    created() {
      this.getUnits();
    }
  }
</script>
