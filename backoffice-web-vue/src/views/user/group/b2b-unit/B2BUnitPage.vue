<template>
  <div class="animated fadeIn content">
    <el-card>
      <b2-b-unit-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <b2-b-unit-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('B2BUnitsModule');

  import B2BUnitToolbar from './toolbar/B2BUnitToolbar';
  import B2BUnitList from './list/B2BUnitList';
  import B2BUnitDetailsPage from './details/B2BUnitDetailsPage';

  export default {
    name: 'B2BUnitPage',
    components: {
      B2BUnitToolbar,
      B2BUnitList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.apis().getB2BUnits();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getB2BUnit(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('员工：' + item.name, B2BUnitDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建员工', B2BUnitDetailsPage, formData);
      },
    },
    data() {
      return {};
    },
    created() {
      this.onSearch();
    }
  };
</script>
