<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="seal-list-title">
            <h6>印章列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <seal-toolbar  @onSearch="onSearch" @onCreate="onCreate"/>
      <seal-list :page="page" @onDetails="onDetails" @onSearch="onSearch" @onDetail="onDetail"/>
    </el-card>
    <el-dialog :visible.sync="dialogVislble" width="80%" append-to-body :close-on-click-modal="false">
      <seal-form v-if="dialogVislble" @closeDialog="closeDialog" @callback="callback"/>
    </el-dialog>
    <el-dialog :visible.sync="detailVisible" width="60%" append-to-body :close-on-click-modal="false">
      <seal-detail v-if="detailVisible" :slotData="slotData"/>
    </el-dialog>
    <!-- <el-dialog :visible.sync="authorizeVislble" width="60%" append-to-body :close-on-click-modal="false">
      <seal-authorize-form v-if="authorizeVislble" />
    </el-dialog> -->
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  const {mapGetters, mapActions} = createNamespacedHelpers('ContractSealModule');

  import SealList from './list/SealSearchResultList';
  import SealToolbar from './toolbar/SealToolbar';
  import SealForm from './SealForm'
  import SealDetail from './components/SealDetail'

  export default {
    name: 'SealPage',
    components: {
      SealList,
      SealToolbar,
      SealForm,
      SealDetail
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
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.apis().getSealsList();
        this.search({url, keyword, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getLabel(item.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('明细：' + item.name, LabelDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('创建', LabelDetailsPage, formData);
      },
      onCreate () {
        this.dialogVislble = true;
      },
      closeDialog () {
        this.dialogVislble = false;
      },
      callback () {
        this.onSearch();
        this.dialogVislble = false;
      },
      onDetail (row) {
        this.detailVisible = true;
        this.slotData = row;
      }
    },
    data() {
      return {
        dialogVislble: false,
        detailVisible: false,
        slotData: {}
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
<style scoped>
  .seal-toolbar{
    margin-bottom: 10px;
  }
  .seal-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
