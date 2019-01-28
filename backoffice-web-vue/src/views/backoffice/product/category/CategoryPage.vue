<style type="scss">
  .custom-tree-node {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding-right: 8px;
  }
</style>
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-input placeholder="输入关键字进行过滤" v-model="filterText"></el-input>
      <div class="pt-2"></div>
      <el-tree ref="tree" node-key="id" :default-expand-all="true" :data="results" :props="defaultProps" :expand-on-click-node="false"
               :filter-node-method="onFilter">
        <span class="custom-tree-node" slot-scope="{ node, data }">
          <span>{{ node.label }}</span>
          <span>
            <el-button type="text" size="mini" @click="() => onProducts(data)">
              查看产品
            </el-button>
            <el-button type="text" size="mini" @click="() => onDetail(data)">
              详细
            </el-button>
            <el-button type="text" size="mini" @click="() => onUpdateIcon(data)">
              更新图标
            </el-button>
            <el-button type="text" size="mini" @click="() => onAppend(data)">
              添加子分类
            </el-button>
          </span>
        </span>
      </el-tree>
    </el-card>

    <el-dialog title="更新图标" width="90%"
               :visible.sync="IconFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <category-icon-form ref="iconForm"
                          :slot-data="rowdata">
      </category-icon-form>
      <div>
      <template>
        <img :src="rowdata.thumbnail"/>
      </template>
    </div>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="onSubmitIconForm(rowdata)">确 定</el-button>
        <el-button @click="IconFormDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import axios from "axios";

  import {CategoryForm,CategoryDetailPage} from "./";
  import CategoryIconForm from "./CategoryIconForm";
  import CategoryProductsPage from "./CategoryProductsPage";

  export default {
    components: {CategoryIconForm,CategoryProductsPage},
    watch: {
      filterText(val) {
        this.$refs['tree'].filter(val);
      },
      "$store.state.sideSliderState": function (value) {
        if (!value) {
          this.onSearch();
        }
      }
    },
    methods: {
      onFilter(value, data) {
        if (!value) return true;
        return data.name.indexOf(value) !== -1;
      },
      onSearch() {
        axios.get("/djbackoffice/product/category/categories")
          .then(response => {
            console.log(response.data);
            this.results = response.data;
          }).catch(error => {
          console.error(JSON.stringify(error));
          this.$message.error(error.response.statusText);
        });
      },
      onAppend(data) {
        if (!data.children) {
          this.$set(data, "children", []);
        }

        this.fn.openSlider("添加分类", CategoryForm, {
          id: null,
          code: "",
          name: "",
          group: "",
          description: "",
          parent: {
            code: data.code,
            name: data.name
          }
        });
      },
      onUpdateIcon(data) {
        console.log(data);
        this.rowdata = data;
        this.IconFormDialogVisible = true;
      },
      onDetail(data){
        console.log(data);
        this.fn.openSlider("详情", CategoryDetailPage, data);
      },
      onSubmitIconForm(rowdata) {
        console.log(rowdata);
        this.$refs["iconForm"].onSubmit();
        this.IconFormDialogVisible = false;
        this.fn.closeSlider();
      },
      onProducts(data){
        this.fn.openSlider("查看产品", CategoryProductsPage, data);
      }
    },
    data() {
      return {
        filterText: "",
        results: [],
        defaultProps: {
          children: "children",
          label: "name"
        },
        IconFormDialogVisible: false,
        rowdata: []
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
