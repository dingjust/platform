<template>
  <div class="animated fadeIn">
    <el-row>
      <el-form :inline="true">
        <el-row type="flex" justify="space-between">
          <el-col :span="24" style="padding-top: 5px">
            <el-form-item label="订单信息" prop="name">
              <el-input placeholder="请输入订单号，订单名称" v-model="queryFormData.keyword"></el-input>
            </el-form-item>
            <!-- <el-form-item label="负责人" prop="name">
              <el-input placeholder="请输入跟单员姓名" v-model="queryFormData.productionLeaderName"></el-input>
            </el-form-item> -->
            <el-form-item label="部门/人员" prop="name">
              <dept-person-select ref="deptPersonSelect" :dataQuery="dataQuery" width="170"
                                  :selectDept="queryFormData.depts" :selectPerson="queryFormData.users"/>
            </el-form-item>
            <el-form-item label="合作商" prop="name">
              <el-input placeholder="请输入合作商名称" v-model="queryFormData.cooperator"></el-input>
            </el-form-item>
            <el-button-group>
              <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch(0, 10)">搜索</el-button>
              <el-button native-type="reset" @click="onReset">重置</el-button>
            </el-button-group>
          </el-col>
        </el-row>
      </el-form>
    </el-row>
    <template v-if="selectType === 'PURCHASE_REQUIREMENT'">
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="item.name" :name="item.code" :key="item.code"></el-tab-pane>
        </template>
      </el-tabs>
    </template>
    <production-task-select-list ref="taskList" :page="page" @onSearch="onAdvancedSearch"
                                :is-select="true" @onDetails="onDetails" :isSingleChoice="isSingleChoice" 
                                :selectedRow="formData.taskOrderEntries"/>
    <el-row type="flex" justify="center" align="middle">
      <el-col :span="4">
        <el-button class="material-btn" @click="onSelect">确定</el-button>
      </el-col>
    </el-row>
    <el-dialog :visible.sync="taskVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <production-task-details v-if="taskVisible" :id="taskId"/>
    </el-dialog>
  </div>
</template>

<script>
  import ProdcutionTaskToolbar from '../toolbar/ProdcutionTaskToolbar';
  import ProductionTaskList from '../list/ProductionTaskList';
  import ProductionTaskDetail from '../details/ProductionTaskDetail';
  import ProductionTaskSelectList from '../list/ProductionTaskSelectList';
  import { DeptPersonSelect } from '@/components'

  export default {
    name: 'ProductionTaskSelectDialog',
    props: {
      formData: {
        type: Object,
        default: () => {
          return { taskOrderEntries: [] }
        }
      },
      isSingleChoice: {
        type: Boolean,
        default: false
      },
      selectType: {
        type: String
      },
      productionType: {
        type: String,
        default: 'PRODUCTION'
      }
    },
    components: {
      ProductionTaskSelectList, 
      ProductionTaskDetail, 
      ProductionTaskList, 
      ProdcutionTaskToolbar, 
      DeptPersonSelect
    },
    computed: {
    },
    methods: {
      handleClick (tab, event) {
        if (tab.name === 'TO_BE_PRODUCED') {
          this.queryFormData.haveOutOrder = 'nothaveOutOrder'
          this.queryFormData.state = 'TO_BE_PRODUCED'
        } else if (tab.name === 'PRODUCING') {
          this.queryFormData.haveOutOrder = ''
          this.queryFormData.state = 'PRODUCING'
        }
        this.onAdvancedSearch();
      },
      async onAdvancedSearch (page, size) {
        if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
          this.onResetQuery();
        }
        let pageS = 0;
        let sizeS = 10;
        if (page) {
          pageS = page;
        }
        if (size) {
          sizeS = size;
        }
        const query = this.queryFormData;
        let url;
        if (this.productionType === 'PRODUCTION') {
          url = this.apis().getProductionOrders();
        } else {
          url = this.apis().getoutboundProductionList();
        }
        const result = await this.$http.post(url, query, {
          page: pageS,
          size: sizeS
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.page = result;
      },
      onReset () {
        this.queryFormData.keyword = '';
        this.queryFormData.productionLeaderName = '';
        this.queryFormData.cooperator = '';
        this.$refs.deptPersonSelect.clearSelectData();
        this.$emit('onResetQuery');
      },
      onDetails (id) {
        this.taskId = id;
        this.taskVisible = true;
      },
      onSelect () {
        this.$emit('onSelectTask', this.$refs.taskList.selectTaskList);
      },
      // 回显已选择行
      initSelectRow () {
        let index;
        this.formData.taskOrderEntries.forEach(item => {
          index = this.page.content.findIndex(val => val.id == item.originOrder.id)
          if (index > -1) {
            this.$refs['taskList'].clickRow(this.page.content[index]);
          }
        })
      },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      },
    },
    data () {
      return {
        activeName: 'TO_BE_PRODUCED',
        statuses: [{
          code: 'TO_BE_PRODUCED',
          name: '待生产'
        }, {
          code: 'PRODUCING',
          name: '生产中'
        }],
        taskId: '',
        taskVisible: false,
        outboundOrderTypeSelect: false,
        queryFormData: {
          code: '',
          skuID: '',
          state: '',
          keyword: '',
          productionLeaderName: '',
          cooperator: '',
          categories: [],
          productionWorkOrder: '',
          excludeState: 'CANCED'
        },
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        },
        dataQuery: {}
      }
    },
    watch: {
      page: function (newVal, oldVal) {
        if (newVal) {
          this.$nextTick(() => {
            this.initSelectRow();
          })
        }
      }
    },
    created () {
      this.dataQuery = this.getDataPerQuery('SALES_OUT_ORDER');
      this.onResetQuery();
      if (this.selectType === 'OUTBOUND_ORDER') {
        this.queryFormData.haveOutOrder = 'nothaveOutOrder'
      } else if (this.selectType === 'PURCHASE_REQUIREMENT') {
        // this.queryFormData.haveOutOrder = 'nothaveOutOrder'
        this.queryFormData.state = 'TO_BE_PRODUCED'
      }
      this.onAdvancedSearch(0, 10);
    }
  }
</script>

<style scoped>
  .material-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 100px;
  }

  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }
</style>
