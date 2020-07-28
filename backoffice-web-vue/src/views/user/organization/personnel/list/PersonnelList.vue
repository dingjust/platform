<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="员工姓名" prop="name" />
      <el-table-column label="员工账号" prop="uid" />
      <el-table-column label="所属部门" prop="b2bDept.name" />
      <el-table-column label="员工角色" prop="b2bRoleGroup.name" />
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{scope.row.loginDisabled ? '禁用' : '启用'}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope" v-if="!scope.row.root">
          <el-button type="text" @click="onDetail(scope.row)">查看</el-button>
          <el-button type="text" v-if="!scope.row.loginDisabled" @click="onForbidden(scope.row)">禁用</el-button>
          <el-button type="text" v-else @click="onEnable(scope.row)">启用</el-button>
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
    name: 'PersonnelList',
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
      onDetail (row) {
        this.$emit('onDetail', row);
      },
      onForbidden (row) {
        this.$emit('onForbidden', row);
      },
      onEnable (row) {
        this.$emit('onEnable', row);
      },
      onDelete (row) {
        this.$emit('onDelete', row)
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