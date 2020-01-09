<template>
  <div class="animated fadeIn">
    <el-row>
      <el-form-item>
        <template slot="label">
          <h6 class="titleTextClass">权限选择</h6>
        </template>
      </el-form-item>
      <el-button style="background-color: #FFD60C" @click="handleCheckAllChange" size="mini">全选</el-button>
      <el-button native-type="reset" @click="onReset" size="mini">重置</el-button>
    </el-row>
    <el-row type="flex" align="middle" :gutter="20">
      <el-col>
        <el-tree
          :data="data2"
          default-expand-all
          :check-on-click-node="true"
          :indent=8
          show-checkbox
          node-key="id"
          ref="tree1"
          highlight-current
          :expand-on-click-node="false"
          :props="defaultProps">
        </el-tree>
      </el-col>
      <el-col>
        <el-tree
          :data="data2"
          :indent=8
          :check-on-click-node="true"
          default-expand-all
          show-checkbox
          node-key="id"
          ref="tree"
          highlight-current
          :expand-on-click-node="false"
          :props="defaultProps">
        </el-tree>
      </el-col>
      <el-col>
        <el-tree
          :data="data2"
          show-checkbox
          :check-on-click-node="true"
          :indent=8
          default-expand-all
          node-key="id"
          ref="tree"
          highlight-current
          :expand-on-click-node="false"
          :props="defaultProps">
        </el-tree>
      </el-col>
      <el-col>
        <el-tree
          :data="data2"
          :indent=8
          :check-on-click-node="true"
          show-checkbox
          default-expand-all
          node-key="id"
          ref="tree"
          highlight-current
          :expand-on-click-node="false"
          :props="defaultProps">
        </el-tree>
      </el-col>
      <el-col>
        <el-tree
          :data="data2"
          :indent=8
          show-checkbox
          :check-on-click-node="true"
          default-expand-all
          node-key="id"
          ref="tree"
          highlight-current
          :expand-on-click-node="false"
          :props="defaultProps">
        </el-tree>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" v-if="!readOnly">
      <el-button class="buttonClass" @click="onSave">
        <h6>保存</h6>
      </el-button>
    </el-row>
  </div>
</template>

<script>
    export default {
      name: 'B2BCustomerPermissionForm',
      data () {
        return {
          data2: [{
            id: 1,
            label: '一级 1',
            children: [{
              id: 4,
              label: '二级 1-1',
              children: [{
                id: 9,
                label: '三级 1-1-1'
              }, {
                id: 10,
                label: '三级 1-1-2'
              }]
            }]
          }],
          defaultProps: {
            children: 'children',
            label: 'label'
          },
        };
      },
      methods: {
        handleCheckAllChange () {
          this.$refs.tree1.setCheckedNodes(this.data2);
        },
        onReset () {
          this.$refs.tree1.setCheckedNodes([]);
        }
      }
    }
</script>

<style scoped>
  .titleTextClass {
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 60px;
    font-size: 14px;
  }

  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  /deep/ .el-icon-caret-right:before {
    content: "";
  }

  /deep/ .el-tree-node__content>.el-tree-node__expand-icon {
     padding: 0px;
  }

  .buttonClass{
    padding: 10px 120px 0px 120px;
    margin-top: 40px;
    background-color: #ffd60c;
    color: #0b0e0f;
    border-radius: 8px;
  }
</style>
