<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange" v-if="isHeightComputed"
      :row-key="'id'" :height="autoHeight" @selection-change="handleSelectionChange" @row-click="rowClick"
      :reserve-selection="true">
      <el-table-column :key="1" type="selection" :reserve-selection="true" width="50px" :selectable="rowDisabled"
        v-if="!isOutProduction" fixed />
      <el-table-column :key="2" label="生产订单号" min-width="115">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" v-if="!isAllocating && !isOutProduction">
            <el-tag v-if="scope.row.type!=null" type="info" effect="plain" :style="orderTypeTagMap[scope.row.type]">
              {{getEnum('ProductionTaskOrderType', scope.row.type)}}</el-tag>
          </el-row>
          <el-row type="flex" justify="space-between" align="middle" v-if="isOutProduction">            
            <el-tag v-if="scope.row.managementMode=='AUTOGESTION'" type="warning">自管</el-tag>
            <el-tag v-else type="success">协同</el-tag>
          </el-row>
          <el-row type="flex" justify="space-between" align="middle">
            <span>{{scope.row.code}}</span>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column :key="3" label="产品" min-width="180">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" :gutter="50">
            <el-col :span="6">
              <img width="54px" v-if="scope.row.product!=null" height="54px"
                :src="scope.row.product.thumbnail!=null&&scope.row.product.thumbnail.length!=0?scope.row.product.thumbnail.url:'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <el-row>
                <span>{{scope.row.product!=null?scope.row.product.name:''}}</span>
              </el-row>
              <el-row>
                <span>货号:{{scope.row.product!=null?scope.row.product.skuID:''}}</span>
              </el-row>
              <el-row>
                <!-- <span>数量:{{countTotalQuantity(scope.row.entries)}}</span> -->
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column :key="4" label="品类" min-width="115">
        <template slot-scope="scope">
          <span>{{scope.row.product !=null ? 
            scope.row.product.category.parent.name + '-' + scope.row.product.category.name : ''}}</span>
        </template>
      </el-table-column>
      <el-table-column :key="5" label="合作商" v-if="mode=='import'" :show-overflow-tooltip="true">
        <template slot-scope="scope">
          <template v-if="scope.row.originCooperator">
            <span
              v-if="scope.row.originCooperator.type=='ONLINE'">{{scope.row.originCooperator.partner?scope.row.originCooperator.partner.name:''}}</span>
            <span v-else>{{scope.row.originCooperator.partner?scope.row.originCooperator.partner.name:''}}</span>
          </template>
        </template>
      </el-table-column>
      <el-table-column :key="6" label="合作商" v-if="mode=='export'" :show-overflow-tooltip="true">
        <template slot-scope="scope">
          <!-- 自管类型 -->
          <template v-if="scope.row.managementMode!=null&&scope.row.managementMode=='AUTOGESTION'">
            <span>{{scope.row.targetCooperator?scope.row.targetCooperator.name:''}}</span>
          </template>
          <template v-else>
            <span>{{scope.row.belongTo.name}}</span>
          </template>
        </template>
      </el-table-column>
      <el-table-column :key="7" label="订单数量" prop="quantity" min-width="70"></el-table-column>
      <el-table-column :key="9" label="跟单员" prop="merchandiser.name" min-width="60" v-if="!isAllocating"
        :show-overflow-tooltip="true">
      </el-table-column>
      <el-table-column :key="10" label="创建时间" min-width="120">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column :key="11" label="交货时间" min-width="90">
        <template slot-scope="scope">
          <span>{{scope.row.deliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column :key="12" label="标签" v-if="!isOutProduction && !isAllocating">
        <template slot-scope="scope">
          <el-tag color="#FFD60C" style="color: #303133" v-if="scope.row.type == 'SELF_PRODUCED'">自产</el-tag>
          <el-tag :color="isOuted(scope.row) ? '#FFD60C':'#ffffff'" style="color: #303133" v-else>
            {{isOuted(scope.row) ? '已外发' : '未外发'}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column :key="13" label="状态" min-width="60" v-if="!isAllocating">
        <template slot-scope="scope">
          <span>{{stateName(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column :key="14" label="操作" min-width="80">
        <template slot-scope="scope">
          <el-row>
            <el-button type="text" @click="onDetails(scope.row)" class="purchase-list-button">明细</el-button>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions
  } = createNamespacedHelpers('ProductionOrderModule');

  export default {
    name: 'ProductionOrderList',
    props: {
      page: {
        type: Object,
        required: true
      },
      vSelectRow: {
        type: Array
      },
      isOutProduction: {
        type: Boolean,
        default: false
      },
      isAllocating: {
        type: Boolean,
        default: false
      },
      //类型, import为自己生产,export为外发生产
      mode: {
        type: String,
        default: 'import'
      }
    },
    components: {},
    computed: {},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      stateName(row) {
        if (row.state == 'TO_BE_ALLOCATED') {
          return '待生产';
        }
        return this.getEnum('ProductionTaskOrderState', row.state)
      },
      isOuted(row) {
        if (row.outboundOrderCode) {
          return true;
        }
        return false;
      },
      handleFilterChange(val) {
        this.statuses = val.status;

        this.$emit('onSearch', 0);
      },
      onPageSizeChanged(val) {
        // this._reset();

        // if (this.$store.state.ProductionOrderModule.isAdvancedSearch) {
        //   this.$emit('onAdvancedSearch', val);
        //   return;
        // }

        this.$emit('onAdvancedSearch', 0, val);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      onCurrentPageChanged(val) {
        // if (this.$store.state.ProductionOrderModule.isAdvancedSearch) {
        //   this.$emit('onAdvancedSearch', val - 1);
        //   return;
        // }

        this.$emit('onAdvancedSearch', val - 1, 10);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails(row) {
        this.$router.push('/sales/productionOrder/' + row.id);
      },
      countTotalQuantity(entries) {
        let amount = 0;
        entries.forEach(element => {
          amount += element.quantity;
        });
        return amount;
      },
      rowDisabled(row, index) {
        if (this.isAllocating && row.productionLeader) {
          return this.$store.getters.currentUser.uid === row.productionLeader.uid;
        }
        if (row.merchandiser && row.outboundOrderCode == null) {
          return this.$store.getters.currentUser.uid === row.merchandiser.uid
        }
        return false;
      },
      handleSelectionChange(val) {
        this.selectRow = val;
      },
      rowClick(row, column, event) {
        if (this.isAllocating && row.productionLeader && this.$store.getters.currentUser.uid === row.productionLeader
          .uid) {
          this.$refs.resultTable.toggleRowSelection(row);
        } else if (row.merchandiser && row.outboundOrderCode == null && this.$store.getters.currentUser.uid === row
          .merchandiser.uid) {
          this.$refs.resultTable.toggleRowSelection(row);
        }
      },
      // getPaymentStatusTag (row) {
      //   return row.payStatus === 'PAID' ? 'static/img/paid.png' : 'static/img/arrears.png';
      // },
      // getSignedTag (row) {
      //   if (row.userAgreementIsSigned == null) {
      //     return 'static/img/not_signed.png';
      //   } else {
      //     return row.userAgreementIsSigned ? 'static/img/signed.png' : 'static/img/not_signed.png';
      //   }
      // },
      // getOperator (row) {
      //   if (this.$store.getters.currentUser.type == 'BRAND' && row.brandOperator != null) {
      //     return row.brandOperator.name;
      //   } else if (this.$store.getters.currentUser.type == 'FACTORY' && row.factoryOperator != null) {
      //     return row.factoryOperator.name;
      //   } else {
      //     return '';
      //   }
      // },
      onUpdate(row) {
        // this.$emit('onUpdate', row);
      }
    },
    watch: {
      vSelectRow: function (newVal, oldVal) {
        this.selectRow = newVal;
      },
      selectRow: function (newVal, oldVal) {
        this.$emit('update:vSelectRow', newVal);
      }
    },
    data() {
      return {
        statuses: this.$store.state.ProductionOrderModule.statuses,
        selectRow: [],
        orderTypeTagMap: {
          'SELF_PRODUCED': {
            'color': '#ffd60c',
            'borderColor': '#ffd60c'
          },
          'FOUNDRY_PRODUCTION': {
            'color': '#67c23a',
            'borderColor': '#67c23a'
          },
        }
      }
    },
    created() {
      this.selectRow = this.vSelectRow;
    }
  }

</script>
<style>
  .purchase-list-button {
    color: #FFA403;
  }

</style>
