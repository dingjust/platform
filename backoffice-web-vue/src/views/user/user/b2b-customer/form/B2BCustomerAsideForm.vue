<template>
  <el-tabs v-model="activeName" @tab-click="handleClick">
    <el-tab-pane label="用户管理" name="first">
      <h6><i class="el-icon-document"/>&nbsp;部门最多创建三级</h6>
      <el-tree :data="testData" node-key="id" default-expand-all :expand-on-click-node="false" :indent=10>
        <span class="custom-tree-node" slot-scope="{ node, data }">
          <span v-if="node.label !== label || !showInput" @dblclick="dblclick(node)"
                @mouseover="onActive(node)" @mouseleave="offActive"
                :class="nodeClassShow(node)? 'active_tree_node':''">
            {{ node.label }}
          </span>
          <el-input ref="input" v-if="node.label === label && showInput" v-model="modifyLabel" @blur="setLabel(node)" autofocus/>
          <span v-if="node.label !== label || showIconV">
            <el-button type="text" size="mini">
<!--              <i v-if="node.id == 1" class="el-icon-circle-plus-outline" @click="append(node, data)"/>-->
              <i class="el-icon-setting" @click="showIcon(node)"/>
            </el-button>
          </span>
          <span v-else @mouseleave="showOption()">
            <el-button v-if="node.level < 3" type="text" size="mini" @click="() => append(node, data)">添加子部门</el-button>
            <el-button v-if="node.id > 1" type="text" size="mini" @click="() => remove(node, data)">删除</el-button>
          </span>
        </span>
      </el-tree>
    </el-tab-pane>
    <el-tab-pane label="配置管理" name="second">
      <h6><i class="el-icon-document"/>&nbsp;部门最多创建三级</h6>
      <el-tree :data="testData" node-key="id" default-expand-all :expand-on-click-node="false" :indent=10>
      </el-tree>
    </el-tab-pane>
  </el-tabs>
</template>

<script>
    let id = 1000;
    export default {
      name: 'B2BCustomerAsideForm',
      computed: {
      },
      data () {
        return {
          testData: [{
            id: 1,
            label: '所有部门',
            children: [{
              id: 2,
              label: '二级 1-1',
              children: [{
                id: 4,
                label: '三级 1-1-1'
              }, {
                id: 5,
                label: '三级 1-1-2'
              }]
            },
            {
              id: 3,
              label: '二级 1-2',
              children: [{
                id: 6,
                label: '三级 1-2-1'
              }, {
                id: 7,
                label: '三级 1-2-2'
              }]
            }]
          }],
          activeName: 'first',
          showInput: false,
          label: '',
          modifyLabel: '',
          showIconV: true,
          isActive: false
        };
      },
      methods: {
        append (node, data) {
          const newChild = { id: id++, label: '未命名', children: [] };
          if (!data.children) {
            this.$set(data, 'children', []);
          }
          data.children.push(newChild);
        },

        remove (node, data) {
          if (node.childNodes.length > 0) {
            this.$message.error('此部门下有子部门，暂不支持删除操作');
            return;
          }
          const parent = node.parent;
          const children = parent.data.children || parent.data;
          const index = children.findIndex(d => d.id === data.id);
          children.splice(index, 1);
        },
        handleClick (tab, event) {
          console.log(tab, event);
        },
        dblclick (node) {
          if (node.id === 1) {
            return
          }
          this.showInput = true;
          this.label = node.label;
          this.modifyLabel = node.label;
          // input获取焦点
          this.$nextTick(() => {
            this.$refs.input.focus();
          })
        },
        setLabel (node) {
          if (!this.modifyLabel.match(/^\s*$/)) {
            node.data.label = this.modifyLabel.trim();
          }
          this.showInput = false;
        },
        showIcon (node) {
          console.log(node);
          this.label = node.label;
          this.showIconV = false;
        },
        showOption () {
          this.showIconV = true;
        },
        onActive (node) {
          this.label = node.label;
          this.isActive = true;
        },
        offActive () {
          if (this.showInput) {
            return;
          }
          this.isActive = false;
        },
        nodeClassShow (node) {
          if (this.label == node.label && !this.showInput && this.isActive) {
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
