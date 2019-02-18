<template>
  <div class="animated fadeIn">
    <el-card>
      <div slot="header" class="clearfix">
        <span>分类产品列表</span>
        <el-button style="float: right; padding: 3px 0" type="text" @click="searchAllProducts(0,allPage.size)">添加产品
        </el-button>
      </div>
      <el-table ref="resultTable" stripe
                :data="page.content"
                @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="32"></el-table-column>
        <el-table-column label="供应商产品编码" prop="skuID"></el-table-column>
        <el-table-column label="名称" prop="name" width="480"></el-table-column>
        <el-table-column label="商家" prop="belongTo.name"></el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-delete" @click="onDelete(scope.row)">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                     @size-change="onPageSizeChanged"
                     @current-change="onCurrentPageChanged"
                     :current-page="page.number + 1"
                     :page-size="page.size"
                     :page-count="page.totalPages"
                     :total="page.totalElements">
      </el-pagination>
    </el-card>

    <el-dialog title="添加产品" width="90%"
               :visible.sync="productsVialogVisible" :close-on-click-modal="false" :modal="false">

      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入产品编码" v-model="text" style="width: 700px"></el-input>
        </el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="searchAllProducts"></el-button>
      </el-form>
      <el-table ref="allResultTable" stripe
                :data="allPage.content"
                @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="32" fixed></el-table-column>
        <el-table-column label="编码" prop="code" fixed></el-table-column>
        <el-table-column label="供应商产品编码" prop="skuID" fixed></el-table-column>
        <el-table-column label="名称" prop="name"></el-table-column>
      </el-table>
      <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                     @size-change="onAllPageSizeChanged"
                     @current-change="onAllCurrentPageChanged"
                     :current-page="allPage.number + 1"
                     :page-size="allPage.size"
                     :page-count="allPage.totalPages"
                     :total="allPage.totalElements">
      </el-pagination>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="saveProducts()">确 定</el-button>
        <el-button @click="productsVialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  export default {
    name: 'CategoryProductsPage',
    components: {},
    mixins: [],
    props: ['slotData', 'readOnly'],
    computed: {
      codes: function () {
        return this.multipleSelection.map((item, number, any) => {
          console.log(item.code);
          return item.code;
        });
      }
    },
    methods: {
      onPageSizeChanged(val) {
        this.reset();

        this.page.size = val;
        this.onSearch(0, val);
      },
      onCurrentPageChanged(val) {
        this.onSearch(val - 1, this.page.size);
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      async onSearch(page, size) {
        const result = await this.$http.get('/djbackoffice/product/category/products/' + this.slotData.code, {
          page: page,
          size: size
        });


        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.page = result;
      },
      onAllPageSizeChanged(val) {
        this.allReset();

        this.allPage.size = val;
        this.searchAllProducts(0, val);
      },
      onAllCurrentPageChanged(val) {
        this.searchAllProducts(val - 1, this.allPage.size);
      },
      allReset() {
        this.$refs.allResultTable.clearSort();
        this.$refs.allResultTable.clearFilter();
        this.$refs.allResultTable.clearSelection();
      },

      handleSelectionChange(selects) {
        console.log(selects);
        this.multipleSelection = selects;
      },
      async searchAllProducts(page, size) {
        this.productsVialogVisible = true;
        const result = await this.$http.get('/djbackoffice/product', {
          code: this.text,
          page: page,
          size: size
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.allPage = result;
      },
      onDelete(item) {
        this.$confirm('是否删除该产品?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
          center: true
        }).then(() => this._onDelete(item))
      },
      async _onDelete(item) {
        const result = await this.$http.put('/djbackoffice/product/category/removeProduct', null, {
          categoryCode: this.slotData.code,
          productCode: item.code
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('产品删除成功');
        this.onSearch();
      },
      async saveProducts() {
        const result = await this.$http.put('/djbackoffice/product/category/addProducts', {
          categoryCode: this.slotData.code,
          productCodes: this.codes
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('添加产品成功');
        this.productsVialogVisible = false;
        this.onSearch();
      },
    },
    data() {
      return {
        productsVialogVisible: false,
        multipleSelection: [],
        text: '',
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        },
        allPage: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        }
      };
    },
    created() {
      this.onSearch(0, this.page.size);
    }
  };
</script>
