<template>
  <div class="animated fadeIn">
    <el-table stripe :data="variants">
      <el-table-column label="产品编码" prop="code" width="160"></el-table-column>
      <el-table-column label="产品名称" prop="name" width="480"></el-table-column>
      <el-table-column label="供应商商品编号" prop="skuID" width="160"></el-table-column>
      <el-table-column label="产品颜色" prop="color.name"></el-table-column>
      <el-table-column label="产品尺码" prop="size.name"></el-table-column>
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
    <div class="pt-2"></div>
    <el-row :gutter="10" v-show="!readOnly">
      <el-col :span="24">
        <el-select placeholder="请选择颜色" v-model="color">
          <el-option v-for="color in colors"
                     :key="color.code"
                     :label="color.name"
                     :value="color.code">
          </el-option>
        </el-select>
        <el-select placeholder="请选择尺码" v-model="size">
          <el-option v-for="size in sizes"
                     :key="size.code"
                     :label="size.name"
                     :value="size.code">
          </el-option>
        </el-select>
        <el-button type="primary" icon="el-icon-plus" @click="onAddRow">添加行</el-button>
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
    name: 'ProductVariantsForm',
    props: ['slotData', 'readOnly', 'isNewlyCreated'],
    methods: {
      refresh() {
        if (this.slotData.code) {
          this.doRefresh();
        }
      },
      doRefresh() {
        axios.get('/djbrand/product/variants/' + this.slotData.code)
          .then(response => {
            this.variants = response.data;
          }).catch(error => {
            this.$message.error(error.response.data);
          }
        );
      },
      getValue() {
        return this.variants;
      },
      onAddRow() {
        // 验证之前添加的行是否齐全
        if (!this.color || !this.size) {
          this.$message.error('请选择颜色和尺码');
          return;
        }

        if (this.variants.some(entry => {
          return entry.color.code === this.color && entry.size.code === this.size;
        })) {
          this.$message.error('颜色和尺码已经存在，请重新选择');
          return;
        }

        const colorIndex = this.colors.findIndex(item => item.code === this.color);
        const sizeIndex = this.sizes.findIndex(item => item.code === this.size);
        this.variants.push({
          code: this.slotData.code + this.color + this.size,
          name: this.slotData.name,
          color: this.colors[colorIndex],
          size: this.sizes[sizeIndex]
        });

        this.product = null;
      },
      onRemoveRow(row) {
        removeRow(this.variants, row);
      }
    },
    computed: {},
    data() {
      return {
        color: '',
        size: '',
        variants: [],
        colors: [],
        sizes: []
      };
    },
    created() {
      if (!this.isNewlyCreated) {
        this.doRefresh();
      }

      axios
        .all([
          axios
            .get('/djbackoffice/product/color/all')
            .then(response => {
              this.colors = response.data;
            }),

          axios
            .get('/djbackoffice/product/size/all')
            .then(response => {
              this.sizes = response.data;
            })
        ]).catch(error => {
        this.$message.error(error.response.data);
      });
    }
  };
</script>
