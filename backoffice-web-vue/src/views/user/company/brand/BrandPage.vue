<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="orders-list-title">
            <h6>品牌商家</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <brand-toolbar @onNew="onNew" @onSearch="onSearch"  @onAdvancedSearch="onAdvancedSearch"/>
      <brand-list :page="page" @onDetails="onDetails" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch">
        <template slot="operations" slot-scope="props">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(props.item)">明细</el-button>
          <el-button type="text" icon="el-icon-edit" @click="onEdit(props.item)">打标</el-button>
<!--          <el-button type="text" icon="el-icon-edit" @click="onForbidden(props.item)">禁用</el-button>-->
        </template>
      </brand-list>
    </el-card>
    <el-dialog title="修改标签和评分" width="450px" :visible.sync="this.dialogFormVisible" :before-close="handleClose"
               append-to-body :close-on-click-modal="false">
      <brand-labels-form :slotData = "this.item"></brand-labels-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="update()">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog :visible.sync="detailsDialogVisible" width="80%"  class="purchase-dialog" :close-on-click-modal="false">
      <brand-from1 v-if="detailsDialogVisible" :slotData="detailsData" :readOnly="true"></brand-from1>
    </el-dialog>
    <!-- <el-dialog title="禁用" :visible.sync="forbiddenDialogVisible" width="30%" :close-on-click-modal="false">
      <brand-forbidden-dialog  @onCancel="onCancel" @onConfirm="onConfirm"/>
    </el-dialog> -->
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions, mapMutations} = createNamespacedHelpers('BrandsModule');

  import BrandToolbar from './toolbar/BrandToolbar';
  import BrandList from './list/BrandList';
  import BrandDetailsPage from './details/BrandDetailsPage';
  import AddressForm from '../../../shared/user/address/AddressForm';
  import BrandLabelsForm from './form/BrandLabelsForm';
  import BrandFrom1 from './form/BrandForm1';
  // import BrandForbiddenDialog from './form/BrandForbiddenDialog';

  export default {
    name: 'BrandPage',
    components: {
      // BrandForbiddenDialog,
      BrandFrom1,
      AddressForm,
      BrandToolbar,
      BrandList,
      BrandLabelsForm
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        advancedSearch: 'advancedSearch'
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch'
      }),
      handleClose (done) {
        this.dialogFormVisible = false;
      },
      async update () {
        const url = this.apis().updateBrand(this.item.uid);
        const result = await this.$http.put(url, this.item);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('保存成功');
        this.dialogFormVisible = false;
      },
      onSearch (page, size) {
        const keyword = this.keyword;
        this.setIsAdvancedSearch(false);
        const url = this.apis().getBrands();
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch (page, size) {
        const queryFormData = this.queryFormData;
        const url = this.apis().getBrands();
        this.setIsAdvancedSearch(true);
        this.advancedSearch({url, queryFormData, page, size});
      },
      async onDetails (item) {
        // const url = this.apis().getBrand(item.uid);
        // const result = await this.$http.get(url);
        // if (result['errors']) {
        //   this.$message.error(result['errors'][0].message);
        //   return;
        // }
        // this.detailsDialogVisible = true;
        // this.detailsData = result;
        // // this.fn.openSlider('品牌：' + item.name, BrandDetailsPage, result);
        let url = this.apis().getBrand(item.uid);
        if (this.isTenant()) {
          url += '?sort=creationtime,desc';
        }
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.duties == null || result.duties == undefined) {
          result.duties = '经理';
        }

        this.detailsData = result;
        this.detailsDialogVisible = true;
      },
      async onEdit (item) {
        const url = this.apis().getBrand(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.item = result;
        this.dialogFormVisible = true;
      },
      onNew (formData) {
        this.fn.openSlider('创建品牌', BrandDetailsPage, formData);
      },
      onForbidden (item) {
        this.forbiddenItem = item;
        this.forbiddenDialogVisible = true;
      },
      onCancel () {
        this.forbiddenDialogVisible = false;
      },
      onConfirm () {
        // TODO 禁用
        this.onAdvancedSearch();
        this.forbiddenDialogVisible = false;
      }
    },
    data () {
      return {
        dialogFormVisible: false,
        item: {},
        detailsDialogVisible: false,
        detailsData: '',
        forbiddenDialogVisible: false,
        forbiddenItem: ''
      };
    },
    created () {
      this.onSearch();
    }
  };
</script>
<style scoped>
  .orders-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
