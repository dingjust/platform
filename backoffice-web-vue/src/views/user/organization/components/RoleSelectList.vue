<template>
  <div class="role-select-list-container">
    <el-row type="flex" justify="end" align="middle">
      <el-button class="personnel-role-btn" @click="onConfirm">确定</el-button>
      <el-button class="personnel-role-btn1" @click="onCancel">取消</el-button>
    </el-row>
    <el-row type="flex" justify="center" align="middle">
      <el-col :span="24">
        <div class="personnel-role-info-main">
          <el-table ref="resultTable" :data="page.content" style="width: 100%" row-key="id" 
                    @row-click="rowClick" @selection-change="selectionChange" :height="autoHeight">
            <el-table-column type="selection" width="55" :reserve-selection="true" :selectable="selectable"/>
            <el-table-column label="角色名称" prop="name" />
            <el-table-column label="角色描述" prop="name" />
          </el-table>
          <div class="pt-2"></div>
          <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                        @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                        :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
          </el-pagination>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'RoleSelectList',
  props: ['originData'],
  components: {

  },
  computed: {

  },
  methods: {
    async getRoleGroupList (page, size) {
      const url = this.apis().getB2BCustomerRoleGroupList();
      const result = await this.$http.post(url, {}, {
        page: page,
        size: size
      });
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code == 0) {
        this.$message.error(result.msg);
        return;
      }
      this.page = result;
    },
    selectionChange (val) {
      this.selectData = val;
    },
    rowClick (row, column, event) {
      if (this.originData && this.originData.findIndex(item => item.id === row.id) >= 0) {
        return;
      }
      this.$refs.resultTable.toggleRowSelection(row);
    },
    // 判断行能否选择
    selectable (row, index) {
      if (this.originData && this.originData.length > 0) {
        return this.originData.findIndex(item => item.id === row.id) < 0;
      }
      return true;
    },
    onPageSizeChanged (val) {
      this.getRoleGroupList(0 ,val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged (val) {
      this.getRoleGroupList(val - 1, 10);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onConfirm () {
      this.$emit('onAppendRole', this.selectData);
    },
    onCancel () {
      this.$emit('onCancel');
    }
  },
  data () {
    return {
      page: {
        number: 0, // 当前页，从0开始
        size: 10, // 每页显示条数
        totalPages: 1, // 总页数
        totalElements: 0, // 总数目数
        content: [] // 当前页数据
      },
      selectData: ''
    }
  },
  created () {
    this.getRoleGroupList(0, 10);
  }
}
</script>

<style scoped>
  .personnel-role-info-main {
    border: 2px solid #E5E5E5;
    padding-bottom: 5px;
  }

  .personnel-role-btn {
    background-color: #ffd60c;
    color: #000;
    width: 80px;
    height: 35px;
    border-radius: 6px;
    margin-bottom: 10px;
  }

  .personnel-role-btn1 {
    background-color: #FFFFFF;
    color: #000;
    width: 80px;
    height: 35px;
    border-radius: 6px;
    margin-bottom: 10px;
  }
</style>