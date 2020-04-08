<template>
  <div class="animated fadeIn">
    <el-row>
      <el-col :span="12">
        <div class="orders-list-title">
          <h6>产品列表</h6>
        </div>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <div style="padding: 10px">
      <product-select-toolbar @onAdvancedSearch="onAdvancedSearch"></product-select-toolbar>
      <el-tabs v-model="activeName" @tab-click="handleTabClick">
        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">
          <product-select-list ref="selectList" :page="page" @onAdvancedSearch="onAdvancedSearch" @onSearch="onSearch"/>
        </el-tab-pane>
      </el-tabs>
      <el-row type="flex" justify="center" style="margin-top: 40px">
        <el-button @click="onConfirm" style="background-color: #FFD60C" size="medium">确定</el-button>
      </el-row>
    </div>
  </div>
</template>

<script>
  import ProductSelectList from '../list/ProductSelectList';
  import ProductSelectToolbar from '../toolbar/ProductSelectToolbar';
  export default {
    name: 'PromoteProductSelectDialog',
    components: {ProductSelectToolbar, ProductSelectList},
    props: ['page'],
    methods: {
      onSearch (val) {
        this.$emit('onSearch', val);
      },
      onAdvancedSearch (val) {
        this.$emit('onAdvancedSearch', val);
      },
      handleTabClick (tab) {
        if (tab.name !== '') {
          this.queryFormData.approvalStatuses = tab.name;
        } else {
          this.queryFormData.approvalStatuses = [];
        }
        this.onAdvancedSearch();
      },
      onConfirm () {
        this.$emit('confirmPromoteProductList');
      }
    },
    data () {
      return {
        queryFormData: this.$store.state.ApparelProductsModule.queryFormData,
        activeName: '',
        statuses: [
          {
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
        ]
      }
    }
  }
</script>

<style scoped>
  .orders-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
