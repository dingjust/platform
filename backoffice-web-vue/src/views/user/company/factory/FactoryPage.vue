<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>工厂商家</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <factory-toolbar @onNew="onNew" @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch" @resetSeachInfo="resetSeachInfo"/>
      <el-row type="flex" justify="end">
          <el-checkbox v-model="searchInfo.enableShow" border size="mini" @change="val => val ? searchInfo.unEnableShow=false : ''">已显示</el-checkbox>
          <el-checkbox v-model="searchInfo.unEnableShow" border size="mini" @change="val => val ? searchInfo.enableShow=false : ''">未显示</el-checkbox>
          <el-checkbox v-model="searchInfo.profileCom" border size="mini" @change="val => val ? searchInfo.unProfileCom=false : ''">资料完善</el-checkbox>
          <el-checkbox v-model="searchInfo.unProfileCom" border size="mini" @change="val => val ? searchInfo.profileCom=false : ''">资料未完善</el-checkbox>
      </el-row>
      <el-tabs v-model="activeName" @tab-click="handleTabClick">
        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">
          <factory-list :page="page" @onDetails="onDetails" :sequanceSort="sequanceSort" @onAdvancedSearch="onAdvancedSearch">
            <template slot="operations" slot-scope="props">
              <el-dropdown @command="handleCommand($event, props.item)">
                <span class="el-dropdown-link">
                  更多操作<i class="el-icon--right" style="font-size:12px"></i>
                </span>
                <el-dropdown-menu slot="dropdown">
                  <el-dropdown-item command="DETAIL">明细</el-dropdown-item>
                  <el-dropdown-item command="LABEL">标签</el-dropdown-item>
                  <el-dropdown-item v-if="!props.item.loginDisabled" command="DISABLED">禁用</el-dropdown-item>
                  <el-dropdown-item v-if="props.item.loginDisabled" command="UNDISABLED">解禁</el-dropdown-item>
                  <el-dropdown-item command="CLEARAUTH">清除认证</el-dropdown-item>
                  <el-dropdown-item command="SHOW">
                    {{props.item.enableShow === true ? '关闭显示' : '开启显示'}}
                  </el-dropdown-item>
                  <el-dropdown-item command="SORT">修改序列值</el-dropdown-item>
                </el-dropdown-menu>
              </el-dropdown>
            </template>
          </factory-list>
        </el-tab-pane>
      </el-tabs>
    </el-card>
    <el-dialog title="标签" width="30%" :visible.sync="dialogFormVisible" :before-close="handleClose"
               append-to-body :close-on-click-modal="false">
      <factory-labels-form :slotData="item"></factory-labels-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="update()">确 定</el-button>
      </div>
    </el-dialog>

    <el-dialog :visible.sync="detailsDialogVisible" width="80%"  class="purchase-dialog" :close-on-click-modal="false">
      <factory-from v-if="detailsDialogVisible" :slotData="detailsData" :readOnly="true"></factory-from>
    </el-dialog>
    <el-dialog title="禁用" :visible.sync="forbiddenDialogVisible" width="30%" :close-on-click-modal="false">
      <factory-forbidden-dialog  @onCancel="onCancel" @onConfirm="onConfirm"/>
    </el-dialog>
    <el-dialog title="清除认证" :visible.sync="authVisible" width="400px" :close-on-click-modal="false">
      <authentication-clear-form v-if="authVisible" :clearRow="clearRow" @onCancel="authVisible = false" @callback="callback"/>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions, mapMutations} = createNamespacedHelpers('FactoriesModule');

  import FactoryToolbar from './toolbar/FactoryToolbar';
  import FactoryList from './list/FactoryList';
  import FactoryDetailsPage from './details/FactoryDetailsPage';
  import FactoryLabelsForm from './form/FactoryLabelsForm';
  import FactoryFrom from './form/FactoryForm';
  import FactoryForbiddenDialog from './form/FactoryForbiddenDialog';
  import AuthenticationClearForm from '../components/AuthenticationClearForm'

  export default {
    name: 'FactoryPage',
    props: ['slotData'],
    components: {
      FactoryForbiddenDialog,
      FactoryFrom,
      FactoryDetailsPage,
      FactoryToolbar,
      FactoryList,
      FactoryLabelsForm,
      AuthenticationClearForm
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
        const url = this.apis().updateFactory(this.item.uid);
        const result = await this.$http.put(url, this.item);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('保存成功');
        this.dialogFormVisible = false;
      },
      onSearch (page, size) {
        this.setIsAdvancedSearch(false);
        const keyword = this.keyword;
        const url = this.apis().getFactories() + '?sort=creationtime,desc';
        this.search({url, keyword, page, size});
      },
      handleChange () {
        
      },
      onAdvancedSearch (page, size) {
        this.setIsAdvancedSearch(true);

        let queryFormData = Object.assign({}, this.queryFormData);
        queryFormData.reviewState = '';
        queryFormData.enableShow = this.searchInfo.enableShow ? true : (this.searchInfo.unEnableShow ? false : '');
        queryFormData.profileCompleted = this.searchInfo.profileCom ? true : (this.searchInfo.unProfileCom ? false : '');

        let url = this.apis().getFactories();
        if (this.isTenant()) {
          url += '?' + this.sequanceSort.value + 'sort=creationtime,desc';
        }

        this.advancedSearch({url, queryFormData, page, size});
      },
      handleCommand(command, row) {
        switch (command) {
          case 'DETAIL':
            this.onDetails(row);
            break;
          case 'LABEL':
            this.onEdit(row);
            break;
          case 'DISABLED':
            this.onDelete(row);
            break;
          case 'UNDISABLED':
            this.onCannelDelete(row);
            break;
          case 'CLEARAUTH':
            this.clearAuth(row);
            break;
          case 'SHOW':
            this.modifyIsShow(row);
            break;
          case 'SORT':
            this.setFactorySequence(row);
          default:
            break;
        }
      },
      setFactorySequence (row) {
        this.$prompt('请输入序列值', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          inputPattern: /^[0-9]*$/,
          inputErrorMessage: '请输入正确值（0以上正整数）',
          closeOnClickModal: false,
          closeOnPressEscape: false
        }).then(({ value }) => {
          this.$confirm('是否将工厂 ' + row.name + ' 的序列值设置为 ' + value, '提示', {
            confirmButtonText: '是',
            cancelButtonText: '否',
            type: 'warning'
          }).then(() => {
            this._setFactorySequence(row, value);
          });
        })
      },
      async _setFactorySequence (row, sequence) {
        const url = this.apis().setFactorySequence(row.uid, sequence);
        const result = await this.$http.put(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }

        this.$message.success('设置序列值成功！');
        this.onAdvancedSearch();
      },
      async onDetails (item) {
        let url = this.apis().getFactory(item.uid);
        if (this.isTenant()) {
          url += '?sort=creationtime,desc';
        }
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.detailsData = result;
        this.detailsDialogVisible = !this.detailsDialogVisible;
      },
      async onEdit (item) {
        const url = this.apis().getFactory(item.uid);
        let result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.item = result;
        this.dialogFormVisible = true;
      },
      onNew (formData) {
        this.fn.openSlider('创建工厂', FactoryDetailsPage, formData);
      },
      onDelete (item) {
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
      },
      modifyIsShow (row) {
        if (row.enableShow === true) {
          this.$prompt('请输入关闭工厂：' + row.name + ' 展示的原因', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            inputPattern: /^[\s\S]*.*[^\s][\s\S]*$/,
            inputErrorMessage: '请输入原因',
            closeOnClickModal: false,
            closeOnPressEscape: false
          }).then(({ value }) => {
            this._modifyIsShow(row.uid, false, value);
          })
        } else {
          this.$confirm('是否开启工厂：' + row.name + ' 展示', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning',
            closeOnClickModal: false,
            closeOnPressEscape: false
          }).then(() => {
            this._modifyIsShow(row.uid, true);
          })
        }
      },
      async _modifyIsShow (uid, isShow, message) {
        const url = this.apis().FactoryShow(uid, isShow);
        const result = await this.$http.put(url, {
          reason: message ? message : ''
        });

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return
        }

        this.onAdvancedSearch();
      },
      resetSeachInfo () {
        this.searchInfo = {
          enableShow: null,
          unEnableShow: null,
          profileCom: null,
          unProfileCom: null,
        }
      }
    },
    data () {
      return {
        searchInfo: {
          enableShow: null,
          unEnableShow: null,
          profileCom: null,
          unProfileCom: null,
        },
        sequanceSort: {
          value: ''
        },
        dialogFormVisible: false,
        detailsDialogVisible: false,
        item: {},
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
        clearRow: ''
      };
    },
    created () {
      this.onAdvancedSearch();
    }
  };
</script>

<style scoped>
.el-dropdown-link {
  font-size: 12px;
  cursor: pointer;
  color: #409EFF;
}
</style>
