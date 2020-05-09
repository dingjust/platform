<template>
  <div>
    <el-dialog :visible.sync="materialSpecEntriesVisible" width="95%" class="purchase-dialog"
      :close-on-click-modal="false">
      <material-spec-entries-form :slotData="slotData.entries" @onSubmit="onMaterialEnriesSubmit" v-if="hackSet"
        :colors="clothesColors" />
    </el-dialog>
    <el-tabs v-model="activeName" type="border-card">
      <el-tab-pane label="物料清单" name="material">
        <el-row type="flex" justify="end" style="margin-bottom:10px">
          <el-col :span="2">
            <el-button>预览</el-button>
          </el-col>
          <el-col :span="2">
            <el-button @click="onEdit">编辑</el-button>
          </el-col>
        </el-row>
        <material-spec-entries-table :colors="clothesColors" :slotData="slotData.entries" />
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
  import MaterialSpecEntriesForm from "./MaterialSpecEntriesForm";
  import MaterialSpecEntriesTable from "../components/MaterialSpecEntriesTable";


  export default {
    name: "SampleAttachOrdersForm",
    props: ["slotData", "readOnly", "isRead"],
    components: {
      ImagesUpload,
      FilesUpload,
      MaterialSpecEntriesForm,
      MaterialSpecEntriesTable
    },
    computed: {
      clothesColors: function () {
        var result = [];
        if (this.slotData.colorSizes != null && this.slotData.colorSizes.length > 0) {
          this.slotData.colorSizes.forEach(element => {
            let item = element[0];
            if (item != null) {
              result.push({
                'id': item.id,
                'code': item.colorCode,
                'name': item.color,
                'previewImg': item.previewImg
              });
            }
          });
        }
        return result;
      },
    },
    methods: {
      async onEdit() {
        //颜色尺码没填写提示
        if (this.slotData.colorSizes != null && this.slotData.colorSizes[0] != null && this.slotData.colorSizes[0][
            0
          ] !=
          null) {
          //重置组件
          this.hackSet = false;
          this.$nextTick(() => {
            this.hackSet = true;
          });
          await this.validateMaterials();
          this.materialSpecEntriesVisible = true;
        } else {
          this.$message({
            message: '添加物料前请先选择商品颜色和尺码',
            type: 'warning'
          });
        }
      },
      onMaterialEnriesSubmit(materialList) {
        this.materialSpecEntriesVisible = false;
        //拷贝
        var result = [];

        for (let index in materialList) {
          let obj = Object.assign({}, materialList[index]);
          obj['uniqueCode'] = index;
          result.push(obj);
        }

        // materialList.forEach(material => {
        //   result.push(Object.assign({}, material));
        // });


        //过滤未选择颜色
        result.forEach(material => {
          var newEntries = material.materialsColorEntries.filter(element => element
            .materialsColor != null && element.materialsColor != "");
          material.materialsColorEntries = newEntries;
        })
        this.$set(this.slotData, 'entries', result);
      },
      //校验物料列表数据完整性，若缺少相应颜色数据等则查询物料详情  
      async validateMaterials() {
        for (let entry of this.slotData.entries) {
          if (entry.variants == null) {
            //查询物料详情
            const url = this.apis().getMaterialDetails(entry.materialsId);
            const result = await this.$http.get(url);
            entry['variants'] = result.data.variants;
          }
        }
      }
    },
    data() {
      return {
        materialSpecEntriesVisible: false,
        activeName: "material",
        hackSet: true
      };
    },
    created() {

    }
  };

</script>
<style scoped>
  /deep/ .el-table--enable-row-hover .el-table__body tr:hover>td {
    background-color: #f5f7fa !important;
  }

</style>
