<template>
    <div class="tree-container">
      <el-tree :data="slotData" node-key="id" default-expand-all :expand-on-click-node="false" :indent='10' class="tree filter-tree">
        <span class="custom-tree-node" slot-scope="{ node, data }" @click="searchOnRole(data)">
          <span v-if="data.id !== applyId || !showInput" @dblclick="dblclick(data)"
                @mouseover="onActive(data)" @mouseleave="offActive"
                :class="nodeClassShow(data)? 'active_tree_node':''">
            {{ data.name }}
          </span>
          <el-input ref="input" v-if="data.id === applyId && showInput"
                    v-model="modifyName"
                    @blur="setName(node, data)"
                    autofocus
                    onkeydown="if(event.keyCode==13){blur()}">
          </el-input>
          <el-button type="text" size="mini">
            <i v-if="appendShow(data)" class="el-icon-circle-plus-outline" @click="append"/>
          </el-button>
          <el-dropdown trigger="click" v-if="showDropdown(data)" @command="handleCommand($event, data)">
              <span @click="showIcon(data)">
                <i class="el-icon-setting" style="color: #409eff"/>
              </span>
              <el-dropdown-menu slot="dropdown" >
                <el-dropdown-item v-if="modifyShow(data)" command="modify">编辑角色</el-dropdown-item>
                <el-dropdown-item v-if="removeShow(data)" command="remove">删除</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
        </span>
      </el-tree>
    </div>
</template>

<script>
    import {hasPermission} from '../../../../../auth/auth';
    var time;
    export default {
      name: 'B2BCustomerRoleTree',
      props: ['slotData'],
      computed: {
      },
      data () {
        return {
          showInput: false,
          label: '',
          name: '',
          modifyName: '',
          modifyLabel: '',
          showIconV: true,
          isActive: false,
          applyId: ''
        };
      },
      methods: {
        searchOnRole (data) {
          clearTimeout(time);
          time = setTimeout(() => {
            let roleName = '';
            if (data.name != '所有角色') {
              roleName = data.name;
            }
            this.$emit('searchInAside', '', roleName);
          }, 200)
        },
        showDropdown (data) {
          return !data.hasOwnProperty('depth') && (hasPermission(this.permission.companyB2bRoleModify) || hasPermission(this.permission.companyB2bRoleRemove))
        },
        handleCommand (command, data) {
          if (command == 'modify') {
            this.editRole(data);
          } else if (command == 'remove') {
            this.remove(data);
          }
        },
        appendShow (data) {
          return hasPermission(this.permission.companyB2bRoleCreate) && data.depth == 0;
        },
        modifyShow (data) {
          return hasPermission(this.permission.companyB2bRoleModify) && data.depth != 0;
        },
        removeShow (data) {
          return hasPermission(this.permission.companyB2bRoleRemove) && data.depth != 0;
        },
        append () {
          event.stopPropagation();
          this.$emit('createRole');
        },
        editRole (data) {
          this.$emit('editRole', data);
        },
        remove (data) {
          this.$confirm('确认后将删除此角色，请问是否继续?', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            this.$emit('removeRole', data.id);
          });
        },
        dblclick (data) {
          clearTimeout(time);
          if (data.depth === 0 || !hasPermission(this.permission.companyB2bRoleModify)) {
            return
          }
          this.showInput = true;
          this.applyId = data.id;
          this.modifyName = data.name;
          // input获取焦点
          this.$nextTick(() => {
            this.$refs.input.focus();
          })
        },
        async setName (node, data) {
          setTimeout(() => {
            this.$confirm('是否保存修改?', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning',
              closeOnClickModal: false
            }).then(() => {
              this._setName(node, data);
            }).catch(() => {
              this.$nextTick(() => {
                this.$refs.input.focus();
              })
            });
          }, 10);
        },
        _setName (node, data) {
          if (this.modifyName.match(/^\s*$/) || this.modifyName == data.name) {
            this.showInput = false;
            this.isActive = false;
            return;
          }
          let formData = {
            id: data.id,
            name: this.modifyName.trim(),
            roleIds: []
          };
          this.showInput = false;
          this.isActive = false;
          this.$emit('saveRoleName', formData);
        },
        showIcon (data) {
          event.stopPropagation();
          this.applyId = data.id;
          this.showIconV = false;
        },
        showOption () {
          if (this.showInput) {
            return;
          }
          this.showIconV = true;
        },
        onActive (data) {
          if (this.showInput) {
            return;
          }
          this.applyId = data.id;
          this.isActive = true;
        },
        offActive () {
          if (this.showInput) {
            return;
          }
          this.isActive = false;
        },
        nodeClassShow (data) {
          if (data.depth === 0 || !hasPermission(this.permission.companyB2bRoleModify)) {
            return;
          }
          if (this.applyId == data.id && !this.showInput && this.isActive) {
            return true;
          }
          return false;
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

  /* 树形结构节点添加连线 */
  .tree /deep/ .el-tree-node {
    position: relative;
    padding-left: 16px;
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
  .tree /deep/ .el-tree-node__expand-icon.is-leaf {
    display: none;
  }

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
