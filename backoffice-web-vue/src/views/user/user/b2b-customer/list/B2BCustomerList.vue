<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="姓名" prop="name" min-width="22%">
        <template slot-scope="scope">
          <span>{{scope.row.name != null ? scope.row.name : ''}}</span>
          <el-tag v-if="scope.row.manager" type="success">{{'经理'}}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="账号" prop="uid" min-width="15%"></el-table-column>
      <el-table-column label="部门" prop="b2bDept" min-width="16%">
        <template slot-scope="scope">
          <span>{{scope.row.b2bDept != null ? scope.row.b2bDept.name : ''}}</span>
        </template>
      </el-table-column>
      <el-table-column label="角色" prop="b2bRoleGroup" min-width="16%">
        <template slot-scope="scope">
          <span>{{scope.row.b2bRoleGroup != null ? scope.row.b2bRoleGroup.name : ''}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" prop="loginDisabled" min-width="6%">
        <template slot-scope="scope">
          <span>{{scope.row.loginDisabled ? '禁用' : '启用'}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="24%">
        <template slot-scope="scope" v-if="!scope.row.root">
          <el-button @click="editInfo(scope.row, scope)" size="mini">
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
        this.options.push({
          value: 'workHandover',
          label: '工作交接'
        });
        this.options.push({
          value: 'deleteUser',
          label: '删除账号'
        });
        this.options.push({
          value: 'setDepartmentHead',
          label: '设为部门负责人'
        });
        this.options.push({
          value: 'removeDepartmentHead',
          label: '移除部门负责人'
        });
        this.options.push({
          value: 'enableUser',
          label: '启用账号'
        });
        this.options.push({
          value: 'forbiddenUser',
          label: '禁用账号'
        });
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
  /*/deep/ .el-tabs_item {*/
  /*  font-size: 8px !important;*/
  /*}*/
  /deep/ .el-tag--small {
    height: 24px;
    padding: 0 8px;
    line-height: 22px;
    display: inline-block;
    transform: scale(0.8);
  }
  /deep/ .el-tag.el-tag--success {
    background-color: #fff;
    border-color: #67c23a;
    color: #67c23a;
  }
</style>
