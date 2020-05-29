<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="生产订单号" prop="code"></el-table-column>
      <el-table-column label="合作商">
        <template slot-scope="scope">
          <span>{{scope.row.partyACompany.uid == uid
            ? scope.row.partyBCompany.name : scope.row.partyACompany.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="关联产品数">
        <template slot-scope="scope">
          <span>{{scope.row.entries.length}}</span>
        </template>
      </el-table-column>
      <el-table-column label="跟单员">
        <template slot-scope="scope">
          <span>{{getOperatorName(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="审批状态" prop="status">
        <template slot-scope="scope">
          <span>{{getEnum('OutboundOrderStatuses', scope.row.status)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单标签" min-width="100"></el-table-column>
      <el-table-column label="操作" min-width="100">
        <template slot-scope="scope">
          <el-row>
            <el-button type="text" @click="onDetail(scope.row)" class="purchase-list-button">详情</el-button>
            <el-button v-if="isCreate(scope.row)" type="text" @click="onModify(scope.row)" class="purchase-list-button">修改</el-button>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <!-- <div class="float-right"> -->
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <!-- </div> -->
  </div>
</template>

<script>
  export default {
    name: 'OutboundOrderList',
    props: ['page'],
    computed: {
    },
    methods: {
      isCreate (row) {
        const uid = this.$store.getters.currentUser.companyCode;
        // 判断自身是 PARTYA 还是 PARTYB
        let AorB = 'PARTYB'
        if (row.partyACompany.uid == uid) {
          AorB = 'PARTYA';
        }
        return row.createdBy == AorB && row.status == 'NOT_COMMITED';
      },
      getOperatorName(row) {
        let aName = '';
        let bName = '';
        if (row.partyAOperator != null) {
          aName = row.partyAOperator.name;
        }
        if (row.partyBOperator != null) {
          bName = row.partyBOperator.name;
        }
        return row.byAorB == 'PARTYA' ? aName : bName;
      },
      onPageSizeChanged(val) {
        this.$emit('onAdvancedSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        this.$emit('onAdvancedSearch', val - 1);
      },
      onDetail(row) {
        this.$router.push('/sales/outboundOrder/' + row.code);
      },
      onModify(row) {
        this.$emit('onModify', row.code);
      }
    },
    data () {
      return {
        uid: this.$store.getters.currentUser.companyCode
      }
    },
    created () {
    }
  }
</script>

<style scoped>

</style>
