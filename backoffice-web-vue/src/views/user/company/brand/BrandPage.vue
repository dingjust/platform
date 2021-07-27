<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col>
          <div class="orders-list-title">
            <h6>品牌商家</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <brand-toolbar @onNew="onNew" @onSearch="onSearch"  @onAdvancedSearch="onAdvancedSearch"/>
      <el-tabs v-model="activeName" @tab-click="handleTabClick">
        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">
          <brand-list :page="page" @onDetails="onDetails" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch">
            <template slot="operations" slot-scope="props">
              <el-dropdown @command="handleCommand($event, props.item)" trigger="click">
                <span class="el-dropdown-link">
                  更多操作<i class="el-icon--right" style="font-size:12px"></i>
                </span>
                <el-dropdown-menu slot="dropdown">
                  <el-dropdown-item command="DETAIL">明细</el-dropdown-item>
                  <el-dropdown-item command="MODIFY">修改</el-dropdown-item>
                  <el-dropdown-item command="LABEL">标签</el-dropdown-item>
                  <el-dropdown-item v-if="!props.item.loginDisabled" command="DISABLED">禁用</el-dropdown-item>
                  <el-dropdown-item v-if="props.item.loginDisabled" command="UNDISABLED">解禁</el-dropdown-item>
                  <el-dropdown-item command="CLEARAUTH">清除认证</el-dropdown-item>
                </el-dropdown-menu>
              </el-dropdown>
            </template>
          </brand-list>
        </el-tab-pane>
      </el-tabs>
    </el-card>
    <el-dialog title="修改标签和评分" width="450px" :visible.sync="this.dialogFormVisible" :before-close="handleClose"
               append-to-body :close-on-click-modal="false">
      <brand-labels-form :slotData = "this.item"></brand-labels-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="update()">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog :visible.sync="detailsDialogVisible" width="80%"  class="purchase-dialog" :close-on-click-modal="false">
      <brand-form1 v-if="detailsDialogVisible" :slotData="detailsData" :readOnly="true"></brand-form1>
    </el-dialog>
    <el-dialog title="禁用" :visible.sync="forbiddenDialogVisible" width="30%" :close-on-click-modal="false">
      <brand-forbidden-dialog  @onCancel="onCancel" @onConfirm="onConfirm"/>
    </el-dialog>
    <el-dialog title="清除认证" :visible.sync="authVisible" width="400px" :close-on-click-modal="false">
      <authentication-clear-form v-if="authVisible" :clearRow="clearRow" @onCancel="authVisible = false" @callback="callback"/>
    </el-dialog>
    <el-dialog :visible.sync="modifyVisible" width="80%" :close-on-click-modal="false">
      <brand-form-by-tenant v-if="modifyVisible" :row="handleRow" @callback="modifyVisible=false"/>
    </el-dialog>
  </div>
</template>

<script>
import {createNamespacedHelpers} from 'vuex';

const {mapGetters, mapActions, mapMutations} = createNamespacedHelpers('BrandsModule');

import BrandToolbar from './toolbar/BrandToolbar';
import BrandList from './list/BrandList';
import BrandDetailsPage from './details/BrandDetailsPage';
import AddressForm from '../../../shared/user/address/AddressForm';
import BrandLabelsForm from './form/BrandLabelsForm';
import BrandForm1 from './form/BrandForm1';
import BrandForbiddenDialog from './form/BrandForbiddenDialog';
import AuthenticationClearForm from '../components/AuthenticationClearForm'
import BrandFormByTenant from './form/BrandFormByTenant.vue';

export default {
  name: 'BrandPage',
  components: {
    BrandForbiddenDialog,
    BrandForm1,
    AddressForm,
    BrandToolbar,
    BrandList,
    BrandLabelsForm,
    AuthenticationClearForm,
    BrandFormByTenant
  },
  computed: {
    ...mapGetters({
      page: 'page',
      keyword: 'keyword',
      queryFormData: 'queryFormData'
    })
  },
  methods: {
    ...mapActions({
      search: 'search',
      advancedSearch: 'advancedSearch'
    }),
    ...mapMutations({
      setIsAdvancedSearch: 'isAdvancedSearch'
    }),
    handleClose (done) {
      this.dialogFormVisible = false;
    },
    async update () {
      const url = this.apis().updateBrand(this.item.uid);
      const result = await this.$http.put(url, this.item);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.$message.success('保存成功');
      this.dialogFormVisible = false;
    },
    onSearch (page, size) {
      const keyword = this.keyword;
      this.setIsAdvancedSearch(false);
      const url = this.apis().getBrands();
      this.search({url, keyword, page, size});
    },
    onAdvancedSearch (page, size) {
      const queryFormData = this.queryFormData;
      const url = this.apis().getBrands();
      this.setIsAdvancedSearch(true);
      this.advancedSearch({url, queryFormData, page, size});
    },
    handleCommand(command, row) {
      switch (command) {
        case 'DETAIL':
          this.onDetails(row);
          break;
        case 'MODIFY':
          this.onModify(row);
          break;
        case 'LABEL':
          this.onEdit(row);
          break;
        case 'DISABLED':
          this.onForbidden(row);
          break;
        case 'UNDISABLED':
          this.onCannelDelete(row);
          break;
        case 'CLEARAUTH':
          this.clearAuth(row);
          break;
        default:
          break;
      }
    },
    onModify (row) {
      this.handleRow = row
      this.modifyVisible = true
    },
    async onDetails (item) {
      const url = this.apis().getBrand(item.uid);

      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.duties == null || result.duties == undefined) {
        result.duties = '经理';
      }

      this.detailsData = result;
      this.detailsDialogVisible = true;
    },
    async onEdit (item) {
      const url = this.apis().getBrand(item.uid);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      this.item = result;
      this.dialogFormVisible = true;
    },
    onNew (formData) {
      this.fn.openSlider('创建品牌', BrandDetailsPage, formData);
    },
    onForbidden (item) {
      this.$confirm('你确定要禁用该账号吗', '禁用', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.forbiddenItem = item;
        this.forbiddenDialogVisible = true;
      });
    },
    onCancel () {
      this.forbiddenDialogVisible = false;
    },
    async onConfirm (msg) {
      let formData = {
        'msg' : msg
      }
      const url = this.apis().forbiddenCompany(this.forbiddenItem.uid);
      const result = await this.$http.put(url, formData);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      this.$message.success('工厂禁用成功');
      this.onAdvancedSearch(this.page.number);
      this.forbiddenDialogVisible = false;
    },
    onCannelDelete (item) {
      this.$confirm('你确定要解禁该账号吗', '禁用', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.onCannelDeleteConfirm(item);
      });
    },
    async onCannelDeleteConfirm (item) {
      const url = this.apis().cannelForbiddenCompany(item.uid);
      const result = await this.$http.put(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      this.$message.success('工厂解禁成功');
      this.onAdvancedSearch(this.page.number);
    },
    handleTabClick (tab) {
      if (tab.name !== '') {
        if (tab.name === 'unapproved') {
          this.queryFormData.approvalStatuses = ['unapproved', 'check'];
        } else {
          this.queryFormData.approvalStatuses = tab.name;
        }
      } else {
        this.queryFormData.approvalStatuses = [];
      }
      this.onAdvancedSearch();
    },
    clearAuth (row) {
      this.authVisible = true;
      this.clearRow = row;
    },
    callback () {
      this.authVisible = false;
      let page = this.page.number;
      if (this.activeName.approved && this.page.size === 1) {
        page = this.page.number - 1;
      }
      this.onAdvancedSearch(page);
    }
  },
  data () {
    return {
      dialogFormVisible: false,
      item: {},
      detailsDialogVisible: false,
      detailsData: '',
      forbiddenDialogVisible: false,
      forbiddenItem: '',
      statuses: [{
        code: '',
        name: '全部'
      },
      {
        code: 'approved',
        name: '已认证'
      },
      {
        code: 'unapproved',
        name: '未认证'
      }],
      activeName: '',
      authVisible: false,
      clearRow: '',
      handleRow: null,
      modifyVisible: false
    };
  },
  created () {
    this.onAdvancedSearch();
  }
};
</script>
<style scoped>
  .orders-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .el-dropdown-link {
    font-size: 12px;
    cursor: pointer;
    color: #409EFF;
  }
</style>
