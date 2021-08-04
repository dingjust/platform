<!--
* @Description: 公告列表
* @Date 2021/08/03 09:22
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>公告</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <notice-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" />
      <div>
        <div class="batch-opera-btn" v-if="activeName === 'PUBLISHED' || activeName === 'DRAFT'">
          <el-button v-if="isSelect === false" @click="isSelect = true">批量操作</el-button>
          <template v-else>
            <el-button type="text" @click="isSelect = false">取消</el-button>
            <el-button v-if="activeName === 'PUBLISHED'" type="text" @click="batchCancelPublish">批量取消发布</el-button>
            <el-button v-if="activeName === 'DRAFT'" type="text" @click="batchPublish">批量发布</el-button>
          </template>
        </div>
        <el-tabs v-model="activeName" @tab-click="handleTabClick">
          <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">
            <notice-list ref="list" :page="page" @onAdvancedSearch="onAdvancedSearch" :isSelection="isSelection" :code="status.code"/>
          </el-tab-pane>
        </el-tabs>
      </div>
    </el-card>
  </div>
</template>

<script>
import {
  createNamespacedHelpers
} from 'vuex';
const {
  mapGetters,
  mapActions
} = createNamespacedHelpers(
  'NoticeModule'
);

import NoticeList from './list/NoticeList.vue';
import NoticeToolbar from './toolbar/NoticeToolbar.vue';

export default {
  name: 'NoticePage',
  components: { NoticeList, NoticeToolbar },
  computed: {
    ...mapGetters({
      page: 'page',
      queryFormData: 'queryFormData'
    }),
    isSelection () {
      return this.isSelect && (this.activeName === 'PUBLISHED' || this.activeName === 'DRAFT')
    }
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch (page, size) {
      const query = this.queryFormData;

      const url = this.apis().searchNotice();
      this.searchAdvanced({url, query, page, size});
    },
    handleTabClick(tab) {
      this.queryFormData.state = tab.name
      this.onAdvancedSearch();
    },
    batchCancelPublish () {
      this.$confirm('是否执行批量取消发布?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._batchCancelPublish()
      });
    },
    async batchCancelPublish () {
      const refList = this.$refs.list.find(item => item.code === this.activeName);
      const ids = refList.multipleSelection.map(item => item.id)

      const url = this.apis().batchPublishNotice()
      const result = await this.$http.get(url, {
        ids: ids.toString(),
        state: 'DRAFT'
      })

      if (result.code === 1) {
        this.$message.success('操作成功！')
        this.onAdvancedSearch()
      } else if (result.code === 0) {
        this.$message.error(result.msg)
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message)
      } else {
        this.$message.error('操作失败')
      }
    },
    batchPublish () {
      this.$confirm('是否执行批量发布?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._batchPublish()
      });
    },
    async batchPublish () {
      const refList = this.$refs.list.find(item => item.code === this.activeName);
      const ids = refList.multipleSelection.map(item => item.id)

      const url = this.apis().batchPublishNotice()
      const result = await this.$http.get(url, {
        ids: ids.toString(),
        state: 'PUBLISHED'
      })

      if (result.code === 1) {
        this.$message.success('操作成功！')
        this.onAdvancedSearch()
      } else if (result.code === 0) {
        this.$message.error(result.msg)
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message)
      } else {
        this.$message.error('操作失败')
      }
    }
  },
  data () {
    return {
      isSelect: false,
      activeName: '',
      statuses: [
        {
          code: '',
          name: '全部'
        }, {
          code: 'PUBLISHED',
          name: '已发布'
        }, {
          code : 'DRAFT',
          name: '未发布'
        }
      ]
    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>
  .batch-opera-btn {
    position: absolute;
    right: 21px;
    z-index: 999;
  }
</style>