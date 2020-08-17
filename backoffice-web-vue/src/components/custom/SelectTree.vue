<template>
  <div class="select-tree-container">
    <el-select v-model="selectData" placeholder="请选择" value-key="id" clearable>
      <div class="tree-container">
        <el-tree :data="treeData"  node-key="id"  default-expand-all :expand-on-click-node="false" class="tree">
          <span slot-scope="{ node, data }" style="width: 100%">
            <el-option :key="data.id" :label="data.name" :value="data"></el-option>
          </span>
        </el-tree>
      </div>
    </el-select>
  </div>
</template>

<script>
  export default {
    name: 'SelectTree',
    props: {
      treeData: {
        type: Array,
        default: () => []
      },
      vSelectData: {
        required: true
      }
    },
    components: {

    },
    computed: {

    },
    methods: {

    },
    data () {
      return {
        selectData: ''
      }
    },
    watch: {
      vSelectData: function (newVal, oldVal) {
        this.selectData = newVal;
      },
      selectData: function (newVal, oldVal) {
        this.$emit('update:vSelectData', newVal);
      }
    },
    created () {
      this.selectData = this.vSelectData;
    },
    destroyed () {

    }    
  }
</script>

<style scoped>
  /deep/ .el-select-dropdown__item {
    padding-left: 0px;
  }

  /deep/ .el-select-dropdown__item.hover, .el-select-dropdown__item:hover {
    background-color: #ffffff00;
  }

  /deep/ .el-tree-node__content {
    /* padding-left: 0px !important; */
    height: 32px;
  }

  /deep/ .el-tree-node__expand-icon {
    z-index: 999;
  }

  /*!* 树形结构节点添加连线 *!*/
  /* .tree /deep/ .el-tree-node { */
    position: relative;
    /* padding-left: 8px; */
  /* } */

  /* .tree /deep/ .el-tree-node__children {
    padding-left: 16px;
  }

  .tree /deep/ .el-tree-node :last-child:before {
    height: 42px;
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
    top: 16px;
    width: 18px;
  } */
</style>