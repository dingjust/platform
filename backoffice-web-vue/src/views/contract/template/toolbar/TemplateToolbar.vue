<template>
  <div id="content" class="template-toolbar">
    <el-dialog :visible.sync="tempFormVisible" class="purchase-dialog"
              width="80%" append-to-body :close-on-click-modal="false">
      <template-form v-if="tempFormVisible" @onSearch="onSearch" :tempFormVisible="tempFormVisible" :slotData="mockData"
                    v-on:turnTempFormVisible="turnTempFormVisible" @getTemplateListPt="getTemplateListPt"></template-form>
    </el-dialog>
    <el-form :inline="true">
      <el-row type="flex" align="top">
        <el-form-item>
          <el-input style="width: 250px" placeholder="模板名称" v-model="queryFormData.title"></el-input>
        </el-form-item>
        <el-form-item label="模板类型">
          <el-select v-model="queryFormData.type" clearable placeholder="选择模板类型">
            <el-option
              v-for="item in TemplateType"
              :key="item.value"
              :label="item.name"
              :value="item.code">
            </el-option>
          </el-select>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" class="toolbar-search_input" @click="onSearch">搜索</el-button>
          <el-button native-type="reset" @click="onReset">重置</el-button>
        </el-button-group>
        <Authorized :permission="['AGREEMENT_TMPL_CREATE']">
          <el-button type="primary" class="toolbar-search_input" @click="onCreate">新建</el-button>
        </Authorized>
      </el-row>
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
  import TemplateForm from '../components/TemplateForm';
  import TemplateSearchResultList from '../list/TemplateSearchResultList';

  export default {
    name: 'TemplateToolbar',
    props: ['code', 'queryFormData'],
    components: {
      TemplateForm,
      TemplateSearchResultList
    },
    computed: {},
    methods: {
      onSearch () {
        this.$emit('onSearch', 0);
      },
      onReset () {
        this.queryFormData.title = '';
        this.queryFormData.type = '';
      },
      onCreate () {
        this.tempFormVisible = true;
      },
      async onDel () {
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
        this.mockData = result.content.sort((o1, o2) => {
          return this.templateSequence[o1.type] - this.templateSequence[o2.type];
        });
      }
    },
    data () {
      return {
        tempFormVisible: false,
        keyword: this.$store.state.ContractTemplateModule.keyword,
        formData: this.$store.state.ContractTemplateModule.formData,
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
        },
        {
          code: 'ZFXY',
          name: '作废协议'
        }],
        templateSequence: {
          WTSCHT: 0,
          CGDD: 1,
          KJXY: 2,
          BCXY: 3,
          ZFXY: 4
        },
      };
    },
    created () {
      this.getTemplateListPt();
    }
  };
</script>
<style scoped>
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

  .template-toolbar >>> .el-form-item {
    margin-bottom: 0px;
  }
</style>
