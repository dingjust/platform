<template>
  <div class="animated fadeIn">
    <prodcution-task-toolbar @onAdvancedSearch="onAdvancedSearch" :is-select="true"/>
    <production-task-select-list ref="taskList" :page="page" @onSearch="onAdvancedSearch" @getSelectTaskList="getSelectTaskList"
                          :is-select="true" @onDetails="onDetails" :isSingleChoice="isSingleChoice"/>
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
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'ProductionTasksModule'
  );

  import ProdcutionTaskToolbar from '../toolbar/ProdcutionTaskToolbar';
  import ProductionTaskList from '../list/ProductionTaskList';
  import ProductionTaskDetail from '../details/ProductionTaskDetail';
  import ProductionTaskSelectList from '../list/ProductionTaskSelectList';
  export default {
    name: 'ProductionTaskSelectDialog',
    props: {
      formData: {
        type: Object
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
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData',
        contentData: 'detailData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
        clearQueryFormData: 'clearQueryFormData'
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch',
        setDetailData: 'detailData'
      }),
      onAdvancedSearch (page, size) {
        if (this.selectType == 'OUTBOUND_ORDER') {
          this.queryFormData.state = 'DISPATCHING';
        } else {
          this.queryFormData.productionWorkOrder = 'isProductionWorkOrder';
        }
        this.queryFormData.productionLeader = 'isProductionLeader'
        this.setIsAdvancedSearch(true);
        const query = this.queryFormData;
        const url = this.apis().getProductionTaskList();
        this.searchAdvanced({
          url,
          query,
          page,
          size
        });
      },
      getSelectTaskList (val) {
        this.selectTaskList = val;
      },
      onDetails (id) {
        this.taskId = id;
        this.taskVisible = true;
      },
      onSelect () {
        this.$emit('onSelectTask', this.selectTaskList);
      },
      // 回显已选择行
      initSelectRow () {
        let index;
        this.formData.entries.forEach(item => {
          index = this.page.content.findIndex(val => val.id == item.productionTask.id)
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
        selectTaskList: []
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
      this.onAdvancedSearch();
    },
    destroyed() {
      this.clearQueryFormData();
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
</style>
