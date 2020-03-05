<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-tabs v-model="activeName" @tab-click="handleClick" style="background-color: white">
        <template v-for="item in statuses">
          <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
          <span slot="label">
             <el-badge :value="item.not_read_count" :max="99" :hidden="item.not_read_count <= 0" class="item">
               {{item.name}}
             </el-badge>
          </span>
            <message-list :page="page" @onSearch="onSearch" @refreshData="refreshData"></message-list>
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  import MessageList from './list/MessageList';

  const {mapGetters, mapMutations, mapActions} = createNamespacedHelpers('MessageModule');

  export default {
    name: 'MessagePage',
    components: {
      MessageList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        queryFormData: 'queryFormData'
      })
    },
    methods: {
      ...mapMutations({
      }),
      ...mapActions({
        search: 'search'
      }),
      handleClick (val) {
        console.log(this.queryFormData);
        this.queryFormData.groupCode = val.name;
        this.onSearch();
      },
      onSearch (page, size) {
        // this.setIsAdvancedSearch(true);
        var uid = this.$store.getters.currentUser.uid;
        const url = this.apis().getMsgList(uid);
        this.search({url, page, size});
      },
      async onDetails (row) {
        this.getProofing(row.code);
        this.detailsDialogVisible = !this.detailsDialogVisible;
      },
      async getCountNotReadMsg () {
        // 统计未读消息
        var uid = this.$store.getters.currentUser.uid;
        const url = this.apis().countUnreadMsg(uid);
        const result = await this.$http.post(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.statuses[0].not_read_count = result['order'];
        this.statuses[1].not_read_count = result['system'];
        this.statuses[2].not_read_count = result['finance'];
      },
      refreshData () {
        this.onSearch();
        this.getCountNotReadMsg();
      },
    },
    data () {
      return {
        detailsDialogVisible: false,
        slotData: '',
        activeName: '1',
        statuses: [
          {
            code: '1',
            name: '订单消息',
            not_read_count: 0
          },
          {
            code: '2',
            name: '财务消息',
            not_read_count: 0
          },
          {
            code: '3',
            name: '系统消息',
            not_read_count: 0
          }
        ]
      }
    },
    created () {
      this.onSearch();
      this.getCountNotReadMsg();
    }
  }
</script>

<style scoped>
  /deep/ .el-badge__content.is-fixed{
    top:18px;
    right:0px;
    line-height: 16px;
  }
</style>
