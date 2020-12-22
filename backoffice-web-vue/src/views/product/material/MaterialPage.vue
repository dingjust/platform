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
    <el-dialog :visible.sync="detailsVisiable" width="80%" class="purchase-dialog"
               append-to-body :close-on-click-modal="false" :before-close="beforeClose">
      <material-details-dialog v-if="detailsVisiable" ref="materielPage" @callback="callback"
                               @closeMaterialdetailsVisible="closeMaterialdetailsVisible"/>
    </el-dialog>
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
  import MaterialDetailsDialog from './dialog/MaterialDetailsDialog';
  export default {
    name: 'MaterialPage',
    props: {
    },
    components: {MaterialDetailsDialog, MaterialDialog, MaterialDetailsPage, MaterialList, MaterialToolbar},
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
        this.detailsVisiable = true;
        // await this.$router.push({
        //   name: '物料详情',
        //   params: {}
        // });
      },
      closeMaterialdetailsVisible () {
        this.detailsVisiable = false;
        this.onSearch(this.page.number);
      },
      beforeClose (done) {
        const leaveCount = this.$refs.materielPage.leaveCount;
        if (leaveCount > 1) {
          this.$confirm('是否离开此弹窗 , 更改内容将不会被保存', '提示', {
            confirmButtonText: '离开页面',
            cancelButtonText: '留在页面',
            type: 'warning',
            showClose: false,
            closeOnHashChange: false
          }).then(() => {
            done();
          }).catch(() => {
          })
        } else {
          done();
        }
      },
      callback () {
        this.onSearch();
        this.detailsVisiable = false;
      }
      // onDialog () {
      //   this.dialog = true;
      // }
    },
    data () {
      return {
        detailsVisiable: false,
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
