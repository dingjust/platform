<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="方案名称" prop="name"></el-table-column>
      <el-table-column label="节点数" prop="payPlanType">
        <template slot-scope="scope">
          <span>{{scope.row.productionProgresses.length}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" prop="creationtime">
        <template slot-scope="scope">
          <span> {{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{scope.row.eable ? '启用' : '禁用'}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="100">
        <template slot-scope="scope">
          <el-row>
<!--            <el-button type="text" @click="onDetail(scope.row)" class="cooperator-list-button">查看</el-button>-->
<!--              <el-divider direction="vertical"></el-divider>-->
              <el-button type="text" @click="onEdit(scope.row)" class="cooperator-list-button">编辑</el-button>
              <el-divider direction="vertical"></el-divider>
              <el-button type="text" @click="onEnable(scope.row)" class="cooperator-list-button">
                {{scope.row.eable ? '禁用' : '启用'}}
              </el-button>
              <el-divider direction="vertical"></el-divider>
              <el-button type="text" @click="onDelete(scope.row)" class="cooperator-list-button">删除</el-button>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                   :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
  export default {
    name: 'ProgressPlanList',
    props: ['page'],
    methods: {
      onPageSizeChanged (val) {
        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged (val) {
        this.$emit('onSearch', val - 1);
      },
      // onDetail (row) {
      //   this.$emit('onDetail', row);
      // },
      async onEdit (row) {
        const url = this.apis().getProgressPlanDetail(row.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$router.push({
          name: '编辑节点',
          params: {
            formData: result.data
          }
        });
      },
      async onEnable (row) {
        const url = row.eable ? this.apis().disableProgressPlan(row.id) : this.apis().enableProgressPlan(row.id);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success(row.eable ? '禁用节点方案成功' : '启用节点方案成功');
        this.$emit('onSearch', this.page.number, this.page.size);
      },
      async onDelete (row) {
        const url = this.apis().deleteProgressPlan(row.id);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('删除节点方案成功');
        this.$emit('onSearch', this.page.number, this.page.size);
      }
    }
  }
</script>

<style scoped>

</style>
