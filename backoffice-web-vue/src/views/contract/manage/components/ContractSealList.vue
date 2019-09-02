<template>
  <div class="animated fadeIn">
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
          <el-button type="text" icon="el-icon-add" @click="onSelected(props.row)">使用</el-button>
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
    name: 'ContractSealList',
    props: ["page"],
    methods: {
      async onPageSizeChanged(val) {
        this._reset();

        if(keyword == null){
          keyword = '';
        }
        const url = this.apis().getSealsList();
        console.log(url)
        const result = await this.$http.post(url,{
          keyword: keyword
        }, {
          page: val,
          size: 10
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.sealPage = result;

      },
      async onCurrentPageChanged(val) {
        if(keyword == null){
          keyword = '';
        }
        const url = this.apis().getSealsList();
        console.log(url)
        const result = await this.$http.post(url,{
          keyword: keyword
        }, {
          page: val -1,
          size: 10
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.sealPage = result;

      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onSelected(item) {
        if (item.code == this.selectedItem.code) {
          //空选择
          this.selectedItem = {};
        } else {
          this.selectedItem = item;
        }
        console.log(this.selectedItem);
        this.dialogSealVisible=true
        this.$emit('onSealSelectChange',this.selectedItem );
      },
    },
    data() {
      return {
        selectedItem:{},
      }
    }
  }
</script>
