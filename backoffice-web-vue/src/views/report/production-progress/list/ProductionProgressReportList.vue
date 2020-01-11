<template>
  <div class="animated fadeIn">
    <el-table
      ref="resultTable"
      stripe
      :data="page.content"
      v-if="isHeightComputed"
      :height="autoHeight+50"
    >
      <el-table-column label="订单号" fixed min-width="100">
        <template slot-scope="scope">
          <el-row type="flex">
            <span>{{scope.row.code}}</span>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="产品名" prop="product.name"></el-table-column>
      <el-table-column label="货号" prop="product.skuID"></el-table-column>
      <el-table-column label="跟单员" header-align="center" min-width="100">
        <template slot-scope="scope">
          <span>{{getOperatorName(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="工厂/客户" min-width="120">
        <template slot-scope="scope">
          <span>{{getName(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="价格" prop="totalPrice"></el-table-column>
      <el-table-column label="数量">
        <template slot-scope="scope">
          <span>{{countTotalQuantity(scope.row.entries)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="交期" prop="expectedDeliveryDate" :min-width="100">
        <template slot-scope="scope">
          <span>{{scope.row.expectedDeliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" prop="status" :column-key="'status'">
        <template slot-scope="scope">
          <span>{{getEnum('purchaseOrderStatuses', scope.row.status)}}</span>
        </template>
      </el-table-column>
      <template v-for="status in productionProgressPhaseTypes">
        <el-table-column :label="status.name" :key="status.code" header-align="center">
          <el-table-column label="预计完成时间" min-width="100" header-align="center">
            <template slot-scope="scope">
              <span>{{getProductionProgress(scope.row,status.code).estimatedDate | timestampToTime}}</span>
            </template>
          </el-table-column>
          <el-table-column label="实际完成时间" min-width="100">
            <template slot-scope="scope">
              <span>{{getProductionProgress(scope.row,status.code).finishDate | timestampToTime}}</span>
            </template>
          </el-table-column>
          <el-table-column label="完成数量" min-width="100">
            <template slot-scope="scope">
              <span>{{getProductionProgress(scope.row,status.code).completeAmount}}</span>
            </template>
          </el-table-column>
        </el-table-column>
      </template>
    </el-table>
    <div class="pt-2"></div>
    <!-- <div class="float-right"> -->
    <el-pagination
      class="pagination-right"
      layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged"
      @current-change="onCurrentPageChanged"
      :current-page="page.number + 1"
      :page-size="page.size"
      :page-count="page.totalPages"
      :total="page.totalElements"
    ></el-pagination>
    <!-- </div> -->
  </div>
</template>

<script>
import { createNamespacedHelpers } from "vuex";

const { mapActions } = createNamespacedHelpers(
  "ProductionProgressReportModule"
);

export default {
  name: "ProductionProgressReportList",
  props: ["page"],
  components: {},
  computed: {},
  methods: {
    ...mapActions({
      refresh: "refresh"
    }),
    onPageSizeChanged(val) {
      this._reset();

      if (this.$store.state.PurchaseOrdersModule.isAdvancedSearch) {
        this.$emit("onAdvancedSearch", val);
        return;
      }

      this.$emit("onSearch", 0, val);
    },
    onCurrentPageChanged(val) {
      if (this.$store.state.PurchaseOrdersModule.isAdvancedSearch) {
        this.$emit("onAdvancedSearch", val - 1);
        return;
      }

      this.$emit("onSearch", val - 1);
      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0;
      });
    },
    _reset() {
      this.$refs.resultTable.clearSort();
      this.$refs.resultTable.clearFilter();
      this.$refs.resultTable.clearSelection();
    },
    onDetails(row) {
      this.$emit("onDetails", row);
    },
    countTotalQuantity(entries) {
      let amount = 0;
      entries.forEach(element => {
        amount += element.quantity;
      });
      return amount;
    },
    getPaymentStatusTag(row) {
      return row.payStatus === "PAID"
        ? "static/img/paid.png"
        : "static/img/arrears.png";
    },
    getSignedTag(row) {
      if (row.userAgreementIsSigned == null) {
        return "static/img/not_signed.png";
      } else {
        return row.userAgreementIsSigned
          ? "static/img/signed.png"
          : "static/img/not_signed.png";
      }
    },
    getOperator(row) {
      if (
        this.$store.getters.currentUser.type == "BRAND" &&
        row.brandOperator != null
      ) {
        return row.brandOperator.name;
      } else if (
        this.$store.getters.currentUser.type == "FACTORY" &&
        row.factoryOperator != null
      ) {
        return row.factoryOperator.name;
      } else {
        return "";
      }
    },
    onUpdate(row) {
      this.$emit("onUpdate", row);
    },
    getOperatorName(row) {
      if (this.isBrand()) {
        if (row.brandOperator != null) {
          return row.brandOperator.name;
        } else {
          return "";
        }
      } else {
        if (row.factoryOperator != null) {
          return row.factoryOperator.name;
        } else {
          return "";
        }
      }
    },
    getProductionProgress(row, status) {
      var result = row.progresses.filter(progress => progress.phase == status);
      if (result.length != 0) {
        return result[0];
      } else {
        return null;
      }
    },
    getName(row) {
      if (this.isFactory()) {
        if (row.purchaser != null) {
          return row.purchaser.name;
        } else {
          return "";
        }
      } else {
        if (row.belongTo != null) {
          return row.belongTo.name;
        } else {
          return "";
        }
      }
    }
  },
  data() {
    return {
      productionProgressPhaseTypes: this.$store.state.EnumsModule
        .productionProgressPhaseTypes
    };
  }
};
</script>
<style>
.purchase-list-button {
  color: #ffa403;
}
</style>
