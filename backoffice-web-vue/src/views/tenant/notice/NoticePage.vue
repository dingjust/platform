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
        <div class="batch-opera-btn">
          <el-button type="text" @click="batchCancelPublish">批量取消发布</el-button>
          <el-button type="text" @click="batchPublish">批量发布</el-button>
        </div>
        <el-tabs v-model="activeName" @tab-click="handleTabClick">
          <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">
            <notice-list ref="list" :page="page" @onAdvancedSearch="onAdvancedSearch" :isSelection="true" :code="status.code"/>
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
      this.queryFormData.type = tab.name
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
    async _batchCancelPublish () {
      let arr = []
      this.$refs.list.forEach(item => {
        arr = arr.concat(item.multipleSelection.map(val => val.id))
      })
      
      const url = this.apis().batchPublishNotice()
      const result = await this.$http.get(url, {
        ids: arr.toString(),
        state: 'DRAFT'
      })

      if (result.code === 1) {
        this.$message.success('操作成功！')
        this.onAdvancedSearch()

        this.$refs.list.forEach(item => {
          item.resetSelection()
        })
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
    async _batchPublish () {
      let arr = []
      this.$refs.list.forEach(item => {

        arr = arr.concat(item.multipleSelection.map(val => val.id))
      })

      const url = this.apis().batchPublishNotice()
      const result = await this.$http.get(url, {
        ids: arr.toString(),
        state: 'PUBLISHED'
      })

      if (result.code === 1) {
        this.$message.success('操作成功！')
        this.onAdvancedSearch()

        this.$refs.list.forEach(item => {
          item.resetSelection()
        })
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
      activeName: 'NORMAL',
      statuses: [
        {
          code: 'NORMAL',
          name: '普通公告'
        }, {
          code: 'SYSTEM',
          name: '系统公告'
        }, {
          code : 'SYSTEM_ALTERNATE',
          name: '预设公告'
        }, {
          code: '',
          name: '全部'
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