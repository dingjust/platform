<template>
  <div id="content">
  <el-dialog :visible.sync="tempFormVisible" class="purchase-dialog"
             width="80%" append-to-body :close-on-click-modal="false">
    <template-form v-if="tempFormVisible" @onSearch="onSearch" :tempFormVisible="tempFormVisible" :slotData="mockData"
                   v-on:turnTempFormVisible="turnTempFormVisible" @getTemplateListPt="getTemplateListPt"></template-form>
  </el-dialog>
  <el-form :inline="true">
    <el-form-item>
      <el-input style="width: 250px" placeholder="模板名称" v-model="keyword"></el-input>
    </el-form-item>
    <el-form-item label="模板类型">
      <el-select v-model="type" clearable placeholder="选择模板类型">
        <el-option
          v-for="item in TemplateType"
          :key="item.value"
          :label="item.name"
          :value="item.code">
        </el-option>
      </el-select>
    </el-form-item>
    <el-button type="primary" class="toolbar-search_input" @click="onSearch">搜索</el-button>
    <authorized :authority="permission.agreementTmplCreate">
      <el-button type="primary" class="toolbar-search_input" @click="onCreate">新建</el-button>
    </authorized>
  </el-form>
  <!--<el-form :inline="true">-->
    <!--<el-row type="flex" justify="space-between">-->
      <!--&lt;!&ndash;<el-col :span="8">&ndash;&gt;-->
        <!--&lt;!&ndash;<el-row type="flex" justify="space-around">&ndash;&gt;-->
          <!--&lt;!&ndash;<el-button-group>&ndash;&gt;-->
            <!--&lt;!&ndash;<el-button @click="onDel()">删除</el-button>&ndash;&gt;-->
            <!--&lt;!&ndash;<el-button>下载</el-button>&ndash;&gt;-->
            <!--&lt;!&ndash;<el-button>启用</el-button>&ndash;&gt;-->
            <!--&lt;!&ndash;<el-button>禁用</el-button>&ndash;&gt;-->
          <!--&lt;!&ndash;</el-button-group>&ndash;&gt;-->
          <!--&lt;!&ndash;<el-button type="text" @click="onCreate()">新建模板</el-button>&ndash;&gt;-->
        <!--&lt;!&ndash;</el-row>&ndash;&gt;-->
      <!--&lt;!&ndash;</el-col>&ndash;&gt;-->
    <!--</el-row>-->
  <!--</el-form>-->
  </div>
</template>

<script>
  import http from '@/common/js/http';
  import {
    createNamespacedHelpers
  } from 'vuex';
  import TemplateForm from '../components/TemplateForm';
  import TemplateSearchResultList from '../list/TemplateSearchResultList';

  const {
    mapMutations
  } = createNamespacedHelpers('ContractTemplateModule');

  export default {
    name: 'TemplateToolbar',
    props: ['code'],
    components: {
      TemplateForm,
      TemplateSearchResultList
    },
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
        setType: 'type',
        type: 'type'
      }),
      onSearch () {
        this.setKeyword(this.keyword);
        this.setType(this.type);
        this.$emit('onSearch', 0);
      },
      onCreate () {
        // this.$router.push("templateForm");
        // this.fn.openSlider("创建", TemplateForm);
        this.tempFormVisible = true;
      },
      async onDel () {
        console.log(this.$parent.selectedCode);
        // const url = this.apis().deleteTemplate(code);
        // const result = await this.$http.get(url);
      },
      turnTempFormVisible () {
        this.tempFormVisible = !this.tempFormVisible;
      },
      async getTemplateListPt () {
        const url = this.apis().getTemplatesListPt();
        const result = await http.post(url, {
          keyword: ''
        }, {
          page: 0,
          size: 10
        });
        console.log(result);
        this.mockData = result.content;
        this.sortData();
      },
      sortData () {
        let arr = [];
        this.mockData.map(value => {
          if (value.title === '委托生产合同') {
            arr[0] = value;
          }
          if (value.title === '采购订单') {
            arr[1] = value;
          }
          if (value.title === '框架协议') {
            arr[2] = value;
          }
          if (value.title === '补充协议') {
            arr[3] = value;
          }
        });
        this.mockData = arr;
      }
    },
    data () {
      return {
        tempFormVisible: false,
        keyword: this.$store.state.ContractTemplateModule.keyword,
        formData: this.$store.state.ContractTemplateModule.formData,
        queryFormData: this.$store.state.ContractTemplateModule.queryFormData,
        type: this.$store.state.ContractTemplateModule.type,
        mockData: [],
        TemplateType: [{
          code: 'BCXY',
          name: '补充协议'
        },
        {
          code: 'WTSCHT',
          name: '委托生产合同'
        },
        {
          code: 'CGDD',
          name: '采购订单'
        },
        {
          code: 'KJXY',
          name: '框架协议'
        }]
      };
    },
    created () {
      this.getTemplateListPt();
    }
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
