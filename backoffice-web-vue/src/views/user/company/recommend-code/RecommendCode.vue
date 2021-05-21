<template>
  <div class="animated fadeIn content recommend-code">
    <el-card>
      <el-row>
        <div class="recommend-code-title">
          <h6>渠道码</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <recommend-code-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" @onCreate="onCreate"/>
      <recommend-code-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onEdit="onEdit"/>
    </el-card>
    <el-dialog :title="dialogTitle" :visible.sync="appendVisible" width="400px" append-to-body :close-on-click-modal="false">
      <recommend-code-form v-if="appendVisible" :id="editId" @closeDialog="appendVisible=false" @callback="callback"/>
    </el-dialog>
  </div>
</template>

<script>
import {
  createNamespacedHelpers
} from 'vuex';
import RecommendCodeList from './list/RecommendCodeList.vue';
import RecommendCodeToolbar from './toolbar/RecommendCodeToolbar.vue';
import RecommendCodeForm from './form/RecommendCodeForm'

const {
  mapGetters,
  mapActions
} = createNamespacedHelpers(
  'RecommendCodeModule'
);

export default {
  name: 'RecommendCode',
  components: { RecommendCodeList, RecommendCodeToolbar, RecommendCodeForm },
  computed: {
    ...mapGetters({
      page: 'page',
      queryFormData: 'queryFormData'
    }),
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch(page, size) {
      const query = this.queryFormData;
      
      const url = this.apis().searchRecommendCode();
      this.searchAdvanced({
        url,
        query,
        page,
        size
      });
    },
    onCreate () {
      this.dialogTitle = '新增渠道码';
      this.editId = null;
      this.appendVisible = true;
    },
    onEdit (row) {
      this.dialogTitle = '编辑渠道码';
      this.editId = row.id;
      this.appendVisible = true;
    },
    callback () {
      this.onAdvancedSearch();
      this.appendVisible = false;
    }
  },
  data () {
    return {
      appendVisible: false,
      dialogTitle: '',
      editId: null
    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>
  .recommend-code-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>