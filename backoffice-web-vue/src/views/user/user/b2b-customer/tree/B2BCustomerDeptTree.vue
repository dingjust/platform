<template>
    <div class="tree-container">
      <el-tree :data="slotData" node-key="id" default-expand-all :expand-on-click-node="false" :indent='0'class="tree filter-tree">
        <span class="custom-tree-node" slot-scope="{ node, data }">
          <span v-if="data.name !== name || !showInput" @dblclick="dblclick(data)" @click="searchOnDept(data)"
                @mouseover="onActive(data)" @mouseleave="offActive"
                :class="nodeClassShow(data)? 'active_tree_node':''">
            {{ data.name }}
          </span>
          <el-input ref="input" v-if="data.name === name && showInput"
                    v-model="modifyName"
                    autofocus
                    @blur="setName(node, data)"
                    onkeydown="if(event.keyCode==13){blur()}"/>
<!--          <authorized :authority="permission.companyB2bDeptCR">-->
            <el-button type="text" size="mini" v-if="topAppendShow(data)">
              <i class="el-icon-circle-plus-outline" @click="append(node, data)"/>
            </el-button>
            <el-dropdown trigger="click" v-if="data.depth > 0 && (hasPer(permission.companyB2bDeptCreate) || hasPer(permission.companyB2bDeptRemove))" @command="handleCommand($event, node, data)">
              <span class="el-dropdown-link">
                <i class="el-icon-setting" style="color: #409eff" @click="showIcon(data)"/>
              </span>
              <el-dropdown-menu slot="dropdown" >
                <el-dropdown-item v-if="appendShow(data)" command="append">添加子部门</el-dropdown-item>
                <el-dropdown-item v-if="removeShow(data)" command="remove">删除</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
<!--            <span v-else @mouseleave="showOption()">-->
<!--                <el-button v-if="appendShow(data)" type="text" size="mini" @click="() => append(node, data)">添加子部门</el-button>-->
<!--  &lt;!&ndash;            <el-button v-if="data.depth > 1 && type==='role' && !appendInputVisible" type="text" size="mini" @click="() => editRole(node, data)">编辑角色</el-button>&ndash;&gt;-->
<!--                <el-button v-if="removeShow(data)" type="text" size="mini" @click="() => remove(node, data)">删除</el-button>-->
<!--            </span>-->
<!--          </authorized>-->
        </span>
      </el-tree>
    </div>
</template>

<script>
    import {hasPermission} from '../../../../../auth/auth';
    var time = null;
    export default {
      name: 'B2BCustomerDeptTree',
      props: ['slotData'],
      computed: {

      },
      data () {
        return {
          appendInputVisible: false,
          showInput: false,
          label: '',
          name: '',
          modifyName: '',
          modifyLabel: '',
          showIconV: true,
          isActive: false
        };
      },
      methods: {
        searchOnDept (data) {
          clearTimeout(time);
          time = setTimeout(() => {
            let deptName = '';
            if (data.name != '所有部门') {
              deptName = data.name;
            }
            this.$emit('searchInAside', deptName, '');
          }, 200)
        },
        hasPer (permission) {
          return hasPermission(permission);
        },
        handleCommand (command, node, data) {
          if (command == 'append') {
            this.append(node, data);
          } else if (command == 'remove') {
            this.remove(node, data);
          }
        },
        topAppendShow (data) {
          return hasPermission(this.permission.companyB2bDeptCreate) && data.depth == 0;
        },
        appendShow (data) {
          return data.depth < 3 && !this.appendInputVisible && hasPermission(this.permission.companyB2bDeptCreate);
        },
        removeShow (data) {
          return data.depth > 0 && !this.appendInputVisible && hasPermission(this.permission.companyB2bDeptRemove);
        },
        append (node, data) {
          const depth = data.depth;
          if (depth === 3) {
            this.$message.error('部门最多可以创建三级');
            return;
          }
          const newChild = { name: '未命名', children: [], depth: depth + 1 };
          if (!data.children) {
            this.$set(data, 'children', []);
          }
          data.children.push(newChild);
          this.modifyName = newChild.name;
          this.name = newChild.name;
          this.showInput = true;
          this.appendInputVisible = true;
          this.$nextTick(() => {
            this.$refs.input.focus();
          })
        },
        editRole (node, data) {
          this.$emit('editRole', data);
        },
        remove (node, data) {
          if (node.childNodes.length > 0) {
            this.$confirm('删除该部门下会将下级部门一并删除，请问是否继续?', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }).then(() => {
              this.$emit('removeDept', data.id);
            });
          } else {
            this.$confirm('确认后将删除此部门，请问是否继续?', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }).then(() => {
              this.$emit('removeDept', data.id);
            });
          }
        },
        dblclick (data) {
          clearTimeout(time);
          if (data.depth === 0 || !hasPermission(this.permission.companyB2bDeptRename)) {
            return
          }
          this.showInput = true;
          this.name = data.name;
          this.modifyName = data.name;
          // input获取焦点
          this.$nextTick(() => {
            this.$refs.input.focus();
          })
        },
        async setName (node, data) {
          // 去空格
          if (!this.modifyName.match(/^\s*$/)) {
            data.name = this.modifyName.trim();
          }
          setTimeout(() => {
            this.$confirm('是否保存修改?', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }).then(() => {
              this._setName(node, data);
            }).catch(() => {
              this.$nextTick(() => {
                this.$refs.input.focus();
              })
            });
          }, 10)
        },
        async _setName (node, data) {
          if (data.name === '未命名') {
            this.$message.error('请给部门名称命名');
            // input获取焦点
            this.$nextTick(() => {
              this.$refs.input.focus();
            })
            return;
          }
          if (this.name == this.modifyName) {
            this.appendInputVisible = false;
            this.showInput = false;
            this.isActive = false;
            return;
          }
          let formData;
          if (this.appendInputVisible) {
            formData = {
              deptName: data.name,
              parentId: node.parent.data.id
            }
          } else {
            formData = {
              id: data.id,
              deptName: data.name,
              parentId: node.parent.data.id
            }
          }

          const url = this.apis().createB2BCustomerDept();
          const result = await this.$http.put(url, formData, formData);
          if (result.code === 0) {
            this.$message.error(result.msg);
            data.name = this.name;
            // input获取焦点
            this.$nextTick(() => {
              this.$refs.input.focus();
            })
            return;
          }
          this.$emit('appendDept', formData);
          this.appendInputVisible = false;
          this.showInput = false;
          this.isActive = false;
        },
        showIcon (data) {
          this.name = data.name;
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
          this.name = data.name;
          this.isActive = true;
        },
        offActive () {
          if (this.showInput) {
            return;
          }
          this.isActive = false;
        },
        nodeClassShow (data) {
          if (data.depth === 0 || !hasPermission(this.permission.companyB2bDeptRename)) {
            return;
          }
          if (this.name == data.name && !this.showInput && this.isActive) {
            return true;
          }
          return false;
        }
      }
    }
</script>

<style scoped>
  /deep/ .el-tree-node__content {
    padding-left: 0px !important;
  }
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
