<template>
  <div class="animated fadeIn content">
    <el-card>
      <factory-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"/>
      <factory-list :page="page" @onDetails="onDetails" @onSearch="onSearch">
        <template slot="operations" slot-scope="props">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(props.item)">明细</el-button>
        </template>
      </factory-list>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  const {mapGetters, mapActions} = createNamespacedHelpers('FactoriesModule');


  import FactoryToolbar from '@/views/user/company/factory/toolbar/FactoryToolbar';
  import FactoryList from '@/views/user/company/factory/list/FactoryList';
  import FactoryDetailsPage from '@/views/user/company/factory/details/FactoryDetailsPage';

  export default {
    name: 'BrandDashboardPage',
    components: {
      FactoryToolbar,
      FactoryList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData',
        query:'query',
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        advancedSearch:'advancedSearch',
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.apis().getFactories();
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch(page, size) {
        const queryFormData = this.queryFormData;
        const url = this.apis().getFactories();
        this.advancedSearch({url, queryFormData, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getFactory(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('工厂：' + item.name, FactoryDetailsPage, result);
      },

    },
    data() {
      return {
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
