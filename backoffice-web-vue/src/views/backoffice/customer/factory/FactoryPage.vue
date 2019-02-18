<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入名称" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>
        </el-button-group>
      </el-form>
      <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
        <el-table-column label="UID" prop="uid"></el-table-column>
        <el-table-column label="名称" prop="name"></el-table-column>
        <el-table-column label="联系电话" prop="contactPhone"></el-table-column>
        <el-table-column label="联系人" prop="contactPerson"></el-table-column>
        <el-table-column label="是否激活" prop="active">
          <template slot-scope="scope">
            <el-switch v-model="scope.row.active"
                       active-color="#13ce66"
                       inactive-color="#ff4949"
                       @change="changeActiveStatus(scope.row)">
            </el-switch>
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">明细</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                     @size-change="onPageSizeChanged"
                     @current-change="onCurrentPageChanged" :current-page="page.number + 1" :page-size="page.size"
                     :page-count="page.totalPages" :total="page.totalElements">
      </el-pagination>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('FactoriesModule');

  import autoHeight from 'mixins/autoHeight'

  import ApprovalStatus from 'components/custom/ApprovalStatus.vue';
  import {FactoryForm} from './';
  import FactoryDetailsPage from './FactoryDetailsPage';

  export default {
    name: 'FactoryPage',
    mixins: [autoHeight],
    components: {FactoryForm, ApprovalStatus},
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
        this.fn.openSlider('添加工厂', FactoryForm, this.formData);
      },
      onDetails(item) {
        this.fn.openSlider('工厂明细', FactoryDetailsPage, item);
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
      },
      async changeActiveStatus(row) {
        const result = await this.$http.delete('/djfactory/factory/' + row.uid);
        if (result['errors']) {
          row.active = !row.active;
          if (row.active) {
            this.$message.error('激活失败');
          } else {
            this.$message.error('禁用失败');
          }
          return;
        }

        if (row.active) {
          this.$message.success('激活成功');
        } else {
          this.$message.success('禁用成功');
        }
      }
    },
    data() {
      return {
        text: this.$store.state.FactoriesModule.keyword,
        formData: this.$store.state.FactoriesModule.formData
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
