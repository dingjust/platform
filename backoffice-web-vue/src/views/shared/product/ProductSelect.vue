<template>
  <div class="animated fadeIn">
    <el-form :inline="true">
      <el-form-item label="">
        <el-input placeholder="请输入产品货号/名称" v-model="keyword"></el-input>
      </el-form-item>
      <el-button-group>
        <el-button type="primary" icon="el-icon-search" @click="onSearch">查询产品</el-button>
      </el-button-group>
    </el-form>
    <el-dialog title="请选择商品"
               :visible.sync="dialogVisible"
               :modal="false"
               :show-close="false">
      <product-select-list :multiple-selection="false" :page="page"
                           @onSelected="onSelected"
                           @onPageSizeChanged="onPageSizeChanged"
                           @onCurrentPageChanged="onCurrentPageChanged">
      </product-select-list>
      <span slot="footer" class="dialog-footer">
        <el-button @click="onCancel">取 消</el-button>
        <el-button type="primary" :disabled="confirmDisabled" @click="onConfirm">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
  import ProductSelectList from './ProductSelectList';

  export default {
    name: 'ProductSelect',
    components: {ProductSelectList},
    mixins: [],
    computed: {},
    methods: {
      onSearch() {
        // console.log('keyword: ' + this.keyword);

        this._onSearch(0, this.page.size);

        this.dialogVisible = true;
      },
      onSelected(product) {
        this.selectedProduct = {};
        Object.assign(this.selectedProduct, product);
        this.confirmDisabled = false;
      },
      onConfirm() {
        this.$emit('onSelected', this.selectedProduct);

        this.dialogVisible = false;
      },
      onCancel() {
        this.selectedProduct = null;
        this.dialogVisible = false;
      },
      async _onSearch(page, size) {
        const keyword = this.keyword;
        const result = await this.$http.post('/b2b/products/apparel', {
          keyword: keyword
        });

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        // console.log('product: ' + JSON.stringify(result));
        this.page = result;
      },
      onPageSizeChanged(val) {
        this._onSearch(0, val);
      },
      onCurrentPageChanged(val) {
        this._onSearch(val - 1);
      },
    },
    data() {
      return {
        keyword: '',
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        },
        selectedProduct: null,
        confirmDisabled: true,
        dialogVisible: false
      }
    },
    created() {
    }
  }
</script>
