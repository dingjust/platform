<template>
  <div class="tree-container">
    <el-row type="flex" justify="start">
      <h6 class="organization-tips"><i class="el-icon-tickets" />部门最多可创建三级</h6>
    </el-row>
    <el-tree :data="treeData" node-key="id" default-expand-all :expand-on-click-node="false" class="tree">
      <span class="custom-tree-node" slot-scope="{ node, data }">
        <span>{{ data.name }}</span>
        <span>
          <el-button v-if="data.depth < 3 || data.depth === 0" type="text" size="mini" @click="appendDept(data)">
            <i class="el-icon-plus" style="border: 1px solid"/>
          </el-button>
          <el-button v-if="data.depth > 0" type="text" size="mini" @click="editDept(data, node)">
            <i class="el-icon-edit"/>
          </el-button>
          <el-button v-if="data.depth > 0" type="text" size="mini" @click="deleteDept(data)">
            <i class="el-icon-delete"/>
          </el-button>
        </span>
      </span>
    </el-tree>
    <el-dialog :visible.sync="deptFormVisible" class="purchase-dialog" width="40%" append-to-body :close-on-click-modal="false">
      <dept-form v-if="deptFormVisible" :formData="formData" @onConfirm="onConfirm"/>
    </el-dialog>
  </div>
</template>

<script>
  import {DeptForm} from '../index.js'

  export default {
    name: 'OrganizationTree',
    props: ['treeData'],
    components: {
      DeptForm
    },
    computed: {

    },
    methods: {  
      appendDept (row) {
        this.formData = {
          id: null,
          parentId: row.id !== 0 ? row.id : null,
          deptName: ''
        }
        this.deptFormVisible = true;
      },
      editDept (row, node) {
        this.formData = {
          id: row.id,
          parentId: node.parent.data.id !== 0 ? node.parent.data.id : null,
          deptName: row.name
        }
        this.deptFormVisible = true;
      },
      async onConfirm (form) {
        const url = this.apis().createB2BCustomerDept();
        const result = await this.$http.put(url, form, form);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success(form.id ? '编辑部门成功！' : '创建部门成功！');
        this.$emit('refreshDept');
        this.deptFormVisible = false;
      },
      deleteDept (data) {
        this.$confirm('删除此部门会将此部门的下级部门一并删除，请问是否继续', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._deleteDept(data);
        });
      },
      async _deleteDept (data) {
        const url = this.apis().deleteB2BCustomerDept(data.id);
        const result = await this.$http.delete(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('删除部门成功');
        this.$emit('refreshDept');
      }
    },
    data () {
      return {
        deptFormVisible: false,
        formData: {
          id: null,
          parentId: null,
          deptName: ''
        }
      }
    },
    created () {

    }
  }
</script>

<style scoped>
  .organization-tips {
    margin: 0px 0px 0px 15px;
    color: rgb(144, 147, 153);
  }

  /deep/ .el-button+.el-button {
    margin-left: 0px;
  }

  /deep/ .el-tree-node__content {
    padding-left: 0px !important;
  }

  .custom-tree-node {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 12px;
    padding-right: 8px;
  }

  /*!* 树形结构节点添加连线 *!*/
  .tree /deep/ .el-tree-node {
    position: relative;
    padding-left: 8px;
  }

  .tree /deep/ .el-tree-node__children {
    padding-left: 16px;
  }

  .tree /deep/ .el-tree-node :last-child:before {
    height: 38px;
  }

  .tree /deep/ .el-tree > .el-tree-node:before {
    border-left: none;
  }

  .tree-container /deep/ .el-tree > .el-tree-node:after {
    border-top: none;
  }

  .tree /deep/ .el-tree-node:before {
    content: "";
    left: -4px;
    position: absolute;
    right: auto;
    border-width: 1px;
  }

  .tree /deep/ .el-tree-node:after {
    content: "";
    left: -4px;
    position: absolute;
    right: auto;
    border-width: 1px;
  }
  /*.tree /deep/ .el-tree-node__expand-icon.is-leaf {*/
  /*  display: none;*/
  /*}*/

  .tree /deep/ .el-tree-node:before {
    border-left: 1px dashed #b8b9bb;
    bottom: 0px;
    height: 100%;
    top: -26px;
    width: 1px;
  }

  .tree /deep/ .el-tree-node:after {
    border-top: 1px dashed #b8b9bb;
    height: 20px;
    top: 12px;
    width: 24px;
  }
</style>