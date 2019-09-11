<template>
  <div class="animated fadeIn" >
    <el-table ref="resultTable" stripe :data="page.content" v-if="isHeightComputed" :height="autoHeight">
      <el-table-column  label="印章" fixed>
        <template slot-scope="scope">
          <img width="100px" height="100px" :src="scope.row.media.url">
        </template>
      </el-table-column>
      <el-table-column label="印章名称" prop="name" width="220" fixed></el-table-column>
      <el-table-column label="印章编号" prop="code" fixed></el-table-column>
      <el-table-column label="状态" prop="state" fixed>
        <template slot-scope="scope">
          <span>{{ scope.row.enabled?'可用':'不可用'}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" prop="createdTs">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <!--<el-table-column label="用印章审批角色" prop="role"  fixed></el-table-column>-->
      <el-table-column label="操作">
        <template  slot-scope="props">
          <!--<el-button type="text" icon="el-icon-edit" @click="on1">编辑</el-button>-->
          <el-button type="text" icon="el-icon-delete" @click="onDelete(props.row.code)">删除</el-button>
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
      async onDelete(code){
        const url = this.apis().delSeal(code);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        if(result){
          this.$message.success('删除成功');
        }else{
          this.$message.error('删除失败');
        }
        this.$emit("onSearch",0);
      }
    },
    data() {
      return {
        // tableData: [{
        //   title: 'XX1-印章',
        //   code: '3565512232',
        //   role: '管理员',
        //   creationtime:new Date(),
        //   state:'NORMAL',
        //   media:{
        //     url:'https://47.106.112.137/resource/h30/h99/8805604130846.png'
        //   }
        // }, {
        //   title: 'XX2-印章',
        //   code: '25571223553',
        //   role: '管理员',
        //   creationtime:new Date(),
        //   state:'NORMAL',
        //   media:{
        //     url:'https://47.106.112.137/resource/h30/h99/8805604130846.png'
        //   }
        // },]
      }
    }
  }
</script>

<style>
  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }
</style>
