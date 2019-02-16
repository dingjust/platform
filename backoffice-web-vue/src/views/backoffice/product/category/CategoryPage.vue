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
      <el-tree ref="tree" node-key="id" :default-expand-all="true" :data="items" :props="defaultProps"
               :expand-on-click-node="false"
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
               :visible.sync="iconFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <category-icon-form ref="iconForm"
                          :slot-data="rowData">
      </category-icon-form>
      <div>
        <template>
          <img :src="rowData.thumbnail"/>
        </template>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="onSubmitIconForm(rowData)">确 定</el-button>
        <el-button @click="iconFormDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('CategoriesModule');

  import {
    CategoryForm,
    CategoryDetailPage,
    CategoryIconForm,
    CategoryProductsPage
  } from "./";

  export default {
    components: {CategoryIconForm, CategoryProductsPage},
    computed: {
      ...mapGetters({
        items: "items"
      })
    },
    methods: {
      ...mapActions({
        search: "search"
      }),
      onFilter(value, data) {
        if (!value) {
          return true;
        }

        return data.name.indexOf(value) !== -1;
      },
      onSearch() {
        this.search();
      },
      onAppend(data) {
        if (!data.children) {
          this.$set(data, "children", []);
        }

        this.formData["parent"] = {
          code: data.code,
          name: data.name
        };

        this.fn.openSlider("添加分类", CategoryForm, this.formData);
      },
      onUpdateIcon(data) {
        // console.log(data);
        this.rowData = data;
        this.iconFormDialogVisible = true;
      },
      onDetail(data) {
        // console.log(data);
        this.fn.openSlider("详情", CategoryDetailPage, data);
      },
      onSubmitIconForm(rowData) {
        // console.log(rowData);
        this.$refs["iconForm"].onSubmit();
        this.iconFormDialogVisible = false;
        this.fn.closeSlider();
      },
      onProducts(data) {
        this.fn.openSlider("查看产品", CategoryProductsPage, data);
      }
    },
    watch: {
      filterText(val) {
        this.$refs['tree'].filter(val);
      },
    },
    data() {
      return {
        filterText: "",
        defaultProps: {
          children: "children",
          label: "name"
        },
        iconFormDialogVisible: false,
        formData: this.$store.state.CategoriesModule.formData,
        rowData: []
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
