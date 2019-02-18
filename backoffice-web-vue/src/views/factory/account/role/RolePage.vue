<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入名称查询" v-model="keyword"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>
        </el-button-group>
      </el-form>
      <el-table ref="resultTable" stripe :data="page.content"
                v-if="isHeightComputed" :height="autoHeight">
        <el-table-column label="UID" prop="uid"></el-table-column>
        <el-table-column label="名称" prop="name"></el-table-column>
        <el-table-column label="描述" prop="description"></el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope ">
            <el-button type="text " icon="el-icon-edit " @click="onDetails(scope.row) ">
              明细
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="float-right">
        <el-pagination layout="total, sizes, prev, pager, next, jumper"
                       @size-change="onPageSizeChanged"
                       @current-change="onCurrentPageChanged"
                       :current-page="page.number + 1"
                       :page-size="page.size"
                       :page-count="page.totalPages"
                       :total="page.totalElements">
        </el-pagination>
      </div>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('FactoryRolesModule');

  import autoHeight from 'mixins/autoHeight';

  import RoleForm from './RoleForm';
  import RoleDetailsPage from './RoleDetailsPage';

  export default {
    name: 'RolePage',
    components: {},
    mixins: [autoHeight],
    computed: {
      ...mapGetters({
        page: 'page'
      })
    },
    methods: {
      ...mapActions({
        search: 'search'
      }),
      onSearch() {
        this._onSearch(0);
      },
      onNew() {
        this.fn.openSlider('创建角色', RoleForm, this.formData);
      },
      async onDetails(item) {
        const result = this.$http.get('/djfactory/role/' + item.uid + '/perms');
        if (result['errors']) {
          this.$message.error('获取数据失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$set(item, 'perms', result);

        this.fn.openSlider('角色明细', RoleDetailsPage, item);
      },
      onPageSizeChanged(val) {
        this.reset();
        this._onSearch(0, val);
      },
      onCurrentPageChanged(val) {
        this._onSearch(val - 1);
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      _onSearch(page, size) {
        const keyword = this.text;
        this.search({keyword, page, size});
      }
    },
    data() {
      return {
        text: this.$store.state.FactoryRolesModule.keyword,
        formData: this.$store.state.FactoryRolesModule.formData,
      }
    },
    created() {
      this.onSearch();
    }
  }
</script>
