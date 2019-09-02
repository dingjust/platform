<template>
  <el-form :inline="true">
    <el-row type="flex" justify="space-between">
      <!--<el-col :span="8">-->
        <!--<el-row type="flex" justify="space-around">-->
          <!--<el-button-group>-->
            <!--<el-button @click="onDel()">删除</el-button>-->
            <!--<el-button>下载</el-button>-->
            <!--<el-button>启用</el-button>-->
            <!--<el-button>禁用</el-button>-->
          <!--</el-button-group>-->
          <!--<el-button type="text" @click="onCreate()">新建模板</el-button>-->
        <!--</el-row>-->
      <!--</el-col>-->
      <el-col :span="6" >
        <el-row type="flex" justify="space-between">
          <el-input v-model="keyword" placeholder="输入名称"></el-input>
          <el-button type="primary" class="toolbar-search_input" @click="onSearch">搜索</el-button>
          <el-button type="primary" class="toolbar-search_input" @click="onCreate">新建</el-button>
        </el-row>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
  import {
    createNamespacedHelpers
  } from "vuex";
  import TemplateForm from "../components/TemplateForm";
  import TemplateSearchResultList from "../list/TemplateSearchResultList";

  const {
    mapMutations
  } = createNamespacedHelpers("ContractTemplateModule");

  export default {
    name: "TemplateToolbar",
    props: ["code"],
    components: {
      TemplateForm,
      TemplateSearchResultList
    },
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: "keyword",
      }),
      onSearch() {
        this.setKeyword(this.keyword);
        this.$emit("onSearch", 0);
      },
      onCreate() {
        // this.$router.push("templateForm");
        this.fn.openSlider("创建", TemplateForm);
      },
      async onDel(){
        console.log(this.$parent.selectedCode);
        // const url = this.apis().deleteTemplate(code);
        // const result = await this.$http.get(url);
      },
    },
    data() {
      return {
        keyword: this.$store.state.ContractTemplateModule.keyword,
        formData: this.$store.state.ContractTemplateModule.formData,
        queryFormData: this.$store.state.ContractTemplateModule.queryFormData,
      };
    },
    created() {}
  };

</script>
<style>
  .el-input__inner {
    /* border-radius: 5px; */
    line-height: 30px;
  }

  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
    margin-left: 20px;
    color: #000;
  }

</style>
