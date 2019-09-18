<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="cooperatorDetailsDialogVisible" width="80%" class="purchase-dialog" append-to-body>
      <cooperator-details-page :itemData="itemData" @onSearch="onSearch" @onDetails="onDetails" @onDelete="onDelete" />
    </el-dialog>
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col>
          <div class="cooperator-list-title">
            <h6>合作商列表</h6>
          </div>
        </el-col>
        <el-col :span="2">
          <div>
               <el-button type="primary" class="toolbar-search_input" @click="onJumpTo">添加合作商</el-button>
          </div>
        </el-col>
      </el-row>
      <cooperator-toolbar @onSearch="onSearch" @onDetail="onDetails"/>
      <el-row>
        <!--<el-col :span="1">-->
        <!--<div>-->
        <!--<h6>类型：</h6>-->
        <!--</div>-->
        <!--</el-col>-->
        <el-tabs v-model="activeStatus" @tab-click="handleClick">
          <template v-for="(item, index) in statues">
            <el-tab-pane :name="item.code">
            <span slot="label">
              <tab-label-bubble :label="item.name" :num="0" />
            </span>
              <cooperator-search-result-list :page="page" @onDetails="onDetails" @onDelete="onDelete" @onSearch="onSearch"/>
            </el-tab-pane>
          </template>
        </el-tabs>
      </el-row>

    </el-card>
  </div>

</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  const {mapGetters, mapActions} = createNamespacedHelpers('CooperatorModule');
  import CooperatorToolbar from '@/views/miscs/cooperator/toolbar/CooperatorToolbar';
  import CooperatorSearchResultList from '@/views/miscs/cooperator/list/CooperatorSearchResultList';
  import TabLabelBubble from '@/components/custom/TabLabelBubble';
  import CooperatorDetailsPage from '@/views/miscs/cooperator/details/CooperatorDetailsPage';

  export default {
    name: 'CooperatorPage',
    props: [],
    components: {CooperatorDetailsPage, CooperatorToolbar, CooperatorSearchResultList, TabLabelBubble},
    computed: {
      ...mapGetters({
        page: 'page',
        queryFormData: 'queryFormData'
      })
    },
    methods: {
      ...mapActions({
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch (page, size) {
        const queryFormData = this.queryFormData;

        const url = this.apis().getCooperators();
        this.searchAdvanced({url, queryFormData, page, size});
      },
      async onDetails (item) {
        const url = this.apis().getCooperator(item.id);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.itemData = result;

        this.cooperatorDetailsDialogVisible = true;
      },
      async onDelete (item) {
        const url = this.apis().deleteCooperator(item.id);
        var result = this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.onSearch();
      },
      handleClick (tab, event) {
        // console.log(tab.name);
        if (tab.name === 'ALL') {
          this.queryFormData.type = null;
        } else {
          this.queryFormData.type = [tab.name];
        }
        this.onSearch();
      },
      onJumpTo () {
        this.$router.push('/miscs/cooperator/cooperatorCreate');
      }
    },
    data () {
      return {
        itemData:{},
        cooperatorDetailsDialogVisible: false,
        activeStatus: 'ALL',
        statues: [{
          code: 'ALL',
          name: '全部'
        }]
      };
    },
    created () {
      this.$store.state.EnumsModule.CooperatorType.forEach(element => {
        this.statues.push(element);
      });
      // Bus.$on('my-event', args => {
      //   this.dialogDetailVisible = !this.dialogDetailVisible;
      // }),

      this.onSearch();
    }
  };
</script>

<style>

</style>
