<template>
  <div class="animated fadeIn content">
    <el-card>
      <carousel-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <carousel-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('CarouselsModule');

  import CarouselToolbar from './toolbar/CarouselToolbar';
  import CarouselList from './list/CarouselList';
  import CarouselDetailsPage from './details/CarouselDetailsPage';

  export default {
    name: 'CarouselPage',
    components: {
      CarouselToolbar,
      CarouselList
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
        const url = this.apis().getCarousels();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getCarousel(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('员工：' + item.name, CarouselDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建员工', CarouselDetailsPage, formData);
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
