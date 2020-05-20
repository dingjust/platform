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
      <outbound-order-toolbar @onAdvancedSearch="onAdvancedSearch" @createOutboundOrder="createOutboundOrder"/>
      <outbound-order-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onModify="onModify"/>
    </el-card>
    <el-dialog :visible.sync="outboundOrderTypeSelect" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <outbound-order-type-select-form :formData="formData" @onSelectType="onSelectType"/>
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
  import OutboundOrderTypeSelectForm from "./form/OutboundOrderTypeSelectForm";
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
        this.outboundOrderTypeSelect = true;
      },
      onSelectType () {
        this.$router.push({
          name: '创建外发订单'
        });
      },
      onModify (code) {
        this.getDetail(code);
        this.$router.push('/sales/create/outboundOrder');
      },
      async getDetail (code) {
        const url = this.apis().getoutboundOrderDetail(code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$store.state.OutboundOrderModule.formData = Object.assign({}, result);
      }
    },
    data () {
      return {
        outboundOrderTypeSelect: false
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
