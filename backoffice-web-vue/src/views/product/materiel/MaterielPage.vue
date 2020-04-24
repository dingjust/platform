<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between" align="middle">
        <div class="materiel-list-title">
          <h6>物料列表</h6>
        </div>
        <el-button class="materiel-btn" @click="onNew">添加物料</el-button>
      </el-row>
      <div class="pt-2"></div>
      <materiel-toolbar @onSearch="onSearch"/>
<!--      <el-tabs v-model="activeName" @tab-click="handleTabClick">-->
<!--        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">-->
      <materiel-list :page="page" @onSearch="onSearch"  @onDetails="onDetails"/>
<!--        </el-tab-pane>-->
<!--      </el-tabs>-->
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers('MaterielModule');

  import MaterielToolbar from './toolbar/MaterielToolbar';
  import MaterielList from './list/MaterielList';
  export default {
    name: 'MaterielPage',
    components: {MaterielList, MaterielToolbar},
    computed: {
      ...mapGetters({
        page: 'page',
        queryFormData: 'queryFormData',
        formData: 'formData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search'
      }),
      onNew () {
        this.$router.push({
          name: '添加物料',
          params: {
            isCreate: true
          }
        });
      },
      onSearch (page, size) {
        const keyword = this.keyword;
        const url = this.apis().getMaterialsList();
        this.search({
          url,
          keyword,
          page,
          size
        });
      },
      async onDetails (row) {
        const url = this.apis().getMaterialDetails(row.id);
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        await this.$router.push({
          name: '物料详情',
          params: {
            isCreate: false,
            formData: result.data
          }
        });
      }
    },
    data () {
      return {
        statuses: [{
          code: '',
          name: '全部'
        },
        {
          code: 'approved',
          name: '已上架'
        },
        {
          code: 'unapproved',
          name: '已下架'
        }]
      }
    },
    watch: {
      $route() {
        // 跳转到该页面后需要进行的操作
        this.onSearch(this.page.number);
      }
    },
    created () {
      this.onSearch();
    }
  }
</script>

<style scoped>
  .materiel-list-title {
    border-left: 2px solid #ffd60c;
    height: 18px;
    padding-left: 10px;
  }

  .materiel-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 100px;
  }
</style>
