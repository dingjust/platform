<template>
  <div>
    <el-dialog :visible.sync="materialSpecEntriesVisible" width="95%" class="purchase-dialog" :append-to-body="true"
      :close-on-click-modal="false">
      <material-spec-entries-form :slotData="curEntries" @onSubmit="onMaterialEnriesSubmit" v-if="hackSet"
        :colors="productsColors" />
    </el-dialog>
    <div class="over-tabs">
      <el-row type="flex" justify="end">
        <el-col :span="5">
          <el-button class="material-btn">校对预览</el-button>
        </el-col>
        <el-col :span="5" v-show="!isRead">
          <el-button @click="onEdit" class="material-btn">编辑</el-button>
        </el-col>
      </el-row>
    </div>
    <el-tabs v-model="activeName" type="border-card">
      <el-tab-pane label="物料清单" name="material">
        <material-spec-entries-table :colors="productsColors" :slotData="curEntries" />
      </el-tab-pane>
      <el-tab-pane label="生产工艺单" name="craft">
        <el-input type="textarea" placeholder="输入工艺要求" v-model="curProductionProcessContent" :rows="10"
          :disabled="isRead">
        </el-input>
        <h6 style="margin-top:10px;">上传工艺单文件</h6>
        <files-upload class="product-images-form-upload" style="margin-top:20px" :slot-data="curMedias"
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
    props: {
      entries: {
        type: Array,
        default: ()=>{
          return [];
        }
      },
      productionProcessContent: {
        type: String,
        default: ''
      },
      medias: {
        type: Array,
        default: () => {
          return [];
        }
      },
      productsColors: {
        type: Array,
        default: () => {
          return [];
        }
      },
      isRead: {
        type: Boolean,
        default: false
      }
    },
    components: {
      ImagesUpload,
      FilesUpload,
      MaterialSpecEntriesForm,
      MaterialSpecEntriesTable
    },
    computed: {

    },
    methods: {
      async onEdit() {
        //颜色尺码没填写提示
        if (this.productsColors != null && this.productsColors[0] != null) {
          //重置组件
          this.hackSet = false;
          this.$nextTick(() => {
            this.hackSet = true;
          });
          await this.validateMaterials();
          this.materialSpecEntriesVisible = true;
        } else {
          this.$message({
            message: '编辑物料前请先完善商品颜色',
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
        });


        let newIds = [];
        result.forEach(entry => {
          newIds.push(entry.id);
        });

        this.$set(this, 'curEntries', result);
        //通知更新对应核算单数据
        this.$emit('onSpecEntryUpdate', newIds);
      },
      //校验物料列表数据完整性，若缺少相应颜色数据等则查询物料详情  
      async validateMaterials() {
        for (let entry of this.curEntries) {
          if (entry.variants == null) {
            //查询物料详情
            const url = this.apis().getMaterialDetails(entry.materialsId);
            const result = await this.$http.get(url);
            entry['variants'] = result.data.variants;
          }
        }
      },
    },
    data() {
      return {
        materialSpecEntriesVisible: false,
        activeName: "material",
        hackSet: true,
        curEntries: this.entries,
        curMedias: this.medias,
        curProductionProcessContent: this.productionProcessContent
      };
    },
    watch: {
      entries: function (newVal, oldVal) {
        this.curEntries = newVal;
      },
      curEntries: function (newVal, oldVal) {
        this.$emit("update:entries", newVal);
      },
      productionProcessContent: function (newVal, oldVal) {
        this.curProductionProcessContent = newVal;
      },
      curProductionProcessContent: function (newVal, oldVal) {
        this.$emit("update:productionProcessContent", newVal);
      },
      medias: function (newVal, oldVal) {
        this.curMedias = newVal;
      },
      curMedias: function (newVal, oldVal) {
        this.$emit("update:medias", newVal);
      },
    },
    created() {

    }
  };

</script>
<style scoped>
  /deep/ .el-table--enable-row-hover .el-table__body tr:hover>td {
    background-color: #f5f7fa !important;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 30px;
    margin-top: 2px;
    width: 500px;
    /* padding-right: 30px; */
  }

</style>
