<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入产品编码" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
        </el-button-group>
      </el-form>
      <el-table ref="resultTable" stripe
                :data="page.content"
                v-if="isHeightComputed" :height="autoHeight">
        <el-table-column type="expand">
          <template slot-scope="props">
            <el-table stripe :data="props.row.stockLevels" row-key="code">
              <el-table-column label="颜色" prop="color.name"></el-table-column>
              <el-table-column label="尺码" prop="size.name"></el-table-column>
              <el-table-column label="实际库存" prop="available"></el-table-column>
              <el-table-column label="虚拟库存" prop="maxPreOrder"></el-table-column>
              <el-table-column label="操作">
                <template slot-scope="scope ">
                  <el-button type="text " icon="el-icon-edit " @click="onUpdateInventory(scope.row) ">
                    调整
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </template>
        </el-table-column>
        <el-table-column label="编码" prop="code"></el-table-column>
        <el-table-column label="名称" prop="name"></el-table-column>
        <el-table-column label="价格" prop="price" :formatter="numberFormatter"></el-table-column>
      </el-table>
      <div class="pt-2 "></div>
      <div class="float-right ">
        <el-pagination layout="total, sizes, prev, pager, next, jumper"
                       @size-change="onPageSizeChanged"
                       @current-change="onCurrentPageChanged"
                       :current-page="page.number + 1"
                       :page-size="page.size"
                       :page-count="page.totalPages"
                       :total="page.totalElements">
        </el-pagination>
      </div>
      <div class="clearfix"></div>
    </el-card>
    <el-dialog title="调整库存" width="70%"
               :visible.sync="formDialogVisible" :close-on-click-modal="false" :modal="false">
      <inventory-base-form ref="InventoryBaseForm"
                           :slot-data="rowData"
                           :read-only="false"
                           :is-newly-created="false">
      </inventory-base-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="onSubmitBaseForm">确 定</el-button>
        <el-button @click="formDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('BrandApparelProductStocksModule');

  import autoHeight from 'mixins/autoHeight';

  import InventoryBaseForm from './InventoryBaseForm';

  export default {
    name: 'InventoryPage',
    components: {InventoryBaseForm},
    mixins: [autoHeight],
    computed: {
      ...mapGetters({
        page: 'page'
      })
    },
    methods: {
      ...mapActions({
        search: 'search'
      }),
      numberFormatter(val) {
        if (val.price !== null && val.price !== '' && val.price !== 'undefined') {
          return parseFloat(val.price).toFixed(2);
        }
      },
      onSearch() {
        this._onSearch(0);
      },
      onPageSizeChanged(val) {
        this.reset();

        this._onSearch(0, val);
      },
      onCurrentPageChanged(val) {
        this._onSearch(val - 1);
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      _onSearch(page, size) {
        const keyword = this.text;
        this.search({keyword, page, size});
      },
      onUpdateInventory(item) {
        this.rowData = {
          code: item.code,
          color: item.color,
          size: item.size,
          available: '',
          maxPreOrder: '',
          beforeAvailable: item.available,
          beforeMaxPreOrder: item.maxPreOrder
        };
        this.formDialogVisible = true;
      },
      async onSubmitBaseForm() {
        const baseForm = this.$refs['InventoryBaseForm'];
        const result = await this.$http.put('/djbrand/stockLevel', baseForm.slotData);
        if (result['errors']) {
          this.$message.error('调整库存失败，原因：' + result['errors'][0].message);
          return;
        }
        this.$message.success('调整库存成功');
        this.formDialogVisible = false;
        this.onSearch();
      }
    },
    data() {
      return {
        text: this.$store.state.BrandApparelProductStocksModule.keyword,
        formData: this.$store.state.BrandApparelProductStocksModule.formData,
        formDialogVisible: false,
        rowData: null
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
