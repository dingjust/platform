<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="tableData" v-if="isHeightComputed" :height="autoHeight">
      <el-table-column width="100" label="印章" fixed>
        <template slot-scope="props">
          <img width="50px" height="50px" src="tableData.media.url">
        </template>
      </el-table-column>
      <el-table-column label="印章名称" prop="title" width="220" fixed></el-table-column>
      <el-table-column label="印章编号" prop="code" fixed></el-table-column>
      <el-table-column label="状态" prop="state" fixed>
        <template slot-scope="scope">
          <span>{{getEnum('contractStates', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" prop="createdTs">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="用印章审批角色" prop="role"  fixed></el-table-column>
      <el-table-column label="操作">
        <template  slot-scope="props">
          <el-button type="text" icon="el-icon-edit" @click="on1">编辑</el-button>
          <el-button type="text" icon="el-icon-delete" @click="on2">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged"
                   @current-change="onCurrentPageChanged"
                   :current-page="page.number + 1"
                   :page-size="page.size"
                   :page-count="page.totalPages"
                   :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>

  export default {
    name: 'SealSearchResultList',
    props: ["page"],
    methods: {
      onPageSizeChanged(val) {
        this._reset();

        if (this.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val - 1);
          return;
        }

        this.$emit('onSearch', val - 1);
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      on1(){

      },
      on2(){

      }
    },
    data() {
      return {
        tableData: [{
          title: 'XX1-印章',
          code: '3565512232',
          role: '管理员',
          creationtime:new Date(),
          state:'NORMAL',
          media:{
            url:'http://attach.bbs.wps.cn/attachments/forum/201307/04/2227437j184dwnaabrwl71.jpg'
          }
        }, {
          title: 'XX2-印章',
          code: '25571223553',
          role: '管理员',
          creationtime:new Date(),
          state:'NORMAL',
          media:{
            url:'http://attach.bbs.wps.cn/attachments/forum/201307/04/2227437j184dwnaabrwl71.jpg'
          }
        },]
      }
    }
  }
</script>
