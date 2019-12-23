<template>
  <div class="animated fadeIn content">
    <el-card>
      <brand-toolbar @onNew="onNew" @onSearch="onSearch"  @onAdvancedSearch="onAdvancedSearch"/>
      <brand-list :page="page" @onDetails="onDetails" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch">
        <template slot="operations" slot-scope="props">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(props.item)">明细</el-button>
          <el-button type="text" icon="el-icon-edit" @click="onEdit(props.item)">标签评级</el-button>
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
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions,mapMutations} = createNamespacedHelpers('BrandsModule');

  import BrandToolbar from './toolbar/BrandToolbar';
  import BrandList from './list/BrandList';
  import BrandDetailsPage from './details/BrandDetailsPage';
  import AddressForm from "../../../shared/user/address/AddressForm";
  import BrandLabelsForm from './form/BrandLabelsForm';

  export default {
    name: 'BrandPage',
    components: {
      AddressForm,
      BrandToolbar,
      BrandList,
      BrandLabelsForm
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData',

      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        advancedSearch: 'advancedSearch',
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch'
      }),
      handleClose(done) {
        this.dialogFormVisible = false;
      },
      async update() {
        const url = this.apis().updateBrand(this.item.uid);
        const result = await this.$http.put(url, this.item);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('保存成功');
        this.dialogFormVisible = false;

      },
      onSearch(page, size) {
        const keyword = this.keyword;
        this.setIsAdvancedSearch(false);
        const url = this.apis().getBrands();
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch(page, size) {
        const queryFormData = this.queryFormData;
        const url = this.apis().getBrands();
        this.setIsAdvancedSearch(true);
        this.advancedSearch({url, queryFormData, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getBrand(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('品牌：' + item.name, BrandDetailsPage, result);
      },
      async onEdit(item) {
        const url = this.apis().getBrand(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.item = result;
        this.dialogFormVisible = true;
      },
      onNew(formData) {
        this.fn.openSlider('创建品牌', BrandDetailsPage, formData);
      },
    },
    data() {
      return {
        dialogFormVisible: false,
        item:{},
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
