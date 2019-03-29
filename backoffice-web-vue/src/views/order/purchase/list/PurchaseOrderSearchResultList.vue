<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange"
              v-if="isHeightComputed" :height="autoHeight">
      <el-table-column label="生产订单号" prop="code"></el-table-column>
      <el-table-column label="生产订单状态" prop="status" :column-key="'status'"
                       :filters="statuses">
        <template slot-scope="scope">
          <el-tag disable-transitions>{{getEnum('purchaseOrderStatuses', scope.row.status)}}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="预计交货时间" prop="expectedDeliveryDate">
        <template slot-scope="scope">
          <span>{{scope.row.expectedDeliveryDate | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="品牌" v-if="!isBrand()" prop="belongTo.name">
        <template slot-scope="scope">
          <span v-if="scope.row.purchaser">{{scope.row.purchaser.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="工厂" v-if="!isFactory()" prop="belongTo.name">
        <template slot-scope="scope">
          <span v-if="scope.row.belongTo">{{scope.row.belongTo.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单生成时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="需求订单号" prop="requirementOrderCode"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">明细</el-button>
          <el-button v-if="canUpdateAddress(scope.row)" type="text" icon="el-icon-edit"
                     @click="onUpdateAddress(scope.row)">
            修改地址
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <div class="float-right">
      <el-pagination layout="total, sizes, prev, pager, next, jumper"
                     @size-change="onPageSizeChanged"
                     @current-change="onCurrentPageChanged"
                     :current-page="page.number + 1"
                     :page-size="page.size"
                     :page-count="page.totalPages"
                     :total="page.totalElements">
      </el-pagination>
    </div>
    <el-dialog title="地址" :modal="false" :visible.sync="addressDialogVisible"
               :show-close="false" append-to-body width="50%">
      <address-form ref="addressForm" :slot-data="addressFormData"/>
      <span slot="footer" class="dialog-footer">
        <el-button @click="onAddressInputCanceled">取 消</el-button>
        <el-button type="primary" @click="onAddressInputConfirmed">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
  import AddressForm from "@/views/shared/user/address/AddressForm";

  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('PurchaseOrdersModule');

  export default {
    name: 'PurchaseOrderSearchResultList',
    props: ["page"],
    components: {AddressForm},
    computed: {},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      handleFilterChange(val) {
        this.statuses = val.status;

        this.$emit('onSearch', 0);
      },
      onPageSizeChanged(val) {
        this._reset();

        if (this.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val - 1);
          return;
        }

        this.$emit('onSearch', val - 1);
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails(row) {
        this.$emit('onDetails', row);
      },
      onUpdateAddress(row) {
        if (row.deliveryAddress != null) {
          this.addressFormData = Object.assign({}, row.deliveryAddress);
        }

        this.addressDialogVisible = true;

        this.currentRow = row;
      },
      canUpdateAddress(row) {
        return this.isBrand() && row.status === 'PENDING_PAYMENT';
      },
      onAddressInputCanceled() {
        this.addressDialogVisible = false;
      },
      onAddressInputConfirmed() {
        if (this.$refs['addressForm'].validate()) {
          const row = this.currentRow;
          this._updateDeliveryAddress(row);

          this.addressDialogVisible = false;
        }
      },
      async _updateDeliveryAddress(row) {
        const url = this.apis().updateDeliveryAddressOfPurchaseOrder(row.code);
        const result = await this.$http.post(url, this.addressFormData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.error('地址更新成功');
        this.refresh();
      }
    },
    data() {
      return {
        statuses: this.$store.state.PurchaseOrdersModule.statuses,
        isAdvancedSearch: this.$store.state.PurchaseOrdersModule.isAdvancedSearch,
        addressDialogVisible: false,
        addressFormData: this.$store.state.PurchaseOrdersModule.addressFormData,
      }
    }
  }
</script>
