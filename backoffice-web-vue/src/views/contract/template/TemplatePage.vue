<template>
  <div class="animated fadeIn content">
    <!--<div class="report">-->
      <!--<template-report />-->
    <!--</div>-->
    <el-dialog :visible.sync="templateDetailVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <template-detail v-if="templateDetailVisible" :slotData="templateData" @closeDetails="closeDetails"/>
    </el-dialog>
    <el-dialog :visible.sync="pdfVisible" :show-close="true" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <div style="float:right;margin-bottom: 10px;margin-top: 10px;height: 30px;">
        <Authorized :permission="['AGREEMENT_TMPL_CREATE']">
          <el-button type="warning" @click="onDetails" class="toolbar-search_input">编辑</el-button>
        </Authorized>
      </div>
      <iframe id='previewPdf' :src="'static/pdf/web/viewer.html?file=' + fileUrl"
              height="480" width="100%">
      </iframe>
    </el-dialog>
    <el-card>
      <el-row>
        <el-col :span="3">
          <div class="template-list-title">
            <h6>合同模板列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <template-toolbar ref="tempTool" @onNew="onNew" @onSearch="onSearch" class="template-toolbar"/>
      <template-list ref="tempList" :page="page" @onDetails="onDetails" @onSearch="onSearch" @openPreviewPdf="openPreviewPdf"/>
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'ContractTemplateModule'
  );

  import TemplateList from './list/TemplateSearchResultList';
  import TemplateReport from './components/TemplateReport';
  import TemplateToolbar from './toolbar/TemplateToolbar';
  import TemplateForm from './components/TemplateForm';
  import TemplateDetail from './detail/TemplateDetail';

  export default {
    name: 'TemplatePage',
    components: {
      TemplateList,
      TemplateReport,
      TemplateToolbar,
      TemplateForm,
      TemplateDetail
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        type: 'type'
      })
    },
    methods: {
      ...mapActions({
        search: 'search'
      }),
      onSearch (page, size) {
        const keyword = this.keyword;
        const type = this.type;
        const url = this.apis().getTemplatesList();
        this.search({ url, keyword, type, page, size });
      },
      async openPreviewPdf (code) {
        this.templateCode = code;
        const url = this.apis().getTemplates(code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
        }

        this.fileUrl = result.data.previewPdf.url;
        this.pdfVisible = true;
      },
      async onDetails () {
        this.pdfVisible = false;
        const url = this.apis().getTemplates(this.templateCode);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        console.log(result);
        this.templateData = result.data;
        this.templateDetailVisible = true;
        // this.fn.openSlider('查看：', TemplateDetail, result.data);
      },
      closeDetails () {
        this.templateDetailVisible = false;
        this.onSearch();
      },
      onNew (formData) {
        this.fn.openSlider('创建', LabelDetailsPage, formData);
      }
    },
    data () {
      return {
        pdfVisible: false,
        fileUrl: '',
        templateCode: '',
        templateDetailVisible: false,
        templateData: ''
      };
    },
    created () {
      this.onSearch();
    }
  };
</script>
<style>
  .report {
    margin-bottom: 10px;
  }

  .template-toolbar{
    padding-bottom: 15px;
    border-bottom: 0.5px solid #E6E6E6;
  }

  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .template-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
