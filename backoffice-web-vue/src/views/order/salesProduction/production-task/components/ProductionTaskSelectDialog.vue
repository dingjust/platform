<template>
  <div class="animated fadeIn">
    <el-row>
      <el-form :inline="true">
        <el-row type="flex" justify="space-between">
          <el-col :span="20" style="padding-top: 5px">
            <el-form-item label="订单信息" prop="name">
              <el-input placeholder="请输入订单号，订单名称" v-model="queryFormData.keywords"></el-input>
            </el-form-item>
            <el-form-item label="负责人" prop="name">
              <el-input placeholder="请输入跟单员姓名" v-model="queryFormData.productionLeaderName"></el-input>
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
      }
    },
    components: {ProductionTaskSelectList, ProductionTaskDetail, ProductionTaskList, ProdcutionTaskToolbar},
    computed: {
    },
    methods: {
      async onAdvancedSearch (page, size) {
        let pageS = 0;
        let sizeS = 10;
        if (page) {
          pageS = page;
        }
        if (size) {
          sizeS = size;
        }
        // if (this.selectType == 'OUTBOUND_ORDER') {
        //   this.queryFormData.state = 'DISPATCHING';
        //   this.queryFormData.productionWorkOrder = '';
        // } else {
        //   this.queryFormData.state = '';
        //   this.queryFormData.productionWorkOrder = 'isProductionWorkOrder';
        // }
        // this.queryFormData.type = 'FOUNDRY_PRODUCTION';
        if (this.selectType === 'OUTBOUND_ORDER') {
          this.queryFormData.haveOutOrder = 'haveOutOrder'
        }
        const query = this.queryFormData;
        const url = this.apis().getProductionOrders();
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
        this.queryFormData.keywords = '';
        this.queryFormData.productionLeaderName = '';
        this.queryFormData.cooperator = '';
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
            // this.$refs['taskList'].$refs['resultTable'].toggleRowSelection(this.page.content[index]);
            this.$refs['taskList'].clickRow(this.page.content[index]);
          }
        })
      }
    },
    data () {
      return {
        taskId: '',
        taskVisible: false,
        outboundOrderTypeSelect: false,
        queryFormData: {
          code: '',
          skuID: '',
          state: '',
          keywords: '',
          productionLeaderName: '',
          cooperator: '',
          categories: [],
          productionWorkOrder: ''
        },
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        }
        // formData: this.$store.state.OutboundOrderModule.formData
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
