<template>
    <div>
      <el-tree :data="slotData" node-key="id" default-expand-all :expand-on-click-node="false" :indent=10>
        <span class="custom-tree-node" slot-scope="{ node, data }">
          <span v-if="data.name !== name || !showInput" @dblclick="dblclick(data)"
                @mouseover="onActive(data)" @mouseleave="offActive"
                :class="nodeClassShow(data)? 'active_tree_node':''">
            {{ data.name }}
          </span>
          <el-input ref="input" v-if="data.name === name && showInput" v-model="modifyName" @blur="setName(node, data)" autofocus/>
          <authorized :authority="permission.companyB2bDeptCR">
            <span v-if="data.name !== name || showIconV">
              <el-button type="text" size="mini">
                <i v-if="topAppendShow(data)" class="el-icon-circle-plus-outline" @click="append(node, data)"/>
                <i v-if="data.depth > 0" class="el-icon-setting" @click="showIcon(data)"/>
              </el-button>
            </span>
            <span v-else @mouseleave="showOption()">
                <el-button v-if="appendShow(data)" type="text" size="mini" @click="() => append(node, data)">添加子部门</el-button>
  <!--            <el-button v-if="data.depth > 1 && type==='role' && !appendInputVisible" type="text" size="mini" @click="() => editRole(node, data)">编辑角色</el-button>-->
                <el-button v-if="removeShow(data)" type="text" size="mini" @click="() => remove(node, data)">删除</el-button>
            </span>
          </authorized>
        </span>
      </el-tree>
    </div>
</template>

<script>
    import {hasPermission} from '../../../../../auth/auth';

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
            this.$message.error('此部门下有子部门，暂不支持删除操作');
            return;
          }
          this.$emit('removeDept', data.id);
        },
        handleClick (tab, event) {
          console.log(tab, event);
        },
        dblclick (data) {
          console.log(data);
          if (data.depth === 0 || hasPermission(this.permission.companyB2bDeptRename)) {
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
          if (!this.modifyName.match(/^\s*$/)) {
            data.name = this.modifyName.trim();
          }
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
          if (data.depth === 0 || hasPermission(this.permission.companyB2bDeptRename)) {
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
