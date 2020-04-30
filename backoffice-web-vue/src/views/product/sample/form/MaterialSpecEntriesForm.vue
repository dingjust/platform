<template>
  <div>
    <el-table :data="slotData" style="width: 100%">
      <el-table-column prop="name" label="物料名称">
      </el-table-column>
      <el-table-column prop="code" label="物料编号">
      </el-table-column>
      <el-table-column prop="spec" label="规格">
        <template slot-scope="scope">
          <el-select v-model="scope.row.spec" placeholder="请选择" value-key="code" @change="onSpecChange(scope.row)"
            :disabled="isUpdate">
            <el-option v-for="item in specsMap[scope.row.code]" :key="item.code" :label="item.name" :value="item"
              :disabled="isSpecContains(scope.row.code,item.code)">
            </el-option>
          </el-select>
        </template>
      </el-table-column>
      <el-table-column prop="colors" label="颜色">
        <template slot-scope="scope">
          <el-select v-model="scope.row.colors" placeholder="请选择" value-key="code" multiple
            @change="onColorsChange(scope.row)">
            <el-option v-for="item in scope.row.spec.colors" :key="item.code" :label="item.name" :value="item">
            </el-option>
          </el-select>
        </template>
      </el-table-column>
      <el-table-column prop="materialsUnit" label="物料单位">
        <template slot-scope="scope">
          {{getEnum('MaterialsUnit', scope.row.materialsUnit)}}
        </template>
      </el-table-column>
      <el-table-column prop="materialsType" label="物料属性">
        <template slot-scope="scope">
          {{getEnum('MaterialsType', scope.row.materialsType)}}
        </template>
      </el-table-column>
      <el-table-column prop="unitQuantity" label="单位用量">
        <template slot-scope="scope">
          <el-input v-model="scope.row.unitQuantity" placeholder="单位用量"></el-input>
        </template>
      </el-table-column>
      <el-table-column prop="lossRate" label="损耗">
        <template slot-scope="scope">
          <el-input @input="(val)=>onLossRateInput(val,scope.row)" :value="showFloatPercentNum(scope.row.lossRate)"
            v-number-input.float="{ min: 0,max:100 ,decimal:0}">
            <h6 slot="suffix" style="padding-top:10px">%</h6>
          </el-input>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button @click="onRemove(scope.row)" type="text" size="small">删除</el-button>
          <!-- <el-button type="text" size="small">编辑</el-button> -->
        </template>
      </el-table-column>
    </el-table>
    <el-row type="flex" justify="center" class="product-form-row" style="margin-top:20px;">
      <!-- <el-button class="product-form-btn" @click="onUpdate()"
        v-if="this.slotData.code!=null&&this.slotData.code!=''&&!isRead">更新产品信息</el-button> -->
      <el-button class="product-form-btn" @click="onSubmit()">提交</el-button>
    </el-row>
  </div>
</template>

<script>
  import {
    accMul,
  } from '@/common/js/number';

  export default {
    name: "MaterialSpecEntriesForm",
    props: ["slotData", "colorSizes", "isUpdate", "materialSpecMap", "readOnly", "isRead"],
    components: {

    },
    computed: {
      specsMap: function () {
        var map = {};
        this.slotData.forEach(element => {
          //规格
          let specs = [];
          element.variants.forEach(variant => {
            if (specs.findIndex(item => item.code == variant.spec.code) == -1) {
              //颜色
              let colors = [];
              element.variants.filter(v => v.spec.code == variant.spec.code).forEach(v => {
                if (colors.findIndex(obj => obj.code == v.color.code) == -1) {
                  colors.push(v.color);
                }
              });
              variant.spec['colors'] = colors;
              specs.push(variant.spec);
            }
          });
          map[element.code] = specs;
        });
        return map;
      },
      clothesColors: function () {
        var result = [{
          'color': '全部'
        }];
        this.colorSizes.forEach(element => {
          result.push(element[0]);
        });

        return result;
      }
    },

    methods: {
      onRemove(row) {
        this.slotData.splice(this.slotData.indexOf(row), 1);
      },
      showFloatPercentNum(val) {
        if (val == null) {
          return '';
        }
        var reg = /\.$/;
        if (!reg.test(val)) {
          return accMul(val, 100);
        } else {
          return val;
        }
      },
      onLossRateInput(val, row) {
        var reg = /\.$/;
        if (!reg.test(val)) {
          row.lossRate = (val / 100.0).toFixed(2);
        } else {
          row.lossRate = val;
        }
      },
      //适用颜色变化
      onApplicableColorChange(val, row) {
        //选中全部则适用颜色值置为空
        if (val != '' && val.findIndex((item) => item.color == '全部') != -1) {
          row.applicableColors = [{
            'color': '全部'
          }];;
        }
      },
      getSpecs(row) {
        var result = [];
        row.variants.forEach(variant => {
          if (result.findIndex(item => item.code == variant.spec.code) == -1) {
            result.push(variant.spec);
          }
        });
        return result;
      },
      onSpecChange(row) {
        //规格更改清空选中颜色(注:用set刷新，不然选项不能选中)
        this.$set(row, 'colors', []);
      },
      onColorsChange(row) {
        row['materialsColorEntries'] = row.colors.map(color => {
          let index = row.variants.findIndex(item => item.spec.code == row.spec.code && item.color.code == color
            .code);
          return {
            'materialsEntryCode': row.variants[index].code,
            'color': color,
            'applicableColors': []
          }
        });
      },
      onSubmit() {
        this.$emit('onSubmit', this.slotData);
      },
      isSpecContains(materialCode, code) {
        if (this.materialSpecMap != null) {
          if (this.materialSpecMap[materialCode] != null) {
            return this.materialSpecMap[materialCode].findIndex(element => element == code) == -1 ? false : true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    },
    created() {
      //遍历颜色行，生成materialsColorEntries
      if (this.isUpdate) {
        this.slotData.forEach(entry => {
          this.onColorsChange(entry);
          //对应规格的颜色组
          entry.spec['colors'] = this.specsMap[entry.code].find(element => element.code == entry.spec.code).colors;
        });
      }

    },
    data() {
      return {
        dialogVisible: false,
        activeName: "material",
        textarea1: '',
        materialList: []
      };
    },
    watch: {
      tableEntries: {
        handler(val) {

        },
        deep: true
      },
    },
    // mounted() {
    //   this.slotData.forEach(element => {
    //     if (element.materialsColorEntries.length != 0) {
    //       let colors = [];
    //       element.materialsColorEntries.forEach(entry => {
    //         colors.push(entry.color);
    //       });
    //       element['colors'] = colors;
    //     }
    //   });
    // },
  };

</script>
<style scoped>
  .product-form-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 150px;
  }

</style>
