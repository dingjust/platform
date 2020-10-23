<template>
  <div class="tree-container">
    <el-row type="flex" justify="start" style="margin-bottom: 10px;">
      <h6 class="organization-tips"><i class="el-icon-tickets" />部门最多可创建三级</h6>
    </el-row>
    <div :style="'height:' + autoHeight + 'px;overflow-y:auto;'">
      <el-tree :data="treeData" node-key="id" default-expand-all :expand-on-click-node="false" class="tree">
        <span class="custom-tree-node" slot-scope="{ node, data }" @click="onClick(data)">
          <span>{{ data.name }}</span>
          <span>
            <template v-if="data.depth < 2 || data.depth === 0">
              <Authorized :permission="['COMPANY_B2BDEPT_CREATE']">
                <el-button type="text" size="mini" @click="appendDept(data)">
                  <i class="el-icon-plus" style="border: 1px solid"/>
                </el-button>
              </Authorized>
            </template>
            <template v-if="data.depth > 0">
              <Authorized :permission="['COMPANY_B2BDEPT_CREATE']">
                <el-button type="text" size="mini" @click="editDept(data, node)">
                  <i class="el-icon-edit"/>
                </el-button>
              </Authorized>
            </template>
            <template v-if="data.depth > 0">
              <Authorized :permission="['COMPANY_B2BDEPT_REMOVE']">
                <el-button type="text" size="mini" @click="deleteDept(data)">
                  <i class="el-icon-delete"/>
                </el-button>
              </Authorized>
            </template>
          </span>
        </span>
      </el-tree>
    </div>
    <el-dialog :visible.sync="deptFormVisible" class="purchase-dialog" width="40%" append-to-body :close-on-click-modal="false">
      <dept-form v-if="deptFormVisible" :formData="formData" @onConfirm="onConfirm"/>
    </el-dialog>
  </div>
</template>

<script>
  import {DeptForm} from '../index.js'

  export default {
    name: 'OrganizationTree',
    props: ['treeData', 'queryFormData'],
    components: {
      DeptForm
    },
    computed: {
      geiHeight: function () {
        return parseInt(this.autoHeight) + 35;
      }
    },
    methods: {  
      onClick (data) {
        this.queryFormData.deptName = data.name;
        if (data.depth === 0) {
          this.queryFormData.deptName = '';
        }
        this.$emit('onAdvancedSearch', 0 , 10);
      },
      appendDept (row) {
        event.stopPropagation();
        this.formData = {
          id: null,
          parentId: row.id !== 0 ? row.id : null,
          name: '',
          functionTypes: []
        }
        this.deptFormVisible = true;
      },
      editDept (row, node) {
        event.stopPropagation();
        this.formData = {
          id: row.id,
          parentId: row.parentId,
          name: row.name,
          functionTypes: row.functionTypes
        };
        this.deptFormVisible = true;
      },
      async onConfirm (form) {
        const url = this.apis().createB2BCustomerDept();
        const result = await this.$http.put(url, form);
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
        event.stopPropagation();
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
          deptName: '',
          deptType: ''
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

  /* /deep/ .el-tree-node__content {
    padding-left: 0px !important;
  } */

  .custom-tree-node {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 12px;
    padding-right: 8px;
  }

  /*!* 树形结构节点添加连线 *!*/
  /* .tree /deep/ .el-tree-node {
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
  } */
  /*.tree /deep/ .el-tree-node__expand-icon.is-leaf {*/
  /*  display: none;*/
  /*}*/

  /* .tree /deep/ .el-tree-node:before {
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
  } */
</style>
