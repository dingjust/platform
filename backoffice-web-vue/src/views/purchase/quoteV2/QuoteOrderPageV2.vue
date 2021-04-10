<!--
* @Description: 报价单（根据成本单创建
* @Date 2021/03/16 15:18
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="cost-order-title">
          <h6>报价单</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <quote-order-toolbar-v2 @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData" />
      <quote-order-list-v2 :page="page" @onAdvancedSearch="onAdvancedSearch"/>
    </el-card> 
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex';

const { mapGetters, mapActions } = createNamespacedHelpers(
  'QuoteOrderV2Module'
);

import QuoteOrderListV2 from './list/QuoteOrderListV2'
import QuoteOrderToolbarV2 from './toolbar/QuoteOrderToolbarV2'

export default {
  name: 'QuoteOrderPageV2',
  components: {
    QuoteOrderListV2,
    QuoteOrderToolbarV2
  },
  data () {
    return {
      queryFormData: {
        keyword: '',
      }
    }
  },
  computed: {
    ...mapGetters({
      page: 'page'
    })
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch (page, size) {
      const query = this.queryFormData;
      const url = this.apis().searchQuoteOrderV2();
 
      this.searchAdvanced({url, query, page, size});
    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>
  .cost-order-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>