<!--
* @Description: 需求审阅列表
* @Date 2021/07/01 15:33
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>需求审阅列表</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <requirement-review-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
      <requirement-review-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
    </el-card>
  </div>
</template>

<script>
import {createNamespacedHelpers} from 'vuex';
const {mapGetters, mapActions, mapMutations} = createNamespacedHelpers('RequirementOrdersModule');

import RequirementReviewToolbar from './toolbar/RequirementReviewToolbar'
import RequirementReviewList from './list/RequirementReviewList';

export default {
  name: 'RequirementReview',
  components: {
    RequirementReviewToolbar,
    RequirementReviewList
  },
  computed: {
    ...mapGetters({
      page: 'page',
      queryFormData: 'queryFormData',
      categories: 'categories'
    })
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
   }),
    ...mapMutations({
      setCategories: 'categories'
    }),
   onAdvancedSearch (page, size) {
      const query = this.queryFormData;
      query['reviewState'] = 'REVIEWING'

      const url = this.apis().getRequirementOrders();
      this.searchAdvanced({url, query, page, size});

      if (this.categories <= 0) {
        this.getMinorCategories();
      }
    },
    async getMinorCategories () {
      const url = this.apis().getMinorCategories();
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.setCategories(result);
    },
  },
  created () {
    this.onAdvancedSearch()
  }
}
</script>

<style>

</style>