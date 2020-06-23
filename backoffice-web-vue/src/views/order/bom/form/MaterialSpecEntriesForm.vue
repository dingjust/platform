<!-- 
 * @description: BOM表单
 * @fileName: MaterialSpecEntriesForm.vue 
 * @author: yj 
 * @date: 2020-06-17 10:46:37
 * @version: V1.0.0 
!-->
<template>
  <div>
    <el-dialog :visible.sync="dialogVisible" width="60%" class="purchase-dialog" :close-on-click-modal="false"
      :append-to-body="true">
      <material-spec-entry-form :entry="form.entries[curEntryIndex]"
        @confirmMaterial="(val)=>onMaterialsEntriesSave(val)" v-if="dialogVisible" />
    </el-dialog>
    <el-form :model="form" ref="form">
      <el-table :data="form.entries" style="width: 100%">
        <el-table-column prop="materialsCode" label="物料编号">
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.materialsCode'"
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="scope.row.materialsCode" class="form-input" @focus="onFocus(scope.$index)"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <!-- <el-table-column fixed="left">
          <template slot="header">
            使用名称 <el-popover placement="top-start" title="使用名称" width="200" trigger="hover"
              content="使用名称即面料在成衣上的实际用途如：主面料，口袋链，里布等。">
              <i slot="reference" class="el-icon-question" style="font-size:14px;"></i>
            </el-popover>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.title'"
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="scope.row.title" class="form-input"></el-input>
            </el-form-item>
          </template>
        </el-table-column> -->
        <el-table-column prop="materialsName" label="物料名称" fixed="left">
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.materialsName'"
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="scope.row.materialsName" class="form-input"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column prop="specWeight" label="规格/克重" min-width="100px">
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.specWeight'"
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="scope.row.specWeight" class="form-input"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column prop="materialWidth" label="物料幅宽" min-width="100px">
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.materialWidth'"
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="scope.row.materialWidth" class="form-input"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column prop="materialComposition" label="物料成分" min-width="100px">
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.materialComposition'"
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="scope.row.materialComposition" class="form-input"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column prop="materialUnit" label="物料单位">
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.materialUnit'"
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="scope.row.materialUnit" class="form-input"></el-input>
            </el-form-item>
            <!-- <el-input v-model="scope.row.materialsUnit" class="form-input"
              :value="getEnum('MaterialsUnit', scope.row.materialsUnit)"></el-input> -->
          </template>
        </el-table-column>
        <el-table-column prop="unitQuantity" label="单位用量">
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.unitQuantity'"
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="scope.row.unitQuantity" v-number-input.float="{ min: 0,decimal:2}" placeholder=""
                class="form-input">
              </el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column prop="lossRate" label="物料损耗">
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.lossRate'"
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input :value="showFloatPercentNum(scope.row.lossRate)" class="form-input"
                v-number-input.float="{ min: 0,max:100 ,decimal:0}">
                <h6 slot="suffix" style="padding-top:25px">%</h6>
              </el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="实际用量">
          <template slot-scope="scope">
            {{getActualUsage(scope.row)}}
          </template>
        </el-table-column>
        <el-table-column align="center">
          <template slot="header">
            款式颜色<el-popover placement="top-start" title="款式颜色" width="200" trigger="hover" ref="popover"
              content="此处显示对于款式的全部颜色，下方填写对应款式颜色所需物料的对应颜色，如不需要选择">
              <i slot="reference" class="el-icon-question" v-popover:popover style="font-size:14px;"></i>
            </el-popover>
          </template>
          <template v-for="(color,index) in productsColors">
            <el-table-column :key="index" :label="color.name">
              <template slot-scope="scope">
                <!-- <el-select v-model="getMaterialsColorEntry(scope.row,color).materialsColor" value-key="code" size="mini"
                  placeholder="">
                  <el-option v-for="item in getColorsBySpec(scope.row)" :key="item.code" :label="item.name"
                    :value="item">
                  </el-option>
                </el-select> -->
                <el-form-item>
                  <el-input v-model="getMaterialsColorEntry(scope.row,color).materialsColor" class="form-input">
                  </el-input>
                </el-form-item>
              </template>
            </el-table-column>
          </template>
        </el-table-column>
        <el-table-column align="center">
          <template slot="header">
            对应尺码<el-popover placement="top-start" title="对应尺码" width="200" trigger="hover" ref="popover"
              content="此处显示对于款式的全部颜色，下方填写对应款式颜色所需物料的对应颜色，如不需要选择">
              <i slot="reference" class="el-icon-question" v-popover:popover style="font-size:14px;"></i>
            </el-popover>
          </template>
          <template v-for="(size,index) in productsSizes">
            <el-table-column :key="index" :label="size.name">
              <template slot-scope="scope">
                <el-form-item>
                  <el-input v-model="getMaterialsSizeEntry(scope.row,size).materialsSize" class="form-input">
                  </el-input>
                </el-form-item>
              </template>
            </el-table-column>
          </template>
        </el-table-column>
        <el-table-column label="使用部位">
          <template slot-scope="scope">
            <el-input v-model="scope.row.position"></el-input>
          </template>
        </el-table-column>
        <el-table-column label="操作" fixed="right">
          <template slot-scope="scope">
            <el-button @click="onRemove(scope.row)" type="text" size="small">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-form>
    <el-row type="flex" style="margin-top:10px;">
      <el-col :span="4">
        <el-button icon="el-icon-plus" @click="addRow">添加物料</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {
    accMul,
  } from '@/common/js/number';
  import MaterialSpecEntryForm from "./MaterialSpecEntryForm";

  export default {
    name: "MaterialSpecEntriesForm",
    props: {
      form: {
        type: Object,
        default: () => {
          return {
            entries: []
          };
        }
      },
      productsColors: {
        type: Array,
        default: () => {
          return [];
        }
      },
      productsSizes: {
        type: Array,
        default: () => {
          return [];
        }
      },
    },
    components: {
      MaterialSpecEntryForm
    },
    computed: {

    },
    methods: {
      onRemove(row) {
        this.form.entries.splice(this.form.entries.indexOf(row), 1);
      },
      onFocus(index) {
        this.$set(this, 'curEntryIndex', index);
        this.dialogVisible = true;
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
      //根据颜色找对应Entry
      getMaterialsColorEntry(row, sampleColor) {
        let index = -1;
        if (row.materialsColorEntries != null) {
          index = row.materialsColorEntries.findIndex(element => {
            if (element.sampleColor.code == null) {
              return element.sampleColor.name == sampleColor.name
            } else {
              return element.sampleColor.code == sampleColor.code;
            }
          });
        }

        if (index == -1) {
          //没找到则添加对应颜色对象
          var newEntry = {
            'sampleColor': sampleColor,
            'materialsColor': ''
          };
          if (row.materialsColorEntries != null) {
            row.materialsColorEntries.push(newEntry);
          } else {
            row.materialsColorEntries = [newEntry];
          }

          return newEntry;
        } else {
          return row.materialsColorEntries[index];
        }
      },
      //根据尺码找对应Entry
      getMaterialsSizeEntry(row, sampleSize) {
        let index = -1;
        if (row.materialsSizeEntries != null) {
          index = row.materialsSizeEntries.findIndex(element => {
            if (element.sampleSize.code == null) {
              return element.sampleSize.name == sampleSize.name
            } else {
              return element.sampleSize.code == sampleSize.code;
            }
          });
        }

        if (index == -1) {
          //没找到则添加对应颜色对象
          var newEntry = {
            'sampleSize': sampleSize,
            'materialsSize': ''
          };
          if (row.materialsSizeEntries != null) {
            row.materialsSizeEntries.push(newEntry);
          } else {
            row.materialsSizeEntries = [newEntry];
          }

          return newEntry;
        } else {
          return row.materialsSizeEntries[index];
        }
      },
      getColorsBySpec(row) {
        if (row.spec == null || row.spec.code == null) {
          return [];
        }
        let materialCode = row.materialsCode;
        let specCode = row.spec.code;
        let items = this.specsMap[materialCode];
        let index = items.findIndex(element => element.code != null && element.code == specCode);
        return items[index].colors;
      },
      onSpecChange(row) {
        //规格更改清空选中颜色(注:用set刷新，不然选项不能选中)
        this.$set(row, 'colors', []);
      },
      addRow() {
        let materialsColorEntries = this.productsColors.map(color => {
          return {
            'sampleColor': color,
            'materialsColor': ''
          }
        });
        let materialsSizeEntries = this.productsSizes.map(size => {
          return {
            'sampleSize': size,
            'materialsSize': ''
          }
        });
        this.form.entries.push({
          'title': '',
          'position': '',
          'materialsId': '',
          'materialsCode': '',
          'materialsName': '',
          'materialsUnit': '',
          'materialsType': '',
          'spec': '',
          'unitQuantity': '',
          'lossRate': '',
          'variants': [],
          'colors': [],
          'materialsColorEntries': materialsColorEntries,
          'materialsSizeEntries': materialsSizeEntries
        });
      },
      //算实际用量
      getActualUsage(row) {
        if (Number.isNaN(parseFloat(row.lossRate))) {
          return row.unitQuantity;
        } else {
          return (row.unitQuantity * (1 + parseFloat(row.lossRate))).toFixed(2);
        }
      },
      onMaterialsEntriesSave(val) {
        this.$set(this.form.entries, this.curEntryIndex, val);
        this.dialogVisible = false;
      },
    },
    created() {

    },
    data() {
      return {
        visible: false,
        dialogVisible: false,
        activeName: "material",
        curEntryIndex: 0
      };
    },
  };

</script>
<style scoped>
  .product-form-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 150px;
  }

  .form-input {
    padding-top: 15px;
  }

  .form-input .el-input--suffix .el-input__inner {
    padding: 5px !important;
  }

</style>
