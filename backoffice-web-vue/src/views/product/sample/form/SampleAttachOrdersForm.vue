<template>
  <div>
    <el-dialog :visible.sync="dialogVisible" width="90%" class="purchase-dialog" :close-on-click-modal="false">
      <material-dialog @confirmMaterial="(list)=>onMaterialsEntriesEdit(list,false)" />
    </el-dialog>
    <el-dialog :visible.sync="materialSpecEntriesVisible" width="90%" class="purchase-dialog"
      :close-on-click-modal="false">
      <material-spec-entries-form :slot-data="materialList" :colorSizes="slotData.colorSizes" :isUpdate="isEntryUpdate"
        v-if="hackSet" :materialSpecMap="materialSpecMap" @onSubmit="onMaterialEnriesSubmit" />
    </el-dialog>
    <el-tabs v-model="activeName" type="border-card">
      <el-tab-pane label="物料清单" name="material">
        <el-table :data="tableEntries" style="width: 100%" :span-method="spanMethod" border>
          <el-table-column prop="name" label="物料名称">
          </el-table-column>
          <el-table-column prop="code" label="物料编号" sortable>
          </el-table-column>
          <el-table-column prop="spec" label="物料规格">
            <template slot-scope="scope">
              {{scope.row.spec.name}}
            </template>
          </el-table-column>
          <el-table-column prop="materialsUnit" label="物料单位">
            <template slot-scope="scope">
              {{getEnum('MaterialsUnit', scope.row.materialsUnit)}}
            </template>
          </el-table-column>
          <el-table-column prop="materialsType" label="属性">
            <template slot-scope="scope">
              {{getEnum('MaterialsType', scope.row.materialsType)}}
            </template>
          </el-table-column>
          <el-table-column prop="unitQuantity" label="单位用量">
          </el-table-column>
          <el-table-column prop="lossRate" label="损耗">
            <template slot-scope="scope">
              {{showFloatPercentNum(scope.row.lossRate)+'%'}}
            </template>
          </el-table-column>
          <el-table-column prop="color.name" label="颜色">
          </el-table-column>
          <el-table-column prop="applicableColors" label="适用颜色" min-width="100">
            <template slot-scope="scope">
              <el-select v-model="scope.row.applicableColors" placeholder="请选择" value-key="name" multiple
                :collapse-tags="false" @change="(val)=>onApplicableColorChange(val,scope.row)">
                <el-option v-for="(item,index) in clothesColors" :key="index" :label="item.name" :value="item">
                </el-option>
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="操作">
            <template slot-scope="scope">
              <el-button @click="onRemove(scope.row)" type="text" size="small">删除</el-button>
            </template>
          </el-table-column>
          <el-table-column label="">
            <template slot-scope="scope">
              <el-button @click="onUpdate(scope.row)" type="text" size="small">修改</el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-row type="flex" style="margin-top:10px;">
          <el-col :span="4">
            <el-button icon="el-icon-plus" @click="onAdd">添加物料</el-button>
          </el-col>
        </el-row>
      </el-tab-pane>
      <el-tab-pane label="生产工艺单" name="craft">
        <el-input type="textarea" placeholder="输入工艺要求" v-model="slotData.productionProcessContent" :rows="10">
        </el-input>
        <h6 style="margin-top:10px;">上传工艺单文件</h6>
        <files-upload class="product-images-form-upload" style="margin-top:20px" :slot-data="slotData.medias"
          :read-only="isRead" :disabled="isRead" :limit="8">
        </files-upload>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import {
    accMul,
  } from '@/common/js/number';

  import FilesUpload from "@/components/custom/FilesUpload";
  import ImagesUpload from "@/components/custom/ImagesUpload";
  import MaterialDialog from "@/views/product/material/dialog/MaterialDialog";
  import MaterialSpecEntriesForm from "./MaterialSpecEntriesForm";


  export default {
    name: "SampleAttachOrdersForm",
    props: ["slotData", "readOnly", "isRead"],
    components: {
      ImagesUpload,
      FilesUpload,
      MaterialDialog,
      MaterialSpecEntriesForm
    },
    computed: {
      clothesColors: function () {
        var result = [{
          'name': '全部'
        }];
        this.slotData.colorSizes.forEach(element => {
          result.push({
            'code': element[0].colorCode,
            'name': element[0].color,
            'previewImg': element[0].previewImg
          });
        });

        return result;
      },
      materialSpecMap: function () {
        var map = {};
        this.tableEntries.forEach(element => {
          if (map[element.code] != null) {
            if (map[element.code].findIndex(spec => spec == element.spec.code) == -1) {
              map[element.code].push(element.spec.code);
            }
          } else {
            map[element.code] = [element.spec.code];
          }
        });
        return map;
      },
    },
    methods: {
      onAdd() {
        //颜色尺码没填写提示
        if (this.slotData.colorSizes != null && this.slotData.colorSizes[0] != null && this.slotData.colorSizes[0][0] !=
          null) {
          this.dialogVisible = true;
        } else {
          this.$message({
            message: '添加物料前请先选择商品颜色和尺码',
            type: 'warning'
          });
        }
      },
      //打开物料清单编辑窗口
      onMaterialsEntriesEdit(materialList, isUpdate) {
        var result = [];
        materialList.forEach(material => {
          result.push({
            'id': material.id,
            'code': material.code,
            'name': material.name,
            'materialsUnit': material.materialsUnit,
            'materialsType': material.materialsType,
            'spec': isUpdate ? material.spec : '',
            'unitQuantity': isUpdate ? material.unitQuantity : '',
            'lossRate': isUpdate ? material.lossRate : '',
            'variants': material.variants,
            'materialsColorEntries': [],
            'colors': isUpdate ? material.colors : []
          });
        });
        this.$set(this, 'materialList', result);
        this.dialogVisible = false;
        this.isEntryUpdate = isUpdate;
        this.openSpecEntriesDialog();
      },
      onRemove(row) {
        this.tableEntries.splice(this.tableEntries.indexOf(row), 1);
        //重新合并排序
        this.tableEntries.sort((ob1, ob2) => {
          let v1 = parseInt(ob1.code.replace('MTRL', ''));
          let v2 = parseInt(ob2.code.replace('MTRL', ''));
          return v1 - v2;
        });
        this.getSpanArr(this.tableEntries);
      },
      async onUpdate(row) {
        //查询物料详情
        const url = this.apis().getMaterialDetails(row.id != null ? row.id : row.materialsId);
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        var data = result.data;
        this.$set(data, 'spec', row.spec);
        this.$set(data, 'lossRate', row.lossRate);
        this.$set(data, 'unitQuantity', row.unitQuantity);
        //从tableEntries里遍历当前规格的物料所选中的颜色
        var colors = [];
        this.tableEntries.filter(element => element.spec.code == row.spec.code).forEach(element => {
          colors.push(element.color);
        });
        this.$set(data, 'colors', colors);
        this.onMaterialsEntriesEdit([data], true);
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
        if (val != '' && val.findIndex((item) => item.name == '全部') != -1) {
          row.applicableColors = [{
            'name': '全部'
          }];;
        }
      },
      onMaterialEnriesSubmit() {
        //修改则先移除旧数据
        if (this.isEntryUpdate && this.materialList[0] != null) {
          this.tableEntries = this.tableEntries.filter(element => element.spec.code != this.materialList[0].spec.code);
        }
        this.materialList.forEach(entry => {
          entry.materialsColorEntries.forEach(element => {
            Object.assign(element, entry);
            element['materialsId'] = element.id;
            this.tableEntries.push(element);
          });
        });
        //排序
        this.tableEntries.sort((ob1, ob2) => {
          let v1 = parseInt(ob1.code.replace('MTRL', ''));
          let v2 = parseInt(ob2.code.replace('MTRL', ''));
          return v1 - v2;
        });
        this.materialSpecEntriesVisible = false;
        this.getSpanArr(this.tableEntries);
      },

      spanMethod({
        row,
        column,
        rowIndex,
        columnIndex
      }) {

        if (columnIndex < 7 || columnIndex == 10) {
          const _row = this.spanArr[rowIndex];
          const _col = _row > 0 ? 1 : 0;
          return {
            rowspan: _row,
            colspan: 1
          }
        }
      },
      //合并
      getSpanArr(data) {
        this.spanArr = [];
        for (var i = 0; i < data.length; i++) {
          if (i === 0) {
            this.spanArr.push(1);
            this.pos = 0
          } else {
            // 判断当前元素与上一个元素是否相同
            if (data[i].spec.code === data[i - 1].spec.code) {
              this.spanArr[this.pos] += 1;
              this.spanArr.push(0);
            } else {
              this.spanArr.push(1);
              this.pos = i;
            }
          }
        }
      },
      generateMaterialsColorEntry(entry) {
        let materialsColorEntry = {
          'materialsEntryCode': entry.materialsEntryCode,
          'color': entry.color,
        };
        //适用颜色
        if (entry.applicableColors != null && entry.applicableColors.length > 0 && entry.applicableColors[0].code ==
          null) {
          materialsColorEntry['applicableColors'] = null;
        } else {
          materialsColorEntry['applicableColors'] = entry.applicableColors;
        }
        return materialsColorEntry;
      },
      openSpecEntriesDialog() {
        this.hackSet = false;
        this.$nextTick(() => {
          this.hackSet = true;
        });
        this.materialSpecEntriesVisible = true;
      }
    },
    watch: {
      tableEntries: {
        handler(val) {
          let result = [];
          val.forEach(entry => {
            let materialsColorEntry = {
              'materialsEntryCode': entry.materialsEntryCode,
              'color': entry.color,
            };
            //适用颜色        
            if (entry.applicableColors != null && entry.applicableColors.length > 0 && entry.applicableColors[0]
              .name == '全部'
            ) {
              materialsColorEntry['applicableColors'] = null;
            } else {
              materialsColorEntry['applicableColors'] = entry.applicableColors;
            }
            if (result.findIndex(element => element.materialsCode == entry.code && element.spec.code == entry.spec
                .code) == -1) {
              result.push({
                'materialsId': entry.materialsId,
                'materialsCode': entry.code,
                'materialsName': entry.name,
                'unitQuantity': entry.unitQuantity,
                'lossRate': entry.lossRate,
                'materialsType': entry.materialsType,
                'materialsUnit': entry.materialsUnit,
                'spec': entry.spec,
                'materialsColorEntries': [
                  materialsColorEntry
                ]
              })
            } else {
              let item = result.find(element => element.materialsCode == entry.code);
              item.materialsColorEntries.push(materialsColorEntry);
            }
          });
          this.$set(this.slotData, 'entries', result);
        },
        deep: true
      },
    },
    data() {
      return {
        dialogVisible: false,
        materialSpecEntriesVisible: false,
        activeName: "material",
        textarea1: '',
        materialList: [],
        tableEntries: [],
        spanArr: [],
        isEntryUpdate: false,
        hackSet: true,

      };
    },
    created() {
      // 构造tableEntries
      this.slotData.entries.forEach(entry => {
        entry.materialsColorEntries.forEach(element => {

          this.tableEntries.push({
            'applicableColors': element.applicableColors != null ? element.applicableColors : [{
              'name': '全部'
            }],
            'materialsId': entry.materialsId,
            'materialsEntryCode': element.materialsEntryCode,
            'lossRate': entry.lossRate,
            'color': element.color,
            'code': entry.materialsCode,
            'name': entry.materialsName,
            'materialsType': entry.materialsType,
            'materialsUnit': entry.materialsUnit,
            'spec': entry.spec,
            'unitQuantity': entry.unitQuantity
          });
        });
      });
      //排序
      this.tableEntries.sort((ob1, ob2) => {
        let v1 = parseInt(ob1.code.replace('MTRL', ''));
        let v2 = parseInt(ob2.code.replace('MTRL', ''));
        return v1 - v2;
      });
      this.materialSpecEntriesVisible = false;
      this.getSpanArr(this.tableEntries);
    }
  };

</script>
<style scoped>
</style>
