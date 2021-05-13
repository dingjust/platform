<!--
* @Description: 工厂审阅
* @Date 2021/05/11 11:34
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>工厂审阅</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <factory-review-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
      <factory-review-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
    </el-card>
  </div>
</template>

<script>
import {createNamespacedHelpers} from 'vuex';
const {mapGetters, mapActions} = createNamespacedHelpers('FactoriesModule');

import FactoryReviewList from './list/FactoryReviewList'
import FactoryReviewToolbar from './toolbar/FactoryReviewToolbar'

export default {
  name: 'FactoryReview',
  components: {
    FactoryReviewList,
    FactoryReviewToolbar
  },
  computed: {
    ...mapGetters({
      page: 'page',
      queryFormData: 'queryFormData'
    })
  },
  methods: {
    ...mapActions({
      advancedSearch: 'advancedSearch'
    }),
    onAdvancedSearch (page, size) {
      this.queryFormData.reviewState = 'REVIEWING';

      const queryFormData = this.queryFormData;
      const url = this.apis().getFactories() + '?sort=creationtime,desc';

      this.advancedSearch({url, queryFormData, page, size});
    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>

</style>
