<template>
    <div>
      <el-tree :data="slotData" node-key="id" default-expand-all :expand-on-click-node="false" :indent=10>
        <span class="custom-tree-node" slot-scope="{ node, data }">
          <span v-if="data.id !== applyId || !showInput" @dblclick="dblclick(data)"
                @mouseover="onActive(data)" @mouseleave="offActive"
                :class="nodeClassShow(data)? 'active_tree_node':''">
            {{ data.name }}
          </span>
          <el-input ref="input" v-if="data.id === applyId && showInput" v-model="modifyName" @blur="setName(node, data)" autofocus/>
          <authorized :authority="permission.companyB2bRoleMR">
            <span v-if="data.id !== applyId || showIconV">
              <el-button type="text" size="mini">
                <i v-if="appendShow(data)" class="el-icon-circle-plus-outline" @click="append"/>
                <i v-if="!data.hasOwnProperty('depth')" class="el-icon-setting" @click="showIcon(data)"/>
              </el-button>
            </span>
            <span v-else @mouseleave="showOption()">
              <el-button v-if="modifyShow(data)" type="text" size="mini" @click="() => editRole(data)">编辑角色</el-button>
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
          this.$emit('createRole');
        },
        editRole (data) {
          this.$emit('editRole', data);
        },
        remove (node, data) {
          this.$emit('removeRole', data.id);
        },
        dblclick (data) {
          if (data.depth === 0 || hasPermission(this.permission.companyB2bRoleModify)) {
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
          console.log(data);
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
          console.log(data);
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
          if (data.depth === 0 || hasPermission(this.permission.companyB2bRoleModify)) {
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
</style>
