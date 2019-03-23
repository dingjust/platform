<template>
  <div class="animated fadeIn content">
    <el-card>
      <employee-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <employee-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('EmployeesModule');

  import EmployeeToolbar from './toolbar/EmployeeToolbar';
  import EmployeeList from './list/EmployeeList';
  import EmployeeDetailsPage from './details/EmployeeDetailsPage';

  export default {
    name: 'EmployeePage',
    components: {
      EmployeeToolbar,
      EmployeeList
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
        const url = this.apis().getEmployees();
        console.log(url);
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getEmployee(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('员工：' + item.name, EmployeeDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建员工', EmployeeDetailsPage, formData);
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
