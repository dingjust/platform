<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入名称查询" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
        </el-button-group>
      </el-form>
      <el-table stripe :data="page.content">
        <el-table-column label="会员名称" prop="name"></el-table-column>
        <el-table-column label="手机号码" prop="mobileNumber"></el-table-column>
        <el-table-column label="电子邮箱" prop="email"></el-table-column>
      </el-table>
      <div class="pt-2"></div>
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
      <div class="clearfix"></div>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('BrandFollowersModule');

  import autoHeight from 'mixins/autoHeight';

  export default {
    name: 'MyFollowersPage',
    props: [],
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
      _onSearch(page, size) {
        const keyword = this.text;
        this.search({keyword, page, size});
      }
    },
    created() {
      this.onSearch();
    },
    data() {
      return {
        text: this.$store.state.BrandFollowersModule.keyword,
      }
    }
  }
</script>
