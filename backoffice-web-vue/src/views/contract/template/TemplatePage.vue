<template>
  <div class="animated fadeIn content">
    <!--<div class="report">-->
      <!--<template-report />-->
    <!--</div>-->
    <el-card>
      <template-toolbar ref="tempTool" @onNew="onNew" @onSearch="onSearch" class="template-toolbar" />
      <template-list ref="tempList" :page="page" @onDetails="onDetails" @onSearch="onSearch" />
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from "vuex";
  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    "ContractTemplateModule"
  );

  import TemplateList from "./list/TemplateSearchResultList";
  import TemplateReport from "./components/TemplateReport";
  import TemplateToolbar from "./toolbar/TemplateToolbar";
  import TemplateForm from "./components/TemplateForm";
  import TemplateDetail from "./detail/TemplateDetail";

  export default {
    name: "TemplatePage",
    components: {
      TemplateList,
      TemplateReport,
      TemplateToolbar,
      TemplateForm,
      TemplateDetail,
    },
    computed: {
      ...mapGetters({
        page: "page",
        keyword: "keyword",
        type:'type'
      })
    },
    methods: {
      ...mapActions({
        search: "search"
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const type = this.type;
        const url = this.apis().getTemplatesList();
        this.search({ url, keyword,type, page, size });
      },
      async onDetails(code) {
        const url = this.apis().getTemplates(code);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        console.log(result);
        this.fn.openSlider("查看：", TemplateDetail, result.data);
      },
      onNew(formData) {
        this.fn.openSlider("创建", LabelDetailsPage, formData);
      },
    },
    data() {
      return {
      };
    },
    created() {
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

</style>
