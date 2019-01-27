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
      <el-tree ref="tree" node-key="id"
               :data="results"
               :props="defaultProps"
               :expand-on-click-node="false"
               :filter-node-method="onFilter">
        <span class="custom-tree-node" slot-scope="{ node, data }">
          <span>{{ node.label }}</span>
          <span>
            <el-button type="text" size="mini" @click="() => onUpdateIcon(data)">
              更新图标
            </el-button>
            <el-button type="text" size="mini" @click="() => onAppend(data)">
              添加子分类
            </el-button>
            <el-button type="text" size="mini" @click="() => onDetails(data)">
              明细
            </el-button>
          </span>
        </span>
      </el-tree>
    </el-card>

    <el-dialog title="更新图标" width="90%"
               :visible.sync="ForumIconFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <forum-category-icon-form ref="forumCategoryIconForm"
                          :slot-data="rowdata">
      </forum-category-icon-form>
      <div>
        <template>
          <img :src="rowdata.thumbnail"/>
        </template>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="onSubmitIconForm(rowdata)">确 定</el-button>
        <el-button @click="ForumIconFormDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import axios from "axios";

  import {ForumCategoryForm, ForumCategoryDetailsPage} from "./";
  import ForumCategoryIconForm from "./ForumCategoryIconForm";

  export default {
    components: {ForumCategoryIconForm},
    watch: {
      filterText(val) {
        this.$refs.tree.filter(val);
      }
    },
    methods: {
      onFilter(value, data) {
        if (!value) return true;
        return data.name.indexOf(value) !== -1;
      },
      onSearch() {
        axios.get("/djforum/category")
          .then(response => {
            this.results = response.data;
          }).catch(error => {
            this.$message.error(error.response.data);
          }
        );
      },
      onAppend(data) {
        if (!data.children) {
          this.$set(data, "children", []);
        }

        this.fn.openSlider("添加分类", ForumCategoryForm, {
          id: null,
          code: "",
          name: "",
          description: "",
          parent: {
            code: data.code,
            name: data.name
          }
        });
      },
      onDetails(item) {
        if (!item.parent) {
          this.$set(item, "parent", {
            code: "",
            name: ""
          })
        }

        console.log(item);
        this.fn.openSlider("分类明细", ForumCategoryDetailsPage, item);
      },
      onUpdateIcon(data) {
        console.log(data);
        this.rowdata = data;
        this.ForumIconFormDialogVisible = true;
      },
      onSubmitIconForm(rowdata) {
        console.log(rowdata);
        this.$refs["forumCategoryIconForm"].onSubmit();
        this.ForumIconFormDialogVisible = false;
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
        rowdata:[],
        ForumIconFormDialogVisible:false
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
