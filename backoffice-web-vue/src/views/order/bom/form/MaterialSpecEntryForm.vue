<!-- 
 * @description: 单行物料表单
 * @fileName: MaterialSpecEntryForm.vue 
 * @author: yj 
 * @date: 2020-06-17 10:47:01
 * @version: V1.0.0 
!-->
<template>
  <div class="form-body">
    <el-dialog :visible.sync="dialogVisible" width="90%" class="purchase-dialog" :close-on-click-modal="false"
      :append-to-body="true">
      <material-single-select @confirmMaterial="(val)=>onMaterialsEntriesAdd(val)" v-if="dialogVisible" />
    </el-dialog>
    <el-form :model="form" label-position="left" ref="form">
      <el-row type="flex" style="margin-bottom:20px">
        <el-col :span="4">
          <el-button icon="el-icon-plus" @click="dialogVisible=!dialogVisible">选取物料</el-button>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" :gutter="20">
        <el-col :span="8">
          <el-form-item prop="materialsCode" label="物料编号" label-width="100px"
            :rules="{required: true, message: '不能为空', trigger: 'blur'}">
            <el-input v-model="form.materialsCode"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item prop="materialType" label="物料类别" label-width="100px"
            :rules="{required: true, message: '不能为空', trigger: 'blur'}">
            <el-input v-model="form.materialType"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item prop="materialsName" label="物料名称" label-width="100px"
            :rules="{required: true, message: '不能为空', trigger: 'blur'}">
            <el-input v-model="form.materialsName"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" :gutter="20">
        <el-col :span="8">
          <el-form-item prop="specWeight" label="规格/克重" label-width="100px"
            :rules="{required: true, message: '不能为空', trigger: 'blur'}">
            <!-- <el-input v-model="form.specWeight"></el-input> -->
            <el-select v-model="form.specWeight" :filter-method="(val)=>onFilterInput(form,'specWeight',val)" filterable
              allow-create placeholder="选取或填写">
              <el-option v-for="item in specs" :key="item.name" :label="item.name" :value="item.name">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item prop="materialWidth" label="物料幅宽" label-width="100px"
            :rules="{required: true, message: '不能为空', trigger: 'blur'}">
            <el-input v-model="form.materialWidth"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item prop="materialComposition" label="物料成分" label-width="100px"
            :rules="{required: true, message: '不能为空', trigger: 'blur'}">
            <el-input v-model="form.materialComposition"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" :gutter="20">
        <el-col :span="8">
          <el-form-item prop="materialUnit" label="物料单位" label-width="100px"
            :rules="{required: true, message: '不能为空', trigger: 'blur'}">
            <el-input v-model="form.materialUnit"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item prop="unitQuantity" label="单位用量" label-width="100px"
            :rules="{required: true, message: '不能为空', trigger: 'blur'}">
            <el-input v-model="form.unitQuantity"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item prop="lossRate" label="物料损耗" label-width="100px"
            :rules="{required: true, message: '不能为空', trigger: 'blur'}">
            <el-input v-model="form.lossRate" v-number-input.float="{ min: 0,max:100,decimal:1}">
              <h6 slot="suffix" style="padding-top:10px">%</h6>
            </el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" :gutter="20">
        <el-col :span="8">
          <el-form-item prop="position" label="使用部位" label-width="100px"
            :rules="{required: true, message: '不能为空', trigger: 'blur'}">
            <el-input v-model="form.position"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item prop="materialsCode" label="实际用量：" label-width="100px">
            <!-- <el-input v-model="form.materialsCode"></el-input> -->
            {{actualUsage}}
          </el-form-item>
        </el-col>
      </el-row>
      <h6>样衣颜色：</h6>

      <!-- <template v-for="rowIndex in colorRows">
        <el-row type="flex" justify="start" :key="'colorRows'+rowIndex" :gutter="20" style="margin-top:10px">
          <template v-for="colIndex in countColorRowLength(rowIndex)">
            <el-col :span="8" :key="'colorCols'+colIndex">
              <el-table :data="[form.materialsColorEntries[((rowIndex-1)*columnNum+colIndex-1)]]" border
                style="width: 100%;">
                <el-table-column :resizable="false" prop="sampleColor.name" label="样衣颜色">
                </el-table-column>
                <el-table-column :resizable="false" label="物料颜色">
                  <template slot-scope="scope">
                    <el-select v-model="scope.row.materialsColor" filterable
                      :filter-method="(val)=>onFilterInput(scope.row,'materialsColor',val)" allow-create
                      placeholder="选取或填写">
                      <el-option v-for="item in form.colors" :key="item.name" :label="item.name" :value="item.name">
                      </el-option>
                    </el-select>
                  </template>
                </el-table-column>
              </el-table>
            </el-col>
          </template>
        </el-row>
      </template> -->

      <el-table :data="[form]" style="width: 100%">
        <el-table-column label="样衣颜色" align="center">
          <template v-for="(entry,index) in form.materialsColorEntries">
            <el-table-column :label="entry.sampleColor.name" :key="'col'+index">
              <template slot-scope="scope">
                <el-select v-model="scope.row.materialsColor" filterable
                  :filter-method="(val)=>onFilterInput(scope.row,'materialsColor',val)" allow-create
                  placeholder="选取或填写">
                  <el-option v-for="item in form.colors" :key="item.name" :label="item.name" :value="item.name">
                  </el-option>
                </el-select>
              </template>
            </el-table-column>
          </template>
        </el-table-column>
      </el-table>


      <h6 style="margin-top:20px">对应尺码：</h6>
      <template v-for="rowIndex in sizeRows">
        <el-row type="flex" justify="start" :key="'sizeRows'+rowIndex" :gutter="20" style="margin-top:10px">
          <template v-for="colIndex in countSizeRowLength(rowIndex)">
            <el-col :span="8" :key="'sizeCols'+colIndex">
              <!-- <el-form-item :label="form.materialsSizeEntries[((rowIndex-1)*columnNum+colIndex-1)].sampleSize.name"
                label-width="100px">
                <el-input v-model="form.materialsSizeEntries[((rowIndex-1)*columnNum+colIndex-1)].materialsSize">
                </el-input>
              </el-form-item> -->
              <el-table :data="[form.materialsSizeEntries[((rowIndex-1)*columnNum+colIndex-1)]]" border
                style="width: 100%;">
                <el-table-column :resizable="false" prop="sampleSize.name" label="样衣尺码">
                </el-table-column>
                <el-table-column :resizable="false" label="物料尺码">
                  <template slot-scope="scope">
                    <el-select v-model="scope.row.materialsSize" filterable allow-create placeholder="选取或填写">
                      <el-option v-for="item in []" :key="item.name" :label="item.name" :value="item.name">
                      </el-option>
                    </el-select>
                  </template>
                </el-table-column>
              </el-table>
            </el-col>
          </template>
        </el-row>
      </template>
      <el-row type="flex" justify="center" style="margin-top:20px;">
        <el-button type="primary" @click="onSubmit" class="material-btn_submit">保存</el-button>
        <el-button class="material-btn_cancel">取消</el-button>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import {
    MaterialSingleSelect
  } from "../../../product/material/components/index";


  export default {
    name: "MaterialSpecEntryForm",
    props: {
      entry: {
        type: Object
      },
      //列数
      columnNum: {
        type: Number,
        default: 3
      }
    },
    components: {
      MaterialSingleSelect
    },
    computed: {
      //颜色行数
      colorRows: function () {
        return Math.ceil(this.form.materialsColorEntries.length / this.columnNum);
      },
      //尺码行数
      sizeRows: function () {
        return Math.ceil(this.form.materialsSizeEntries.length / this.columnNum);
      },
      //实际用量
      actualUsage: function () {
        if (Number.isNaN(parseFloat(this.form.lossRate))) {
          return this.form.unitQuantity;
        } else {
          return (this.form.unitQuantity * (1 + parseFloat(this.form.lossRate) / 100)).toFixed(2);
        }
      },
      specs: function () {
        let specs = [];
        this.form.variants.forEach(variant => {
          if (specs.findIndex(item => item.code == variant.spec.code) == -1) {
            //颜色
            var colors = [];
            this.form.variants.filter(v => v.spec.code == variant.spec.code).forEach(v => {
              if (colors.findIndex(obj => obj.code == v.color.code) == -1) {
                colors.push(v.color);
              }
            });
            variant.spec['colors'] = colors;
            specs.push(variant.spec);
          }
        });
        return specs;
      },
    },
    methods: {
      //选择器输入框输入改值
      onFilterInput(obj, key, val) {
        this.$set(obj, key, val);
      },
      //获取颜色当前行对应数量
      countColorRowLength(rowIndex) {
        return (rowIndex * this.columnNum > this.form.materialsColorEntries.length) ? (this.form.materialsColorEntries
          .length %
          this.columnNum) : this.columnNum;
      },
      //获取尺码当前行对应数量
      countSizeRowLength(rowIndex) {
        return (rowIndex * this.columnNum > this.form.materialsSizeEntries.length) ? (this.form.materialsSizeEntries
          .length %
          this.columnNum) : this.columnNum;
      },
      onMaterialsEntriesAdd(val) {
        this.form.colors = val.colors;
        this.form.specs = val.specs;
        this.form.materialsName = val.name;
        this.form.materialsCode = val.code;
        this.form.materialsId = val.id;
        this.form.variants = val.variants;
        this.dialogVisible = false;
      },
      onSubmit() {
        this.$refs['form'].validate(valid => {
          if (valid) {
            //整理数据
            let result = Object.assign({}, this.form);
            //百分比数修改
            result.lossRate = parseFloat(result.lossRate) / 100.0;
            this.$emit('confirmMaterial', result);
          } else {
            this.$message.error('请完善信息');
            return false;
          }
        });
      }
    },
    data() {
      return {
        form: {
          title: '',
          position: '',
          materialsId: '',
          materialsCode: '',
          materialsName: '',
          materialUnit: '',
          materialType: '',
          unitQuantity: '',
          lossRate: '',
          variants: [],
          materialWidth: '',
          materialComposition: '',
          specWeight: '',
          colors: [],
          specs: [],
          materialsColorEntries: [],
          materialsSizeEntries: []
        },
        dialogVisible: false
      };
    },
    watch: {

    },
    created() {
      if (this.entry != null) {
        Object.assign(this.form, JSON.parse(JSON.stringify(this.entry)));
        //百分比数修改
        if (Number.isNaN(parseFloat(this.entry.lossRate))) {
          this.form.lossRate = 0;
        } else {
          this.form.lossRate = parseFloat(this.entry.lossRate) * 100.0;
        }
      }
    }
  };

</script>
<style scoped>
  .form-body {
    padding-top: 20px;
  }

  .material-btn_submit {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  .material-btn_cancel {
    width: 90px;
    height: 35px;
  }

</style>
