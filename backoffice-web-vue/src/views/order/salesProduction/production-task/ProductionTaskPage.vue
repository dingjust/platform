<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="sales-plan-form-title">
            <h6>生产任务列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <production-task-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"
        @createOutboundOrder="createOutboundOrder" />
      <production-task-list :page="page" />
    </el-card>
    <el-dialog :visible.sync="outboundOrderTypeSelect" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <outbound-order-type-select-form v-if="outboundOrderTypeSelect" :formData="formData" />
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

  import ProductionTaskToolbar from './toolbar/ProdcutionTaskToolbar';
  import ProductionTaskList from './list/ProductionTaskList';
  import OutboundOrderTypeSelectForm from '../outbound-order/form/OutboundOrderTypeSelectForm';
  export default {
    name: 'ProductionTaskPage',
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData',
        contentData: 'detailData'
      })
    },
    components: {
      OutboundOrderTypeSelectForm,
      ProductionTaskList,
      ProductionTaskToolbar
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
      onSearch(page, size) {
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
      onAdvancedSearch(page, size) {
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
      createOutboundOrder() {
        this.outboundOrderTypeSelect = true;
      }
    },
    data() {
      return {
        outboundOrderTypeSelect: false,
        formData: this.$store.state.OutboundOrderModule.formData,
      }
    },
    created(){
      this.onSearch();
    }
  }

</script>

<style scoped>
  .sales-plan-form-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
