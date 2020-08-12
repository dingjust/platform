<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange" :height="autoHeight">
      <el-table-column label="合作商名称" prop="name">
        <template slot-scope="scope">
          <span v-if="scope.row.partner != null"> {{scope.row.partner.name}}</span>
          <span v-else> {{scope.row.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="联系人" prop="contactPerson">
        <template slot-scope="scope">
          <span v-if="scope.row.partner != null"> {{scope.row.partner.contactPerson}}</span>
          <span v-else> {{scope.row.contactPerson}}</span>
        </template>
      </el-table-column>
      <el-table-column label="联系方式" prop="contactPhone">
        <template slot-scope="scope">
          <span v-if="scope.row.partner != null"> {{scope.row.partner.contactPhone}}</span>
          <span v-else> {{scope.row.contactPhone}}</span>
        </template>
      </el-table-column>
      <!-- <el-table-column label="类别" prop="category">
        <template slot-scope="scope">
          <span> {{getEnum('CooperatorCategory',scope.row.category)}}</span>
        </template>
      </el-table-column> -->
      <el-table-column label="类型" prop="type">
        <template slot-scope="scope">
          <span> {{getEnum('CooperatorType',scope.row.type)}}</span>
        </template>
      </el-table-column>
      <!--<el-table-column label="合作次数" v-if="!isFactory()" prop="belongTo.name">-->
      <!--<template slot-scope="scope">-->
      <!--<span v-if="scope.row.belongTo">{{scope.row.belongTo.name}}</span>-->
      <!--</template>-->
      <!--</el-table-column>-->
      <el-table-column label="操作" min-width="100">
        <template slot-scope="scope">
          <el-row>
            <el-button type="text" @click="onDetails(scope.row)" class="cooperator-list-button">明细</el-button>
            <el-divider direction="vertical"></el-divider>
            <Authorized :permission="['COMPANY_COOPERATOR_CREATE']">
              <el-button type="text" @click="onEdit(scope.row)" class="cooperator-list-button">编辑</el-button>
            </Authorized>
            <el-divider direction="vertical"></el-divider>
            <Authorized :permission="['COMPANY_COOPERATOR_REMOVE']">
              <el-button type="text" @click="onDelete(scope.row)" class="cooperator-list-button">删除</el-button>
            </Authorized>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <!-- <div class="float-right"> -->
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <!-- </div> -->
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions
  } = createNamespacedHelpers('CooperatorModule');

  export default {
    name: 'CooperatorSearchResultList',
    props: ["page"],
    components: {},
    computed: {},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      handleFilterChange(val) {
        this.statuses = val.status;

        this.$emit('onSearch', 0);
      },
      onPageSizeChanged(val) {
        this._reset();

        if (this.$store.state.CooperatorModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.$store.state.CooperatorModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val - 1);
          return;
        }

        this.$emit('onSearch', val - 1);
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails(row) {
        this.$emit('onDetails', row);
      },
      onEdit(row) {
        this.$emit('onEdit', row);
      },
      onDelete(row) {
        this.$confirm('此操作将永久删除该合作商, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$emit('onDelete', row);
        })
      },
    },
    data() {
      return {
        statuses: this.$store.state.CooperatorModule.statuses
      }
    }
  }

</script>
<style>
  .cooperator-list-button {
    color: #FFA403;
  }

</style>
