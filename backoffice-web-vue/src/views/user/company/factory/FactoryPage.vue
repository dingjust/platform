<template>
  <div class="animated fadeIn content">
    <el-card>
      <factory-toolbar @onNew="onNew" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"/>
      <factory-list :page="page" @onDetails="onDetails" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch">
        <template slot="operations" slot-scope="props">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(props.item)">明细</el-button>
          <el-button type="text" icon="el-icon-edit" @click="onEdit(props.item)">标签</el-button>
        </template>
      </factory-list>
    </el-card>
    <el-dialog title="标签" width="30%" :visible.sync="dialogFormVisible" :before-close="handleClose" append-to-body>
      <factory-labels-form :slotData="item"></factory-labels-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="update()">确 定</el-button>
      </div>
    </el-dialog>

    <el-dialog :visible.sync="detailsDialogVisible" width="80%"  class="purchase-dialog">
      <factory-details-page :slotData="detailsData"></factory-details-page>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions,mapMutations} = createNamespacedHelpers('FactoriesModule');

  import FactoryToolbar from './toolbar/FactoryToolbar';
  import FactoryList from './list/FactoryList';
  import FactoryDetailsPage from './details/FactoryDetailsPage';
  import FactoryLabelsForm from './form/FactoryLabelsForm';

  export default {
    name: 'FactoryPage',
    props: ['slotData'],
    components: {
      FactoryDetailsPage,
      FactoryToolbar,
      FactoryList,
      FactoryLabelsForm
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
        const url = this.apis().updateFactory(this.item.uid);
        const result = await this.$http.put(url, this.item);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('保存成功');
        this.dialogFormVisible = false;

      },

      onSearch(page, size) {
        this.setIsAdvancedSearch(false);
        const keyword = this.keyword;
        const url = this.apis().getFactories()+"?sort=creationtime,desc";
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch(page, size) {
        this.setIsAdvancedSearch(true);
        const queryFormData = this.queryFormData;
        let url = this.apis().getFactories();
        if(this.isTenant()){
          url += "?sort=creationtime,desc";
        }

        this.advancedSearch({url, queryFormData, page, size});
      },
      async onDetails(item) {
        let url = this.apis().getFactory(item.uid);
        if(this.isTenant()){
          url += "?sort=creationtime,desc";
        }
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.detailsData = result;
        this.detailsDialogVisible = !this.detailsDialogVisible;
      },
      async onEdit(item) {
        const url = this.apis().getFactory(item.uid);
        let result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.item = result;
        this.dialogFormVisible = true;
      },
      onNew(formData) {
        this.fn.openSlider('创建工厂', FactoryDetailsPage, formData);
      },
    },
    data() {

      return {
        dialogFormVisible: false,
        detailsDialogVisible: false,
        item: {},
        detailsData: ''
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
