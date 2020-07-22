<template>
  <div class="tree-container">
    <el-row type="flex" justify="start">
      <h6 class="organization-tips"><i class="el-icon-tickets" />部门最多可创建三级</h6>
    </el-row>
    <el-tree :data="treeData" node-key="id" default-expand-all :expand-on-click-node="false" class="tree">
      <span class="custom-tree-node" slot-scope="{ node, data }">
        <span>{{ data.name }}</span>
        <span v-if="data.depth > 0">
          <el-button v-if="data.depth < 3" type="text" size="mini" @click="appendDept(data)">
            <i class="el-icon-plus" style="border: 1px solid"/>
            </el-button>
          <el-button type="text" size="mini" @click="editDept(data)">
            <i class="el-icon-edit"/>
          </el-button>
          <el-button type="text" size="mini" @click="deleteDept(data)">
            <i class="el-icon-delete"/>
          </el-button>
        </span>
      </span>
    </el-tree>
  </div>
</template>

<script>
  export default {
    name: 'OrganizationTree',
    props: ['treeData'],
    computed: {

    },
    methods: {  
      appendDept (row) {
        this.$emit('appendDept', row);
      },
      editDept (row) {
        this.$emit('editDept', row);
      },
      deleteDept () {
        this.$emit('deleteDept', row);
      }
    },
    data () {
      return {

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
    font-size: 14px;
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