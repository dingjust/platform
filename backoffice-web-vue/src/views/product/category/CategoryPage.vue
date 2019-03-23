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
      <el-input placeholder="输入关键字进行过滤" v-model="filterText"> </el-input>
      <div class="pt-2"></div>
      <el-tree ref="tree" node-key="id" :default-expand-all="true" :data="items" :props="defaultProps"
               :expand-on-click-node="false"
               :filter-node-method="onFilter">
        <span class="custom-tree-node" slot-scope="{ node, data }">
          <span>{{ node.label }}</span>
          <span>
            <el-button type="text" size="mini" @click="() => onDetail(data)">
              详细
            </el-button>
            <el-button type="text" size="mini" @click="() => onAppend(data)">
              添加子分类
            </el-button>
          </span>
        </span>
      </el-tree>
    </el-card>

  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('CategoriesModule');

  import CategoryDetailsPage from "@/views/product/category/details/CategoryDetailsPage";


  export default {
    components: {},
    computed: {
      ...mapGetters({
        items: 'items'
      })
    },
    methods: {
      ...mapActions({
        search: 'search'
      }),
      onFilter(value, data) {
        if (!value) {
          return true;
        }

        return data.name.indexOf(value) !== -1;
      },
      onSearch() {
        const url = this.apis().getCategories();
        this.search({url});
      },
      onAppend(data) {
        if (!data.children) {
          this.$set(data, 'children', []);
        }

        this.formData['parent'] = {
          code: data.code,
          name: data.name
        };
        this.fn.openSlider('添加分类', CategoryDetailsPage, this.formData);
      },
      onDetail(data) {
        this.fn.openSlider('详情', CategoryDetailsPage, data);
      },
    },
    watch: {
      filterText(val) {
        this.$refs['tree'].filter(val);
      },
    },
    data() {
      return {
        filterText: '',
        defaultProps: {
          children: 'children',
          label: 'name'
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
