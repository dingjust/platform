<template>
  <div class="animated fadeIn content">
    <el-card>
      <factory-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <factory-list :page="page" @onDetails="onDetails" @onSearch="onSearch" @onLabels="onLabels">
        <template slot="operations" slot-scope="props">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(props.item)">明细</el-button>
          <el-button type="text" icon="el-icon-edit" @click="onLabels(props.item)">标签评级</el-button>
        </template>
      </factory-list>
    </el-card>
    <el-dialog title="修改标签和评分" width="450px" :visible.sync="this.dialogFormVisible" :before-close="handleClose">
      <factory-labels-form :slotData = "this.item"></factory-labels-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="update()">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('FactoriesModule');

  import FactoryToolbar from './toolbar/FactoryToolbar';
  import FactoryList from './list/FactoryList';
  import FactoryDetailsPage from './details/FactoryDetailsPage';
  import FactoryLabelsForm from './form/FactoryLabelsForm';

  export default {
    name: 'FactoryPage',
    props: ['slotData'],
    components: {
      FactoryToolbar,
      FactoryList,
      FactoryLabelsForm
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
      }),
      handleClose(done) {
       this.dialogFormVisible = false;
      },
      async update() {
        const url = this.apis().updateFactory(this.item.uid);
        console.log(this.item.labels+"testlhj");
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
        const url = this.apis().getFactories();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getFactory(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('品牌：' + item.name, FactoryDetailsPage, result);
      },
      async onLabels(item) {
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
        this.fn.openSlider('创建工厂', FactoryLabelsPage, formData);
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
