<!-- 
 * @description: BOM及成本核算Form表单
 * @fileName: BOMForm.vue 
 * @author: yj 
 * @date: 2020-06-17 10:45:35
 * @version: V1.0.0 
!-->
<template>
  <div>
    <div class="over-tabs">
      <el-row type="flex" justify="end">
        <el-col :span="5">
          <el-button class="material-btn">校对预览</el-button>
        </el-col>
        <!-- <el-col :span="5" v-show="!isRead">
          <el-button @click="onEdit" class="material-btn">编辑</el-button>
        </el-col> -->
      </el-row>
    </div>
    <el-tabs v-model="activeName" type="border-card">
      <el-tab-pane label="物料清单(BOM)" name="material">
        <material-spec-entries-form :form="curForm" @onSubmit="onMaterialEnriesSubmit" v-if="hackSet"
          :productsColors="productsColors" :productsSizes="productsSizes" />
      </el-tab-pane>
      <el-tab-pane label="成本核算单" name="acountingSheet">
          
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import MaterialSpecEntriesForm from "./MaterialSpecEntriesForm";

  export default {
    name: "BOMForm",
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
      isRead: {
        type: Boolean,
        default: false
      }
    },
    components: {
      MaterialSpecEntriesForm,
    },
    computed: {

    },
    methods: {
      // async onEdit() {
      //   //颜色尺码没填写提示
      //   if (this.productsColors != null && this.productsColors[0] != null) {
      //     //重置组件
      //     this.hackSet = false;
      //     this.$nextTick(() => {
      //       this.hackSet = true;
      //     });
      //     await this.validateMaterials();
      //     this.materialSpecEntriesVisible = true;
      //   } else {
      //     this.$message({
      //       message: '编辑物料前请先完善商品颜色',
      //       type: 'warning'
      //     });
      //   }
      // },
      onMaterialEnriesSubmit(val) {
        
      },
      //校验物料列表数据完整性，若缺少相应颜色数据等则查询物料详情  
      async validateMaterials() {
        // for (let entry of this.curEntries) {
        //   if (entry.variants == null) {
        //     //查询物料详情
        //     const url = this.apis().getMaterialDetails(entry.materialsId);
        //     const result = await this.$http.get(url);
        //     entry['variants'] = result.data.variants;
        //   }
        // }
      },
    },
    data() {
      return {
        materialSpecEntriesVisible: false,
        activeName: "material",
        hackSet: true,
        curForm: this.form,
      };
    },
    watch: {
      form: function (newVal, oldVal) {
        this.form = newVal;
      },
      curForm: function (newVal, oldVal) {
        this.$emit("update:form", newVal);
      },
    },
    created() {

    }
  };

</script>
<style scoped>
  .over-tabs>>>.el-table--enable-row-hover .el-table__body tr:hover>td {
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
