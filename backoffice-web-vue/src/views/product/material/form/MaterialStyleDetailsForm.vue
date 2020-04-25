<template>
  <div>
    <el-row>
      <el-table :data="formData.variants" default-expand-all :highlight-current-row="false">
        <el-table-column prop="specs" label="规格" min-width="100">
          <template slot-scope="scope">
            <el-select v-if="modifyFlag && scope.$index == modifyIndex" v-model="scope.row.spec" placeholder="请选择" value-key="key">
              <el-option
                v-for="(item,index) in specsData"
                :key="index"
                :label="item.name"
                :value="item">
              </el-option>
            </el-select>
            <span v-else>{{scope.row.spec.name}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="color" label="颜色" min-width="90">
          <template slot-scope="scope">
            <el-select v-if="modifyFlag && scope.$index == modifyIndex" v-model="scope.row.color" placeholder="请选择" value-key="key">
              <el-option
                v-for="(item,index) in colorsData"
                :key="index"
                :label="item.name"
                :value="item">
              </el-option>
            </el-select>
            <span v-else>{{scope.row.color.name}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="unit" label="单位" min-width="90">
          <template slot-scope="scope">
<!--            <el-input v-model="scope.row.unit" v-if="modifyFlag && scope.$index == modifyIndex"></el-input>-->
<!--            <el-select v-if="modifyFlag && scope.$index == modifyIndex" v-model="scope.row.materialsUnit" placeholder="请选择">-->
<!--              <el-option-->
<!--                v-for="item in materialsUnit"-->
<!--                :key="item.code"-->
<!--                :label="item.name"-->
<!--                :value="item">-->
<!--              </el-option>-->
<!--            </el-select>-->
<!--            <span v-else>{{isCreate ? scope.row.materialsUnit.name : scope.row.materialsUnit}}</span>-->
            <span>{{getEnum('MaterialsUnit', formData.materialsUnit)}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="quantity" label="库存数量" min-width="80">
          <template slot-scope="scope">
            <el-input v-model="scope.row.quantity" v-if="modifyFlag && scope.$index == modifyIndex" v-number-input.float="{ min: 0 ,decimal:0}"/>
            <span v-else>{{scope.row.quantity}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="referencePrice" label="参考价（元）" min-width="80">
          <template slot-scope="scope">
            <el-input v-model="scope.row.referencePrice" v-if="modifyFlag && scope.$index == modifyIndex"
                      @change="(val)=>onUnitPriceInput(val,scope.row)" v-number-input.float="{ min: 0 ,decimal:2}"/>
            <span v-else>{{scope.row.referencePrice}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="taxRate" label="税率" min-width="60">
          <template slot-scope="scope">
            <el-input :value="showFloatPercentNum(scope.row.taxRate)" @blur="onBlur(scope.row,'taxRate')" v-if="modifyFlag && scope.$index == modifyIndex"
                      @input="(val)=>onTaxInput(val,scope.row)" v-number-input.float="{ min: 0 , max: 100, decimal: 1 }">
              <h6 slot="suffix" style="padding-top:8px">%</h6>
            </el-input>
            <span v-else>{{scope.row.taxRate * 100}}%</span>
          </template>
        </el-table-column>
        <el-table-column prop="taxPrice" label="含税价（元）" min-width="80">
          <template slot-scope="scope">
            <el-input v-model="scope.row.taxPrice" v-if="modifyFlag && scope.$index == modifyIndex"
                      @change="(val)=>onTaxUnitPriceInput(val,scope.row)" v-number-input.float="{ min: 0 ,decimal:2}"/>
            <span v-else>{{scope.row.taxPrice}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="address" label="操作" min-width="120">
          <template slot-scope="scope">
            <el-button v-if="modifyFlag && scope.$index == modifyIndex" type="text" icon="el-icon-edit"
                       @click="onSave(scope.row, scope.$index)">保存</el-button>
            <el-button v-else type="text" icon="el-icon-edit"
                       @click="onModify(scope.row, scope.$index)" :disabled="!isCreate">修改</el-button>
            <el-button type="text" icon="el-icon-edit"
                       @click="onDelete(scope.row, scope.$index)" :disabled="!isCreate">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-row type="flex">
        <el-button style="margin-right: 11px;margin-top: 20px" @click="appendMaterial" v-if="isCreate">+ 添加物料</el-button>
      </el-row>
    </el-row>
  </div>
</template>

<script>
  import {
    accMul
  } from '@/common/js/number';

  export default {
    name: 'MaterialStyleDetailsForm',
    props: ['formData', 'specsData', 'colorsData', 'isCreate'],
    methods: {
      onSave (row, index) {
        for (var key in row) {
          switch (typeof row[key]) {
            case 'string':
              if (row[key].replace(/(^s*)|(s*$)/g, '').length === 0) {
                this.$message.error('请先保存正在编辑的信息');
                return;
              }
              break;
          }
        }
        this.modifyIndex = '';
        this.modifyFlag = false;
      },
      onModify (row, index) {
        this.modifyIndex = index;
        this.modifyFlag = true;
      },
      onDelete (row, index) {
        // if (this.modifyFlag) {
        //   this.$message.error('请先保存正在编辑的信息');
        //   return;
        // }
        this.formData.variants.splice(index, 1);
        this.modifyFlag = false;
        if (this.formData.variants.length === 0) {
          this.appendMaterial();
        }
      },
      appendMaterial () {
        if (this.modifyFlag) {
          return;
        }
        const data = {
          spec: '',
          color: '',
          quantity: '',
          referencePrice: '',
          taxRate: '',
          taxPrice: ''
        };
        this.formData.variants.push(data);
        this.modifyIndex = this.formData.variants.length - 1;
        this.modifyFlag = true;
      },
      onBlur(row, attribute) {
        var reg = /\.$/;
        if (reg.test(row[attribute])) {
          this.$set(row, attribute, parseFloat(row[attribute] + '0') / 100.0);
          if (row.referencePrice != null && row.referencePrice != '') {
            row.taxPrice = ((parseFloat(row.taxRate) + 1) * row.referencePrice).toFixed(2);
          } else if (row.taxPrice != null && row.taxPrice != '') {
            row.referencePrice = (row.taxPrice / (1 + row.taxRate)).toFixed(2);
          }
        }
      },
      showFloatPercentNum(val) {
        var reg = /\.$/;
        if (!reg.test(val)) {
          return accMul(val, 100);
        } else {
          return val;
        }
      },
      onTaxInput(val, row) {
        var reg = /\.$/;
        if (!reg.test(val)) {
          row.taxRate = (val / 100.0).toFixed(3);
        } else {
          row.taxRate = val;
        }
        if (row.referencePrice != null && row.referencePrice != '') {
          row.taxPrice = ((parseFloat(row.taxRate) + 1) * row.referencePrice).toFixed(2);
        } else if (row.taxPrice != null && row.taxPrice != '') {
          row.referencePrice = (row.taxPrice / (1 + row.taxRate)).toFixed(2);
        }
      },
      onUnitPriceInput(val, row) {
        if (row.taxRate != null && row.taxRate != '') {
          row.taxPrice = ((parseFloat(row.taxRate) + 1) * row.referencePrice).toFixed(2);
        }
        // else if (row.taxPrice != null && row.taxPrice != '') {
        //   row.taxRate = (row.taxPrice - row.referencePrice) / row.referencePrice;
        // }
      },
      onTaxUnitPriceInput(val, row) {
        if (row.taxRate != null && row.taxRate != '') {
          row.referencePrice = (row.taxPrice / (1 + parseFloat(row.taxRate))).toFixed(2);
        }
      },
    },
    data () {
      return {
        modifyFlag: false,
        modifyIndex: '',
        materialsUnit: this.$store.state.EnumsModule.MaterialsUnit,
        taxRate: ''
      }
    },
    watch: {
    },
    created () {
      if (this.formData.variants.length === 0) {
        this.appendMaterial();
      }
    }
  }
</script>

<style scoped>
  /deep/ .el-table--enable-row-hover .el-table__body tr:hover > td {
     background-color: #FFffff !important;
  }

  /deep/ .el-input--suffix .el-input__inner {
    padding-right: 15px;
  }
</style>
