<template>
  <div class="animated fadeIn content">
    <el-card>
      <operation-course-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <operation-course-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('OperationCoursesModule');

  import OperationCourseToolbar from './toolbar/OperationCourseToolbar';
  import OperationCourseList from './list/OperationCourseList';
  import OperationCourseDetailsPage from './details/OperationCourseDetailsPage';

  export default {
    name: 'OperationCoursePage',
    components: {
      OperationCourseToolbar,
      OperationCourseList
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
        const url = this.apis().getOperationCourses();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getOperationCourse(item.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('明细：' + item.name, OperationCourseDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('新建', OperationCourseDetailsPage, formData);
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
