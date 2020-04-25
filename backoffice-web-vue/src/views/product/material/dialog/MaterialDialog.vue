<template>
  <div class="animated fadeIn">
    <el-row type="flex" justify="space-between" align="middle">
      <div class="material-list-title">
        <h6>物料列表</h6>
      </div>
    </el-row>
    <div class="pt-2"></div>
    <material-toolbar @onSearch="onSearch" @onNew="onNew"/>
    <material-dialog-list :page="page" @onSearch="onSearch"  @onDetails="onDetails" @getSelectMaterial="getSelectMaterial"/>
    <el-row type="flex" justify="center" align="middle" style="margin-top: 10px">
      <el-button size="medium" class="sure-button" @click="confirmMaterial">确认添加</el-button>
    </el-row>
    <el-dialog :visible.sync="materialdetailsVisible" width="80%" class="purchase-dialog"
               append-to-body :close-on-click-modal="false" :before-close="beforeClose">
      <material-details-dialog v-if="materialdetailsVisible" ref="materielPage"
                               @closeMaterialdetailsVisible="closeMaterialdetailsVisible"/>
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import MaterialToolbar from '../toolbar/MaterialToolbar';
  import MaterialList from '../list/MaterialList';
  import MaterialDetailsDialog from './MaterialDetailsDialog';
  import MaterialDialogList from '../list/MaterialDialogList';

  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers('MaterialModule');

  export default {
    name: 'MaterialDialog',
    components: {MaterialDialogList, MaterialDetailsDialog, MaterialList, MaterialToolbar},
    props: {
    },
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
        resetQueryFormData: 'resetQueryFormData',
        resetFormData: 'resetFormData'
      }),
      getSelectMaterial (materialList) {
        this.materialList = materialList;
      },
      confirmMaterial () {
        this.materialList = this.distinct(this.materialList);
        // 保存选择的物料列表
        this.$store.state.MaterialModule.selectMaterialList = this.materialList;
        this.$emit('confirmMaterial', this.materialList);
      },
      // 数组去重
      distinct (arr) {
        let result = []
        let obj = {};
        for (let i of arr) {
          if (!obj[i.id]) {
            result.push(i)
            obj[i.id] = 1
          }
        }
        return result
      },
      onNew () {
        this.$store.state.MaterialModule.isCreate = true;
        this.materialdetailsVisible = true;
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
        this.materialdetailsVisible = true;
      },
      closeMaterialdetailsVisible () {
        this.materialdetailsVisible = false;
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
      }
    },
    data () {
      return {
        materialdetailsVisible: false,
        materialList: []
      }
    },
    watch: {
    },
    created () {
      this.onSearch();
    },
    destroyed () {
      this.resetFormData();
      this.resetQueryFormData();
    }
  }
</script>

<style scoped>
  .material-list-title {
    border-left: 2px solid #ffd60c;
    height: 18px;
    padding-left: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 100px;
  }

  .sure-button {
    background-color: #ffd60c;
  }
</style>
