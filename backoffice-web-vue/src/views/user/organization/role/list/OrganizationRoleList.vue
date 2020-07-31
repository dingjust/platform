<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="角色名称" prop="name" />
      <el-table-column label="角色描述" prop="remark"/>
      <el-table-column label="创建人" prop="creator.name"/>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{scope.row.enabled ? '启用' : '禁用'}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="180px">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">查看</el-button>
          <el-button type="text" @click="onEdit(scope.row)">编辑</el-button>
          <el-button type="text" @click="onChangeState(scope.row)">{{roleState(scope.row)}}</el-button>
          <el-button type="text" @click="onDelete(scope.row)">删除</el-button>
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
    name: 'OrganizationRoleList',
    props: ['page'],
    components: {

    },
    computed: {
    },
    methods: {
      onPageSizeChanged (val) {
        this.$emit('onAdvancedSearch', 0, val);

        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      onCurrentPageChanged (val) {
        this.$emit('onAdvancedSearch', val - 1);

        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      roleState (row) {
        if (row.enabled == null || row.enabled) {
          return '禁用';
        }
        return '启用';
      },
      onDetail (row) {
        this.$router.push('/account/organizationRole/' + row.id + '/edit');
      },
      onEdit (row) {
        this.$router.push('/account/organizationRole/' + row.id + '/edit');
      },
      async onChangeState (row) {
        const url = this.apis().changeRoleState(row.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('修改角色状态成功！');
        this.$emit('onAdvancedSearch', this.page.number);
      },
      onDelete (row) {
        this.$confirm('是否删除此角色?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onDelete(row);
        });
      },
      async _onDelete (row) {
        const url = this.apis().removeB2BCustomerRoleGroup(row.id);
        const result = await this.$http.delete(url);
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('删除角色成功!');
        let page = this.page.number;
        if (this.page.content.length == 1) {
          page = this.page.number - 1;
        }
        this.$emit('onAdvancedSearch', page);
      }
    },
    data () {
      return {

      }
    },
    created () {

    },
    destroyed () {

    }    
  }
</script>

<style scoped>
</style>