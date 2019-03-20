<style type="scss">
  .custom-tree-node {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding-right: 8px;
  }
</style>
<template>
  <el-tree ref="tree" node-key="code"
           accordion
           show-checkbox
           default-expand-all
           :data="perms"
           :props="defaultProps"
           :default-checked-keys="defaultCheckedKeys">
        <span class="custom-tree-node" slot-scope="{ node, data }">
          <span>{{ node.label }}</span>
        </span>
  </el-tree>
</template>

<script>
  export default {
    name: 'RoleBasicForm',
    props: ['slotData', 'readOnly'],
    methods: {
      async onSearch() {
        const result = await this.$http.get('/djbackoffice/role/perms');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.perms = result;
      },
    },
    computed: {
      defaultCheckedKeys: function () {
        let result = [];
        for (const index in this.slotData.perms) {
          result.push(this.slotData.perms[index].code);
        }
        return result;
      }
    },
    data() {
      return {
        perms: [],
        defaultProps: {
          children: 'children',
          label: 'name'
        }
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
