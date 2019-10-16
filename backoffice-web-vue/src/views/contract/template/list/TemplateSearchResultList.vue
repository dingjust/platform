<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" v-if="isHeightComputed" :height="autoHeight">
      <!--<el-table-column label="模板编号" width="300" prop="code" fixed></el-table-column>-->
      <el-table-column label="模板名称"  prop="title" ></el-table-column>
      <el-table-column label="模板类型" prop="state" :column-key="'type'">
        <template slot-scope="scope">
          <!-- <el-tag disable-transitions></el-tag> -->
          {{getEnum('TemplateType', scope.row.type)}}
        </template>
      </el-table-column>
      <el-table-column label="状态" prop="available" >
        <template slot-scope="scope">
          <span>{{ scope.row.available?'可用':'不可用'}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" prop="createdTs" >
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <!--<el-table-column label="用印章审批角色" prop="role"  fixed></el-table-column>-->
      <el-table-column label="操作" >
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row.code)">查看</el-button>
          <el-divider direction="vertical"></el-divider>
          <el-button type="text" icon="el-icon-delete" @click="onDelete(scope.row.code)">删除</el-button>
          <!--<el-divider direction="vertical"></el-divider>-->
          <!--<el-button type="text" icon="el-icon-edit" @click="">启用</el-button>-->
          <!--<el-divider direction="vertical"></el-divider>-->
          <!--<el-button type="text" icon="el-icon-delete" @click="">禁用</el-button>-->
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
  import TemplateForm from "../components/TemplateForm";

  export default {
    name: "TemplateSearchResultList",
    props: ["page"],
    methods: {
      onPageSizeChanged(val) {
        this._reset();

        if (this.isAdvancedSearch) {
          this.$emit("onAdvancedSearch", val);
          return;
        }

        this.$emit("onSearch", 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.isAdvancedSearch) {
          this.$emit("onAdvancedSearch", val - 1);
          return;
        }

        this.$emit("onSearch", val - 1);
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onSelect(code) {
        if (code == this.selectedCode) {
          this.selectedCode = "";
        } else {
          this.selectedCode = code;
        }
      },
      onDetails(code) {
        // console.log(row);
        this.$emit('onDetails', code);
      },
      async onDelete(code){
        const url = this.apis().deleteTemplate(code);
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
        selectedCode: "0",
        mockData: []
      };
    }
  };
</script>
