<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="姓名" prop="name" width="140"></el-table-column>
      <el-table-column label="账号" prop="uid" width="140"></el-table-column>
      <el-table-column label="部门" prop="b2bDept" width="140">
        <template slot-scope="scope">
          <span>{{scope.row.b2bDept != null ? scope.row.b2bDept.name : ''}}</span>
        </template>
      </el-table-column>
      <el-table-column label="角色" prop="b2bRoleGroup" width="140">
        <template slot-scope="scope">
          <span>{{scope.row.b2bRoleGroup != null ? scope.row.b2bRoleGroup.name : ''}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" prop="loginDisabled" width="80">
        <template slot-scope="scope">
          <span>{{scope.row.loginDisabled ? '禁用' : '启用'}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope" v-if="scope.$index != 0">
          <el-button @click="editInfo(scope.row, scope)" size="mini" v-if="hasper(permission.companyB2bCustomerModify)">
            编辑信息
          </el-button>
          <el-select v-model="operation" placeholder="更多" size="mini" style="width: 40%"
                     @change="selectionOperation" @visible-change="getData($event, scope.row)">
            <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
          </el-select>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pagination-right"
                   layout="total, sizes, prev, pager, next, jumper"
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
  import {hasPermission} from '@/auth/auth';
  export default {
    name: 'B2BCustomerList',
    props: ['page'],
    computed: {

    },
    methods: {
      hasper (permission) {
        return hasPermission(permission);
      },
      onPageSizeChanged (val) {
        this._reset();

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged (val) {
        this.$emit('onSearch', val - 1);
      },
      _reset () {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      editInfo (row, scope) {
        this.$emit('editInfo', row);
      },
      selectionOperation (current) {
        this.operation = '';
        this.$emit(current, this.slotData);
        this.slotData = {};
      },
      getData (flag, row) {
        if (!flag) {
          this.options = [];
          return;
        }
        if (hasPermission(this.permission.companyB2bCustomerHandOff)) {
          this.options.push({
            value: 'workHandover',
            label: '工作交接'
          });
        }
        if (hasPermission(this.permission.companyB2bCustomerRemove)) {
          this.options.push({
            value: 'deleteUser',
            label: '删除账号'
          });
        }
        if (row.b2bDept != null && hasPermission(this.permission.companyB2bDeptSetManager)) {
          this.options.push({
            value: 'setDepartmentHead',
            label: '设为部门负责人'
          });
        }
        if (row.loginDisabled && hasPermission(this.permission.companyB2bCustomerEnableState)) {
          this.options.push({
            value: 'enableUser',
            label: '启用账号'
          });
        }
        if (!row.loginDisabled && hasPermission(this.permission.companyB2bCustomerEnableState)) {
          this.options.push({
            value: 'forbiddenUser',
            label: '禁用账号'
          });
        }
        this.slotData = row;
      }
    },
    data () {
      return {
        options: [],
        slotData: '',
        operation: ''
      }
    }
  }
</script>
<style scoped>
  /*.el-dropdown-link {*/
  /*  cursor: pointer;*/
  /*  color: #409EFF;*/
  /*}*/
  /*.el-icon-arrow-down {*/
  /*  font-size: 12px;*/
  /*}*/
</style>
