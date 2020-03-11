<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="姓名" prop="name"></el-table-column>
      <el-table-column label="账号" prop="uid"></el-table-column>
      <el-table-column label="部门" prop="b2bDept">
        <template slot-scope="scope">
          <span>{{scope.row.b2bDept != null ? scope.row.b2bDept.name : ''}}</span>
        </template>
      </el-table-column>
      <el-table-column label="角色" prop="b2bRoleGroup">
        <template slot-scope="scope">
          <span>{{scope.row.b2bRoleGroup != null ? scope.row.b2bRoleGroup.name : ''}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" prop="loginDisabled">
        <template slot-scope="scope">
          <span>{{scope.row.loginDisabled ? '禁用' : '启用'}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-select v-model="operation" placeholder="请选择" size="mini"
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
      selectionOperation (current) {
        console.log(current);
        this.operation = '';
        this.$emit(current, this.slotData);
        this.slotData = {};
      },
      getData (flag, row) {
        if (!flag) {
          this.options = [];
          return;
        }
        // this.options = Object.assign([], this.options1);
        if (hasPermission(this.permission.companyB2bCustomerModify)) {
          this.options.push({
            value: 'editInfo',
            label: '编辑员工信息'
          });
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
            label: '删除员工'
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
        // options1: [{
        //   value: 'editInfo',
        //   label: '编辑信息'
        // }
        // // , {
        // //   value: 'workHandover',
        // //   label: '工作交接'
        // // }, {
        // //   value: 'deleteUser',
        // //   label: '删除账号'
        // // }
        // ],
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
