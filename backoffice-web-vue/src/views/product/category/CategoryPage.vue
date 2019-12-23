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
    <el-dialog :visible.sync="CategoryDetailsPageVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <category-details-page v-if="CategoryDetailsPageVisible" :slot-data="itemData" :operationType="operationType" @operationTypeTurn="operationTypeTurn"></category-details-page>
    </el-dialog>
    <el-card>
      <el-input placeholder="输入关键字进行过滤" v-model="filterText"> </el-input>
      <div class="pt-2"></div>
      <el-tree ref="tree" node-key="id" :default-expand-all="true" :data="items" :props="defaultProps"
               :expand-on-click-node="true"
               :filter-node-method="onFilter">
        <span class="custom-tree-node" slot-scope="{ node, data }">
          <span>{{ node.label }}</span>
          <span>
            <el-button type="text" size="mini" @click="() => onDetail(data)">
              修改
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

  import CategoryDetailsPage from './details/CategoryDetailsPage';

  export default {
    components: {CategoryDetailsPage},
    computed: {
      ...mapGetters({
        items: 'items'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        refresh: 'refresh'
      }),
      onFilter (value, data) {
        if (!value) {
          return true;
        }

        return data.name.indexOf(value) !== -1;
      },
      onSearch () {
        const url = this.apis().getCategories();
        this.search({url});
      },
      onAppend (data) {
        if (!data.children) {
          this.$set(data, 'children', []);
        }

        this.formData['parent'] = {
          code: data.code,
          name: data.name
        };
        this.formData['thumbnail'] = null;
        console.log(this.formData);
        this.itemData = Object.assign({}, this.formData);
        this.CategoryDetailsPageVisible = true;
        this.operationType = 'create';
        // this.fn.openSlider('添加分类', CategoryDetailsPage, this.formData);
      },
      async onDetail (data) {
        let formData = await this.getCategory(data);
        if (formData == null || formData === undefined) {
          return;
        }
        console.log(formData);
        this.CategoryDetailsPageVisible = true;
        // this.itemData = data;
        this.itemData = Object.assign({}, formData);
        this.operationType = 'update';
        // this.fn.openSlider('详情', CategoryDetailsPage, data);
      },
      async getCategory (data) {
        const url = this.apis().getCategory(data.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        return result;
      },
      operationTypeTurn () {
        this.CategoryDetailsPageVisible = !this.CategoryDetailsPageVisible;
      },
    },
    watch: {
      filterText (val) {
        this.$refs['tree'].filter(val);
      }
    },
    data () {
      return {
        filterText: '',
        defaultProps: {
          children: 'children',
          label: 'name'
        },
        iconFormDialogVisible: false,
        formData: this.$store.state.CategoriesModule.formData,
        rowData: [],
        itemData: '',
        CategoryDetailsPageVisible: false,
        operationType: '',
        nodeIdGroup: []
      };
    },
    created () {
      this.onSearch();
    }
  };
</script>
