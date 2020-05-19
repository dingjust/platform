<template>
  <div>
    <el-dialog :visible.sync="dialogVisible" width="90%" class="purchase-dialog" :close-on-click-modal="false"
      :append-to-body="true">
      <material-dialog @confirmMaterial="(list)=>onMaterialsEntriesAdd(list)" v-if="hackSet" />
    </el-dialog>
    <el-form :model="form" ref="form">
      <el-table :data="form.materialList" style="width: 100%">
        <el-table-column fixed="left">
          <template slot="header">
            使用名称 <el-popover placement="top-start" title="使用名称" width="200" trigger="hover"
              content="使用名称即面料在成衣上的实际用途如：主面料，口袋链，里布等。">
              <i slot="reference" class="el-icon-question" style="font-size:14px;"></i>
            </el-popover>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'materialList.' + scope.$index + '.title'"
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="scope.row.title" class="form-input"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column prop="materialsName" label="物料名称" fixed="left">
        </el-table-column>
        <el-table-column prop="materialsCode" label="物料编号" fixed="left">
        </el-table-column>
        <el-table-column prop="spec" label="物料规格" min-width="100px">
          <template slot-scope="scope">
            <el-form-item :prop="'materialList.' + scope.$index + '.spec'"
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-select v-model="scope.row.spec" value-key="code" @change="onSpecChange(scope.row)" class="form-input">
                <el-option v-for="item in specsMap[scope.row.materialsCode]" :key="item.code" :label="item.name"
                  :value="item">
                </el-option>
              </el-select>
            </el-form-item>
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
            <el-form-item :prop="'materialList.' + scope.$index + '.unitQuantity'"
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input v-model="scope.row.unitQuantity" v-number-input.float="{ min: 0,decimal:2}" placeholder=""
                class="form-input">
              </el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column prop="lossRate" label="损耗">
          <template slot-scope="scope">
            <el-form-item :prop="'materialList.' + scope.$index + '.lossRate'"
              :rules="{required: true, message: '不能为空', trigger: 'change'}">
              <el-input @input="(val)=>onLossRateInput(val,scope.row)" :value="showFloatPercentNum(scope.row.lossRate)"
                class="form-input" v-number-input.float="{ min: 0,max:100 ,decimal:0}">
                <h6 slot="suffix" style="padding-top:25px">%</h6>
              </el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column align="center">
          <template slot="header">
            款式颜色<el-popover placement="top-start" title="款式颜色" width="200" trigger="hover" ref="popover"
              content="此处显示对于款式的全部颜色，下方填写对应款式颜色所需物料的对应颜色，如不需要选择">
              <i slot="reference" class="el-icon-question" v-popover:popover style="font-size:14px;"></i>
            </el-popover>
          </template>
          <template v-for="(color,index) in colors">
            <el-table-column :key="index" :label="color.name">
              <template slot-scope="scope">
                <el-select v-model="getMaterialsColorEntry(scope.row,color).materialsColor" value-key="code" size="mini"
                  placeholder="">
                  <el-option v-for="item in getColorsBySpec(scope.row)" :key="item.code" :label="item.name"
                    :value="item">
                  </el-option>
                </el-select>
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
        <el-button icon="el-icon-plus" @click="openMaterialDialog">添加物料</el-button>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" class="product-form-row" style="margin-top:20px;">
      <el-button class="product-form-btn" @click="onSubmit()">提交</el-button>
    </el-row>
  </div>
</template>

<script>
  import {
    accMul,
  } from '@/common/js/number';
  import MaterialDialog from "@/views/product/material/dialog/MaterialDialog";

  export default {
    name: "MaterialSpecEntriesForm",
    props: ["slotData", "colors"],
    components: {
      MaterialDialog
    },
    computed: {
      specsMap: function () {
        var map = {};
        this.form.materialList.forEach(element => {
          //规格
          let specs = [];
          element.variants.forEach(variant => {
            if (specs.findIndex(item => item.code == variant.spec.code) == -1) {
              //颜色
              var colors = [];
              colors.push({
                'code': '',
                'name': '无'
              });
              element.variants.filter(v => v.spec.code == variant.spec.code).forEach(v => {
                if (colors.findIndex(obj => obj.code == v.color.code) == -1) {
                  colors.push(v.color);
                }
              });
              variant.spec['colors'] = colors;
              specs.push(variant.spec);
            }
          });
          map[element.materialsCode] = specs;
        });
        return map;
      },
    },

    methods: {
      onRemove(row) {
        this.form.materialList.splice(this.form.materialList.indexOf(row), 1);
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
            'materialsColor': {
              'code': '',
              'name': '无'
            }
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
      onSubmit() {
        this.$refs['form'].validate((valid) => {
          if (valid) {
            //过滤没有code的颜色
            this.form.materialList.forEach(material => {
              var newEntries = material.materialsColorEntries.filter(entry => entry.materialsColor != null &&
                entry.materialsColor.code != '');
              material.materialsColorEntries = newEntries;
            });
            this.$emit('onSubmit', this.form.materialList.filter(material => material.materialsColorEntries.length >
              0));
          } else {
            this.$message.error('请完善表格');
            return false;
          }
        });
      },
      onMaterialsEntriesAdd(materialList) {
        materialList.forEach(material => {
          let materialsColorEntries = this.colors.map(color => {
            return {
              'sampleColor': color,
              'materialsColor': ''
            }
          });
          this.form.materialList.push({
            'title': '',
            'position': '',
            'materialsId': material.id,
            'materialsCode': material.code,
            'materialsName': material.name,
            'materialsUnit': material.materialsUnit,
            'materialsType': material.materialsType,
            'spec': material.spec,
            'unitQuantity': material.unitQuantity,
            'lossRate': material.lossRate,
            'variants': material.variants,
            'colors': material.colors,
            'materialsColorEntries': materialsColorEntries
          });
        });
        this.dialogVisible = false;
      },
      openMaterialDialog() {
        this.hackSet = false;
        this.$nextTick(() => {
          this.hackSet = true;
        });
        this.dialogVisible = true;
      }
    },
    created() {
      if (this.slotData != null) {
        this.slotData.forEach(entry => {
          let entryJson = JSON.stringify(entry);
          this.form.materialList.push(JSON.parse(entryJson));
        });
      }
    },
    data() {
      return {
        visible: false,
        dialogVisible: false,
        activeName: "material",
        textarea1: '',
        hackSet: true,
        form: {
          materialList: []
        }
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
