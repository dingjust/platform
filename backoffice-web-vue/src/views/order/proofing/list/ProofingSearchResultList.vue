<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" v-if="isHeightComputed" :height="autoHeight">
      <el-table-column label="打样订单号" prop="code"></el-table-column>
      <el-table-column label="打样订单状态" prop="status">
        <template slot-scope="scope">
          <el-tag disable-transitions>{{getEnum('proofingOrderStatuses', scope.row.status)}}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="订单生成时间" prop="creationtime">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="需求订单号" prop="requirementOrderRef"></el-table-column>
      <el-table-column label="报价订单号" prop="quoteRef"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">明细</el-button>
          <el-button v-if="canUpdateAddress(scope.row)" type="text" icon="el-icon-edit"
                     @click="onUpdateAddress(scope.row)">
            修改地址
          </el-button>
          <el-button type="text" icon="el-icon-edit"
                     @click="onShowQuote(scope.row)">
            查看报价单
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
    name: 'ProofingSearchResultList',
    props: ["page"],
    components: {AddressForm},
    computed: {},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onPageSizeChanged(val) {
        this._reset();

        if (this.advancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.advancedSearch) {
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
      onShowQuote(row) {
        this.$emit('onShowQuote', row);
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
        const url = this.apis().updateDeliveryAddressOfProofing(row.code);
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
        addressDialogVisible: false,
        addressFormData: this.$store.state.ProofingsModule.addressFormData,
        currentRow: null
      }
    },
    created() {
    }
  }
</script>
