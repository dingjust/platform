<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="姓名" prop="name" />
      <el-table-column label="账号" prop="uid"/>
      <el-table-column label="部门" prop="b2bDept.name" />
      <el-table-column label="角色" prop="b2bRoleGroup.name" />
      <!-- <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column> -->
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{scope.row.loginDisabled ? '禁用' : '启用'}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="180px">
        <template slot-scope="scope" v-if="!scope.row.root">
          <el-button size="mini" @click="onEdit(scope.row)">编辑信息</el-button>
          <el-dropdown @command="handleCommand($event, scope.row)">
            <el-button size="mini">
              更多<i class="el-icon-arrow-down el-icon--right"></i>
            </el-button>
            <el-dropdown-menu slot="dropdown">
              <!-- <el-dropdown-item command="SET_DEPT_CHARGE">设为部门负责人</el-dropdown-item> -->
              <el-dropdown-item v-if="!scope.row.loginDisabled" command="FORBIDDEN_ACCOUNT">禁用账号</el-dropdown-item>
              <el-dropdown-item v-if="scope.row.loginDisabled" command="ENABLE_ACCOUNT">启用账号</el-dropdown-item>
              <!-- <el-dropdown-item command="WORK_HANDOVER">工作交接</el-dropdown-item> -->
              <el-dropdown-item command="DELETE_PERSONNEL">删除员工</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
          <!-- <el-button type="text" @click="onDetail(scope.row)">查看</el-button>
          <el-button type="text" v-if="!scope.row.loginDisabled" @click="onForbidden(scope.row)">禁用</el-button>
          <el-button type="text" v-else @click="onEnable(scope.row)">启用</el-button>
          <el-button type="text" @click="onDelete(scope.row)">删除</el-button> -->
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
    name: 'OrganizationList',
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
      handleCommand (command, row) {
        switch (command) {
          case 'SET_DEPT_CHARGE':
            this.setDeptCharge(row);
            break;
          case 'FORBIDDEN_ACCOUNT':
            this.$confirm('禁用后员工将无法正常使用账号 ， 请问是否继续?', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }).then(() => {
              this.changeLoginDisabled(row);
            });
            break;
          case 'ENABLE_ACCOUNT':
            this.$confirm('启用账号后账号将恢复正常使用 ， 请问是否继续?', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }).then(() => {
              this.changeLoginDisabled(row);
            });
            break;
          case 'WORK_HANDOVER': 
            this.workHandover(row);
            break;
          case 'DELETE_PERSONNEL':
            this.deletePersonnel(row);
            break;
        }
      },
      onEdit (row) {
        this.$router.push({
          name:'员工详情',
          params:{
            data: Object.assign({}, row)
          }
        });
      },
      setDeptCharge (row) {

      },
      async changeLoginDisabled (row) {
        const currentUser = this.$store.getters.currentUser;
        const url = this.apis().changeLoginDisabled(currentUser.uid);
        const result = await this.$http.put(url, row);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('更改员工账号状态成功');
        this.$emit('onAdvancedSearch', this.page.number);
      },
      workHandover (row) {

      },
      deletePersonnel (row) {

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