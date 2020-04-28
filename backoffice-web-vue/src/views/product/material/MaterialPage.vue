<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="material-list-title">
            <h6>物料列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <material-toolbar @onSearch="onSearch" @onNew="onNew"/>
<!--      <el-tabs v-model="activeName" @tab-click="handleTabClick">-->
<!--        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">-->
      <material-list :page="page" @onSearch="onSearch"  @onDetails="onDetails"/>
<!--        </el-tab-pane>-->
<!--      </el-tabs>-->
<!--      <el-button @click="onDialog">dialog</el-button>-->
    </el-card>
<!--    <el-dialog :visible.sync="dialog" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">-->
<!--      <material-dialog v-if="dialog" @confirmMaterial="confirmMaterial"></material-dialog>-->
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
  } = createNamespacedHelpers('MaterialModule');

  import MaterialToolbar from './toolbar/MaterialToolbar';
  import MaterialList from './list/MaterialList';
  import MaterialDetailsPage from './details/MaterialDetailsPage';
  import MaterialDialog from './dialog/MaterialDialog';
  export default {
    name: 'MaterialPage',
    props: {
    },
    components: {MaterialDialog, MaterialDetailsPage, MaterialList, MaterialToolbar},
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
        this.$store.state.MaterialModule.isCreate = true;
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
        this.$store.state.MaterialModule.isCreate = false;
        this.$store.state.MaterialModule.formData = Object.assign({}, result.data);
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
  .material-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 100px;
  }
</style>
