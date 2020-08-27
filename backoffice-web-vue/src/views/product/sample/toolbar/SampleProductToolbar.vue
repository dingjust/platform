<template>
  <el-form :inline="true">
    <el-row type="flex" justify="space-between">
      <!--      <el-form-item label="">-->
      <!--        <el-input placeholder="请输入产品货号/名称查询" v-model="keyword" style="width: 250px"></el-input>-->
      <!--      </el-form-item>-->
      <!--    <el-row type="flex"  justify="space-between">-->
      <!--      <el-col :span="20">-->
      <el-col :span="19">
        <el-form-item label="产品信息">
          <el-input v-model="queryFormData.keyword" placeholder="输入产品名、款号、编号"></el-input>
        </el-form-item>
        <!-- <el-form-item label="部门/人员" prop="name"> -->
          <!-- <el-input placeholder="跟单员姓名" v-model="queryFormData.planLeader" class="input-item"></el-input> -->
          <!-- <dept-person-select ref="deptPersonSelect" :dataQuery="dataQuery" width="170" -->
            <!-- :selectDept="queryFormData.depts" :selectPerson="queryFormData.users" /> -->
        <!-- </el-form-item> -->
        <!-- <el-form-item label="产品名">
          <el-input placeholder="输入产品名" v-model="queryFormData.name"></el-input>
        </el-form-item>
        <el-form-item label="款号">
          <el-input placeholder="输入款号" v-model="queryFormData.skuID"></el-input>
        </el-form-item>
        <el-form-item label="编号">
          <el-input placeholder="输入编号" v-model="queryFormData.code"></el-input>
        </el-form-item> -->
        <el-form-item v-if="isTenant()" label="所属公司">
          <el-input placeholder="输入公司名称" v-model="queryFormData.belongToName"></el-input>
        </el-form-item>
        <el-form-item label="品类">
          <el-select v-model="queryFormData.categories" placeholder="请选择" class="w-80 form-select" filterable
            reserve-keyword clearable collapse-tags multiple>
            <el-option-group v-for="level1 in categories" :key="level1.code" :label="level1.name">
              <el-option v-for="level2 in level1.children" :key="level2.code" :label="level2.name" :value="level2.code">
              </el-option>
            </el-option-group>
          </el-select>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
          <el-button native-type="reset" @click="onReset">重置</el-button>
        </el-button-group>
      </el-col>
      <el-col :span="5">
        <el-row type="flex" justify="end">
          <el-button-group>
            <Authorized :permission="['SAMPLE_CLOTHES_PRODUCT_CREATE']">
              <el-button v-if="!isTenant()" class="create-btn" size="medium" @click="onNew">添加产品</el-button>
            </Authorized>
            <el-dropdown @command="handleCommand">
              <Authorized :permission="['SAMPLE_CLOTHES_PRODUCT_CREATE']">
                <el-button v-if="!isTenant()" class="create-btn" size="medium">操作<i
                    class="el-icon-arrow-down el-icon--right"></i></el-button>
              </Authorized>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item command="0">批量导入</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </el-button-group>
        </el-row>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import {
    DeptPersonSelect
  } from '@/components'

  import ProductImport from '../../excel/ProductImport'

  const {
    mapMutations
  } = createNamespacedHelpers('SampleProductsModule');

  export default {
    name: 'SampleProductToolbar',
    props: ['queryFormData', 'dataQuery'],
    components: {
      DeptPersonSelect,
      ProductImport
    },
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
      }),
      onSearch() {
        // this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onAdvancedSearch() {
        // this.setQueryFormData(this.queryFormData);
        this.$emit('onAdvancedSearch', 0);
      },
      onNew() {
        let formData = {};
        Object.assign(formData, this.formData);

        this.$emit('onNew', formData);
      },
      async getCategories() {
        const url = this.apis().getMinorCategories();
        const results = await this.$http.get(url);
        if (!results['errors']) {
          this.categories = results;
        }
      },
      onReset() {
        this.queryFormData.keyword = '';
        this.queryFormData.name = '';
        this.queryFormData.skuID = '';
        this.queryFormData.categories = '';
        this.queryFormData.approvalStatuses = '';
        this.queryFormData.belongToName = '';
        // this.$refs.deptPersonSelect.clearSelectData();
        // this.$emit('onResetQuery');
      },
      showStatus(val) {
        if (this.queryFormData.approvalStatuses === val.code) {
          return true;
        }
        return false;
      },
      handleTagClick(val) {
        this.queryFormData.approvalStatuses = val.code;
        this.onAdvancedSearch();
      },
      handleCommand(val) {
        if (val == '0') {
          this.importDialogVisible = true;
        }
      }
    },
    data() {
      return {
        keyword: '',
        importDialogVisible: false,
        formData: this.$store.state.SampleProductsModule.newFormData,
        approvalStatuses: [{
            code: '',
            name: '全部'
          },
          {
            code: 'approved',
            name: '已上架'
          },
          {
            code: 'unapproved',
            name: '已下架'
          }
        ],
        categories: [],
        selectCodes: []
      }
    },
    created() {
      this.getCategories();
    }
  }

</script>
<style scoped>
  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .elTagClass {
    color: #0b0e0f;
    margin-right: 20px;
    margin-bottom: 10px;
    cursor: pointer;
  }

  .titleTextClass {
    /*text-align: justify;*/
    /*text-align-last: justify;*/
    display: inline-block;
    /*width: 57px;*/
    /*font-size: 12px;*/
    /*font-weight: bold;*/
  }

  .el-tag {
    border-color: white;
  }

  .create-btn {
    /* background-color: #ffd60c;
    color: #606266;
    width: 90px; */
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .create-btn:focus {
    background: #ffd60c;
    color: #606266;
  }

  .create-btn:hover {
    background: #ffd60c;
    color: #606266;
  }

  .form-select {
    width: 150px;
  }

</style>
