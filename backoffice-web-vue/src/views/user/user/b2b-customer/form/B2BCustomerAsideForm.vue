<template>
  <el-tabs v-model="activeName" @tab-click="handleClick">
    <el-tab-pane label="组织架构" name="dept">
      <h6><i class="el-icon-document"/>&nbsp;部门最多创建三级</h6>
      <b2-b-customer-dept-tree :slotData='deptList' @appendDept="appendDept" @removeDept="removeDept" @searchInAside="searchInAside"/>
    </el-tab-pane>
    <el-tab-pane label="角色管理" name="role">
      <b2-b-customer-role-tree :slotData="roleGroupList" @editRole="editRole" @removeRole="removeRole"
                               @createRole="createRole" @saveRoleName="saveRoleName" @searchInAside="searchInAside"/>
    </el-tab-pane>
  </el-tabs>
</template>

<script>
    import {createNamespacedHelpers} from 'vuex';

    const {mapGetters} = createNamespacedHelpers('B2BCustomersModule');
    import B2BCustomerDeptTree from '../tree/B2BCustomerDeptTree';
    import B2BCustomerRoleTree from '../tree/B2BCustomerRoleTree';

    export default {
      name: 'B2BCustomerAsideForm',
      components: {
        B2BCustomerRoleTree,
        B2BCustomerDeptTree
      },
      computed: {
        ...mapGetters({
          deptList: 'deptList',
          roleGroupList: 'roleGroupList'
        })
      },
      data () {
        return {
          type: 'dept',
          activeName: 'dept',
          showInput: false,
          label: '',
          modifyLabel: '',
          showIconV: true,
          isActive: false
        };
      },
      methods: {
        searchInAside (deptN, roleN) {
          this.$emit('searchInAside', deptN, roleN);
        },
        handleClick (tab, event) {
          if (tab.name === 'dept') {
            this.type = 'dept';
          } else {
            this.type = 'role';
          }
        },
        appendDept (formData) {
          this.$emit('appendDept', formData);
        },
        removeDept (id) {
          this.$emit('removeDept', id);
        },
        removeRole (id) {
          this.$emit('removeRole', id);
        },
        editRole (data) {
          this.$emit('editRole', data);
        },
        createRole () {
          this.$emit('createRole');
        },
        saveRoleName (data) {
          this.$emit('saveRoleName', data);
        }
      }
    }
</script>

<style scoped>
  .custom-tree-node {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding-right: 8px;
  }
  /deep/ .el-input__inner {
    width: 100px;
    height: 20px;
    line-height: 32px;
    border-radius: 2px;
    padding: 0px;
  }

  .active_tree_node {
    color: #409EFF;
    text-decoration: underline
  }
  .noactive_tree_node {
    color: black;
  }
</style>
