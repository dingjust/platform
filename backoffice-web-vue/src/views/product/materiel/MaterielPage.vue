<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row type="flex" justify="space-between" align="middle">
        <div class="materiel-list-title">
          <h6>物料列表</h6>
        </div>
<!--        <el-button class="materiel-btn" @click="onNew">添加物料</el-button>-->
      </el-row>
      <div class="pt-2"></div>
      <materiel-toolbar @onSearch="onSearch" @onNew="onNew"/>
<!--      <el-tabs v-model="activeName" @tab-click="handleTabClick">-->
<!--        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">-->
      <materiel-list :page="page" @onSearch="onSearch"  @onDetails="onDetails"/>
<!--        </el-tab-pane>-->
<!--      </el-tabs>-->
<!--      <el-button @click="onDialog">dialog</el-button>-->
    </el-card>
<!--    <el-dialog :visible.sync="dialog" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">-->
<!--      <materiel-dialog v-if="dialog" @confirmMaterial="confirmMaterial"></materiel-dialog>-->
<!--    </el-dialog>-->
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
  import MaterielDetailsPage from './details/MaterielDetailsPage';
  import MaterielDialog from './dialog/MaterielDialog';
  export default {
    name: 'MaterielPage',
    props: {
    },
    components: {MaterielDialog, MaterielDetailsPage, MaterielList, MaterielToolbar},
    computed: {
      ...mapGetters({
        page: 'page',
        queryFormData: 'queryFormData',
        formData: 'formData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        resetFormData: 'resetFormData'
      }),
      // confirmMaterial (materialList) {
      //   console.log(materialList);
      //   this.dialog = false;
      // },
      onNew () {
        this.$store.state.MaterielModule.isCreate = true;
        this.$router.push({
          name: '添加物料',
          params: {}
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
        this.$store.state.MaterielModule.isCreate = false;
        this.$store.state.MaterielModule.formData = Object.assign({}, result.data);
        await this.$router.push({
          name: '物料详情',
          params: {}
        });
      },
      // onDialog () {
      //   this.dialog = true;
      // }
    },
    data () {
      return {
        // dialog: false
      }
    },
    watch: {
      $route () {
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
