<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="姓名" prop="name"></el-table-column>
      <el-table-column label="账号" prop="uid"></el-table-column>
      <el-table-column label="部门" prop=""></el-table-column>
      <el-table-column label="角色" prop=""></el-table-column>
      <el-table-column label="状态" prop=""></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-select v-model="scope.row.value" placeholder="请选择" size="mini"
                     @change="selectionOperation" @visible-change="getData(scope.row)">
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
    computed: {},
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
      onDetails (row) {
        this.$emit('onDetails', row);
      },
      selectionOperation (current) {
        console.log(current);
        if (current === '1') {
          this.$emit('editInfo', this.slotData);
        }
        if (current === '2') {
          this.$emit('setDepartmentHead', this.slotData);
        }
        if (current === '3') {
          this.$emit('workHandover', this.slotData);
        }
        if (current === '4') {
          this.$emit('forbiddenUser', this.slotData);
        }
        if (current === '5') {
          this.$emit('deleteUser', this.slotData);
        }
      },
      getData (row) {
        this.slotData = row;
      }
    },
    data () {
      return {
        options: [{
          value: '1',
          label: '编辑信息'
        }, {
          value: '2',
          label: '设为部门负责人'
        }, {
          value: '3',
          label: '工作交接'
        }, {
          value: '4',
          label: '禁用账号'
        }, {
          value: '5',
          label: '删除账号'
        }],
        slotData: ''
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
