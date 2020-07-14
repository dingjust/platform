<!-- 
 * @description: 外发工单选择列表
 * @fileName: ExportOrderSelect.vue 
 * @author: yj 
 * @date: 2020-07-14 10:37:05
 * @version: V1.0.0 
!-->
<template>
  <div>
    <el-row>
      <el-col :span="4">
        <div class="orders-list-title">
          <h6>待对账外发工单</h6>
        </div>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <production-order-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData"
      :isOutProduction="true" />
    <order-select-list :page="page" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"
      :vSelectRow.sync="selectRows" :isHighlight="true" :isOutProduction="true" />
    <el-row type="flex" justify="center">
      <el-button class="sumbit-btn" @click="onSure">确定</el-button>
    </el-row>
  </div>
</template>

<script>
  import OrderSelectList from './OrderSelectList';
  import ProductionOrderToolbar from '../toolbar/ProductionOrderToolbar';

  export default {
    name: 'ExportOrderSelect',
    components: {
      OrderSelectList,
      ProductionOrderToolbar
    },
    computed: {},
    methods: {
      async onSearch(page, size) {
        const keyword = this.keyword;
        const statuses = this.statuses;
        const url = this.apis().getoutboundProductionList();
        const result = await this.$http.post(url, query, {
          page: page,
          size: size
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.page = result;
      },
      async onAdvancedSearch(page, size) {
        const query = this.queryFormData;
        const url = this.apis().getoutboundProductionList();
        const result = await this.$http.post(url, query, {
          page: page,
          size: size
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.page = result;
      },
      handleClick(tab, event) {
        this.queryFormData.state = tab.name;
        this.onAdvancedSearch();
      },
      onSure() {
        this.$emit('onSelect', this.selectRows);
      }
    },
    data() {
      return {
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        },
        formData: {
          id: null,
          code: '',
          product: {
            thumbnail: '',
            category: {
              name: ''
            }
          },
          cooperator: {
            partner: {
              name: ''
            }
          },
          status: 'PENDING_CONFIRM',
          supplier: {},
          user: {},
          deliveryAddress: {
            id: null,
            fullname: '',
            cellphone: '',
            region: {
              isocode: '',
              name: ''
            },
            city: {
              code: '',
              name: ''
            },
            cityDistrict: {
              code: '',
              name: ''
            },
            line1: ''
          },
          entries: [],
          attachments: [],
          remarks: '',
          salesApplication: 'BELOW_THE_LINE',
          totalPrice: 0,
          totalQuantity: 0,
          unitPrice: 0,
          purchaser: {},
          belongTo: {
            uid: '',
            name: ''
          },
          creator: {},
          progresses: [],
          companyOfSeller: '',
          contactPersonOfSeller: '',
          contactOfSeller: '',
          payPlan: {
            payPlanType: '',
            isHaveDeposit: true,
            payPlanItems: []
          },
          factoryOperator: {
            name: ''
          },
          brandOperator: {
            name: ''
          }
        },
        activeStatus: 'TO_BE_RECONCILED',
        statues: Object.assign([], this.$store.state.EnumsModule.ProductionTaskOrderState),
        queryFormData: {
          createdDateFrom: null,
          createdDateTo: null,
          keyword: '',
          categories: [],
          state: 'TO_BE_RECONCILED'
        },
        selectRows: null,
        stateCount: {}
      };
    },
    created() {
      this.onAdvancedSearch();
      this.statues.push({
        code: '',
        name: '全部'
      })
    },
    mounted() {

    },
    destroyed() {}
  };

</script>
<style>
  .report {
    margin-bottom: 10px;
  }

  .orders-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .purchase-dialog .el-dialog {
    border-radius: 10px !important;
  }

  .purchase-dialog-header {
    padding: 0px !important;
  }

  .purchase-dialog .el-dialog__header {
    padding: 0px !important;
  }

  .sumbit-btn {
    width: 70px;
    background-color: #ffd60c;
  }

</style>
