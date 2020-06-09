<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="outbound-list-title">
            <!--外发订单列表-->
            <h6>订单列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <outbound-order-toolbar @onAdvancedSearch="onAdvancedSearch" @createOutboundOrder="createOutboundOrder"
                              :queryFormData="queryFormData"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="(item, index) in stateList">
          <el-tab-pane :label="item.name" :name="item.code">
            <outbound-order-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onModify="onModify"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
    <el-dialog :visible.sync="outboundOrderTypeSelect" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <outbound-order-type-select-form v-if="outboundOrderTypeSelect" :formData="formData"/>
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
    'OutboundOrderModule'
  );

  import OutboundOrderToolbar from './toolbar/OutboundOrderToolbar';
  import OutboundOrderList from './list/OutboundOrderList';
  import OutboundOrderTypeSelectForm from './form/OutboundOrderTypeSelectForm';
  export default {
    name: 'OutboundOrderPage',
    components: {
      OutboundOrderTypeSelectForm,
      OutboundOrderList,
      OutboundOrderToolbar
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData',
        formData: 'formData'
      }),
      stateList: function () {
        return this.statuses.concat({code: '', name: '全部'}, this.$store.state.EnumsModule.OutboundOrderStatuses);
      }
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
        const url = this.apis().getoutboundOrdersList();
        this.setIsAdvancedSearch(false);
        this.search({
          url,
          keyword,
          page,
          size
        });
      },
      onAdvancedSearch (page, size) {
        const query = this.queryFormData;
        const url = this.apis().getoutboundOrdersList();
        this.setIsAdvancedSearch(true);
        this.searchAdvanced({url, query, page, size});
      },
      createOutboundOrder () {
        this.$router.push({
          name: '创建外发订单',
          params: {
            formData: this.formData
          }
        });
      },
      handleClick (tab, event) {
        if (tab.name == '') {
          this.queryFormData.statuses = tab.name;
          this.onSearch();
        } else {
          this.queryFormData.statuses = tab.name;
          this.onAdvancedSearch();
        }
      },
      async onModify (code) {
        const url = this.apis().getoutboundOrderDetail(code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        let item = {
          event: 'ORDER_CONFIRMED',
          time: 5,
          range: 'INSIDE',
          percent: 0.3
        }
        result.payPlan['deposit'] = item;
        result.payPlan['balance1'] = item;
        result.payPlan['balance2'] = item;
        result.payPlan['monthBalance'] = {
          event: 'ORDER_CONFIRMED',
          time: 5
        };
        await this.$router.push({
          name: '创建外发订单',
          params: {
            formData: result
          }
        });
      }
    },
    data () {
      return {
        outboundOrderTypeSelect: false,
        activeName: '',
        statuses: []
      }
    },
    created () {
      this.onSearch();
    },
    mounted () {

    }
  };
</script>

<style scoped>
  .outbound-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
