<template>
  <div class="animated fadeIn">
    <prodcution-task-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" :is-select="true"/>
    <production-task-list :page="page" @onSearch="onAdvancedSearch" @getSelectTaskList="getSelectTaskList"
                          :is-select="true" @onDetails="onDetails"/>
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
  import ProductionTaskDetails from '../details/ProductionTaskDetail';
  export default {
    name: 'ProductionTaskSelectDialog',
    props: ['formData'],
    components: {ProductionTaskDetails, ProductionTaskList, ProdcutionTaskToolbar},
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
        searchAdvanced: 'searchAdvanced'
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch',
        setDetailData: 'detailData'
      }),
      onSearch (page, size) {
        const keyword = this.keyword;
        const statuses = this.statuses;
        const url = this.apis().getProductionTaskList();
        this.setIsAdvancedSearch(false);
        this.search({
          url,
          keyword,
          statuses,
          page,
          size
        });
      },
      onAdvancedSearch (page, size) {
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
        console.log(this.selectTaskList);
      },
      // createOutboundOrder () {
      //   let row = {};
      //   let entries = [];
      //   this.selectTaskList.forEach(item => {
      //     row = {
      //       productionTaskId: item.id,
      //       billPrice: '',
      //       expectedDeliveryDate: '',
      //       shippingAddress: {},
      //       product: {
      //         id: item.productionEntry.product.id,
      //         name: item.productionEntry.product.name,
      //         thumbnail: item.productionEntry.product.thumbnail,
      //         colorSizeEntry: item.productionEntry.colorSizeEntry
      //       }
      //     }
      //     entries.push(row);
      //     row = {};
      //   })
      //   this.formData.entries = entries;
      //   this.outboundOrderTypeSelect = true;
      // },
      onDetails (id) {
        this.taskId = id;
        this.taskVisible = true;
      },
      onSelect () {
        let row = {};
        let entries = [];
        this.selectTaskList.forEach(item => {
          row = {
            productionTask: {
              id: item.id
            },
            billPrice: '',
            expectedDeliveryDate: '',
            shippingAddress: {},
            product: {
              id: item.productionEntry.product.id,
              name: item.productionEntry.product.name,
              thumbnail: item.productionEntry.product.thumbnail,
            },
            colorSizeEntries: item.productionEntry.colorSizeEntries
          }
          entries.push(row);
          row = {};
        })
        this.formData.entries = entries;
        this.$emit('onSelectTask');
      }
    },
    data () {
      return {
        taskId: '',
        taskVisible: false,
        outboundOrderTypeSelect: false,
        selectTaskList: [],
        // formData: this.$store.state.OutboundOrderModule.formData
      }
    },
    created () {
      this.onSearch();
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
