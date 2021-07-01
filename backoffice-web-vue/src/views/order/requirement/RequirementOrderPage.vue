<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between" align="middle">
        <el-col :span="3">
          <div class="orders-list-title">
            <h6>需求订单列表</h6>
          </div>
        </el-col>
        <el-col :span="2">
          <el-button class="btn-class" @click="onNew" v-if="!isTenant()"><span style="font-size: 14px">+</span>发布需求</el-button>
          <el-button class="btn-class" @click="onNew" v-else><span style="font-size: 14px">+</span>代发需求</el-button>
        </el-col>
      </el-row>
      <div class="pt-3"></div>
      <requirement-order-toolbar
                                 @onSimpleNew="onSimpleNew"
                                 @clearQueryFormData="clearQueryFormData"
                                 @onAdvancedSearch="onAdvancedSearch"/>
      <el-tabs v-model="activeName" @tab-click="handleTabClick">
        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">
          <requirement-order-search-result-list :page="page"
                                                @onSearch="onSearch"
                                                @onAdvancedSearch="onAdvancedSearch">
            <template slot="operations" slot-scope="props">
              <el-row v-if="props.item.status == 'PENDING_QUOTE'" >
                <el-button type="text" class="list-button" @click="onDetails(props.item)">详情</el-button>
                <el-divider direction="vertical"></el-divider>
                <el-button class="list-button" type="text" @click="onEdit(props.item)" v-if="canModify(props.item)">修改</el-button>
                <el-divider direction="vertical" v-if="canModify(props.item)"></el-divider>
                <el-button class="list-button" type="text" @click="onCancelled(props.item)">关闭</el-button>
              </el-row>
              <el-row v-else>
                <el-button type="text" class="list-button" @click="onDetails(props.item)">详情</el-button>
              </el-row>
            </template>
          </requirement-order-search-result-list>
        </el-tab-pane>
      </el-tabs>

    </el-card>

    <el-dialog :visible.sync="detailsDialogVisible" width="80%"  class="purchase-dialog" :close-on-click-modal="false" :append-to-body	="true">
      <requirement-order-details-page v-if="detailsDialogVisible"
                                    :slotData="slotData"
                                    @onSearchQuotes="onSearchQuotes"
                                    @onRefresh="onRefresh"
                                      @onRefreshDetails="onRefreshDetails"
                                    @onEditSave="onEditSave"
                                    :readOnly="false">

      </requirement-order-details-page>
    </el-dialog>
    <el-dialog :visible.sync="formDialogVisible" width="80%"  class="purchase-dialog" :close-on-click-modal="false">
      <requirement-order-form v-if="formDialogVisible" :formData="formData" @onSave="onSave" :isCreated="true">

      </requirement-order-form>
    </el-dialog>
    <el-dialog :visible.sync="editFormDialogVisible" width="80%"  class="purchase-dialog" :close-on-click-modal="false">
      <requirement-order-form v-if="editFormDialogVisible" :formData="formData" @onSave="onEditSave" :isCreated="false">

      </requirement-order-form>
    </el-dialog>
    <el-dialog title="关闭" :visible.sync="requirementOrderCloseVisible" width="30%" :close-on-click-modal="false">
      <requirement-order-close-dialog v-if="requirementOrderCloseVisible"
                                        @onCancel="onCloseCancel" @onConfirm="onCloseConfirm"/>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions, mapMutations} = createNamespacedHelpers('RequirementOrdersModule');

  import RequirementOrderToolbar from './toolbar/RequirementOrderToolbar';
  import RequirementOrderSearchResultList from './list/RequirementOrderSearchResultList';
  import RequirementOrderDetailsPage from './details/RequirementOrderDetailsPage';
  import RequirementOrderSimpleForm from './form/RequirementOrderSimpleForm';
  import RequirementOrderForm from './form/RequirementOrderForm';
  import RequirementOrderCloseDialog from './form/RequirementOrderCloseDialog';

  export default {
    name: 'RequirementOrderPage',
    components: {
      RequirementOrderCloseDialog,
      RequirementOrderForm,
      RequirementOrderDetailsPage,
      RequirementOrderToolbar,
      RequirementOrderSearchResultList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData',
        quoteQueryFormData: 'quoteQueryFormData',
        formData: 'formData',
        categories: 'categories'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
        searchQuotesAdvanced: 'searchQuotesAdvanced',
        clearFormData: 'clearFormData',
        clearQueryFormData: 'clearQueryFormData'
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch',
        isShowDetailPrice: 'isShowDetailPrice',
        setCategories: 'categories',
        setFormData: 'formData'
      }),
      canModify (item) {
        return !this.isTenant() || (this.isTenant() && item.publishType === 'PUBLISH_BY_OTHERS');
      },
      onSearch (page, size) {
        this.setIsAdvancedSearch(false);
        const keyword = this.keyword;
        const statuses = this.statuses;

        const url = this.apis().getRequirementOrders();
        this.search({url, keyword, statuses, page, size});

        if (this.categories <= 0) {
          this.getMinorCategories();
        }
      },
      onAdvancedSearch (page, size) {
        this.setIsAdvancedSearch(true);

        const query = this.queryFormData;
        const url = this.apis().getRequirementOrders();
        this.searchAdvanced({url, query, page, size});

        if (this.categories <= 0) {
          this.getMinorCategories();
        }
      },
      async onDetails (item) {
        const url = this.apis().getRequirementOrder(item.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.slotData = result;
        this.detailsDialogVisible = !this.detailsDialogVisible;
        this.onSearchQuotes(0, 8);
      },
      async onRefreshDetails (code) {
        const url = this.apis().getRequirementOrder(code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.slotData = result;
        this.onSearchQuotes(0, 8);
      },
      async onRefresh (code) {
        const url = this.apis().getRequirementOrder(code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.slotData = Object.assign({}, result);
        this.onAdvancedSearch();
      },
      onCancelled (item) {
        this.$confirm('是否确认关闭该需求订单', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          if (this.isTenant()) {
            this.onCloseDialog(item);
          } else {
            this._onCancelled(item);
          }
        });
      },
      onCloseDialog (item) {
        this.closeItem = Object.assign({}, item);
        this.requirementOrderCloseVisible = true;
      },
      // 平台关闭需求订单
      async onCloseConfirm () {
        const url = this.apis().platformCancelledRequirementOrder(this.closeItem.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.closeItem = {};
        this.$message.success('需求关闭成功');
        this.requirementOrderCloseVisible = false;

        this.onAdvancedSearch();
      },
      async _onCancelled (item) {
        const url = this.apis().cancelledRequirementOrder(item.code);
        const result = await this.$http.delete(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('需求关闭成功');
        this.onAdvancedSearch();
      },
      onNew (formData) {
        this.formData.belongTo = {
          id: null,
          name: ''
        }
        this.formData.details.certificates = [];
        this.formDialogVisible = !this.formDialogVisible;
      },
      async onEdit (item) {
        const url = this.apis().getRequirementOrder(item.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        result.details.effectiveDays = result.details.effectiveDays == null ? 'null' : result.details.effectiveDays.toString();
        if (!result.details.certificates) {
          this.$set(result.details, 'certificates', []);
        }
        this.setFormData(Object.assign({}, this.formData, result));

        this.editFormDialogVisible = !this.editFormDialogVisible;
      },
      onSimpleNew (formData) {
        this.fn.openSlider('急速发布需求', RequirementOrderSimpleForm, formData);
      },
      onSearchQuotes (page, size) {
        const url = this.apis().getQuotesByRequirementOrder(this.slotData.code);

        this.searchQuotesAdvanced({url, page, size});
      },
      handleData (factories, phoneNumbers) {
        var params = {};
        if (factories != null) {
          var text = '';
          for (let uid of factories) {
            text += uid;
            text += ',';
          }
          text = text.slice(0, text.length - 1);
        }
        params['factories'] = text;

        // 处理地区
        let form = Object.assign({}, this.formData);
        if (this.formData.details.productiveDistricts && this.formData.details.productiveDistricts.length > 0) {
          form.details.productiveDistricts = this.formData.details.productiveDistricts.map(item => {
            return {
              code: item[item.length - 1]
            }
          })
        } else {
          form.details.productiveDistricts = [];
        }

        return {
          params: params,
          form: form
        }
      },
      onSave (factories, phoneNumbers) {
        // 处理数据
        const { params, form } = this.handleData(factories, phoneNumbers);

        let url;
        if (this.isTenant()) {
          url = this.apis().createPublishByPlatform();
        } else {
          url = this.apis().createRequirementOrderNewByType();
        }
        this._onSave(url, params, form);
      },
      async _onSave (url, params, form) {
        const result = await this.$http.post(url, form, params);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('需求订单创建成功，订单编号： ' + result);
        this.formDialogVisible = !this.formDialogVisible;
        this.onAdvancedSearch();
      },
      onEditSave (factories, phoneNumbers) {
        // 处理数据
        const { params, form } = this.handleData(factories, phoneNumbers);

        let url;
        if (this.isTenant()) {
          url = this.apis().updateRequirementOrderByPlatform();
        } else {
          url = this.apis().updateRequirementOrderNewByType();
        }
        this._onEditSave(url, params, form);
      },
      async _onEditSave (url, params, form) {

        const result = await this.$http.put(url, form, params);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('需求订单修改成功');
        this.editFormDialogVisible = false;
        this.onAdvancedSearch();
      },
      async getMinorCategories () {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setCategories(result);
      },
      handleTabClick (tab) {
        if (tab.name !== 'ALL') {
          this.queryFormData.statuses = tab.name;
        } else {
          this.queryFormData.statuses = [];
        }

        this.onAdvancedSearch();
      },
      onCloseCancel () {
        this.requirementOrderCloseVisible = false;
      }
    },
    data () {
      return {
        slotData: '',
        isAdvancedSearch: this.$store.state.RequirementOrdersModule.isAdvancedSearch,
        detailsDialogVisible: false,
        formDialogVisible: false,
        editFormDialogVisible: false,
        requirementOrderCloseVisible: false,
        closeItem: {},
        statuses: [
          {
            code: 'ALL',
            name: '全部'
          },
          {
            code: 'PENDING_QUOTE',
            name: '报价中'
          },
          {
            code: 'COMPLETED',
            name: '已完成'
          },
          {
            code: 'CANCELLED',
            name: '已关闭'
          }
        ],
        activeName: 'ALL'
      };
    },
    watch: {
      'detailsDialogVisible': function (n, o) {
        if (!n) {
          this.isShowDetailPrice(false);
        }
      }
    },
    created () {
      this.onAdvancedSearch();
    },
    destroyed () {
      this.clearQueryFormData();
    }
  };
</script>

<style scoped>
   .info-title {
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

   .info-title_text {
    font-size: 12px;
    font-weight: bold;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

   .rowClass {
    margin-bottom: 20px;
  }

   .seal-list-title {
     border-left: 2px solid #ffd60c;
     padding-left: 10px;
   }
</style>
