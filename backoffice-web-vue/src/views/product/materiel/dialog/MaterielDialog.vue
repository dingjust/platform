<template>
  <div class="animated fadeIn">
    <el-row type="flex" justify="space-between" align="middle">
      <div class="materiel-list-title">
        <h6>物料列表</h6>
      </div>
    </el-row>
    <div class="pt-2"></div>
    <materiel-toolbar @onSearch="onSearch" @onNew="onNew"/>
    <materiel-dialog-list :page="page" @onSearch="onSearch"  @onDetails="onDetails" @getSelectMaterial="getSelectMaterial"/>
    <el-row type="flex" justify="center" align="middle" style="margin-top: 10px">
      <el-button size="medium" class="sure-button" @click="confirmMaterial">确认添加</el-button>
    </el-row>
    <el-dialog :visible.sync="materialdetailsVisible" width="80%" class="purchase-dialog"
               append-to-body :close-on-click-modal="false" :before-close="beforeClose">
      <materiel-details-dialog v-if="materialdetailsVisible" ref="materielPage"
                               @closeMaterialdetailsVisible="closeMaterialdetailsVisible"/>
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import MaterielToolbar from '../toolbar/MaterielToolbar';
  import MaterielList from '../list/MaterielList';
  import MaterielDetailsDialog from './MaterielDetailsDialog';
  import MaterielDialogList from '../list/MaterielDialogList';

  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers('MaterielModule');

  export default {
    name: 'MaterielDialog',
    components: {MaterielDialogList, MaterielDetailsDialog, MaterielList, MaterielToolbar},
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
        resetQueryFormData: 'resetQueryFormData'
      }),
      getSelectMaterial (materialList) {
        this.materialList = materialList;
      },
      confirmMaterial () {
        // 保存选择的物料列表
        this.$store.state.MaterielModule.selectMaterialList = this.materialList;
        this.$emit('confirmMaterial', this.materialList);
      },
      onNew () {
        this.$store.state.MaterielModule.isCreate = true;
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
        this.$store.state.MaterielModule.isCreate = false;
        this.$store.state.MaterielModule.formData = Object.assign({}, result.data);
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
      this.resetQueryFormData();
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

  .sure-button {
    background-color: #ffd60c;
  }
</style>
