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
           :data="results"
           :props="defaultProps"
           :default-checked-keys="defaultCheckedKeys">
        <span class="custom-tree-node" slot-scope="{ node, data }">
          <span>{{ node.label }}</span>
        </span>
  </el-tree>
</template>

<script>
  export default {
    name: 'RolePermsForm',
    props: ['slotData', 'isNewlyCreated', 'readOnly'],
    computed: {
      defaultCheckedKeys: function () {
        let result = [];
        for (const index in this.slotData.perms) {
          result.push(this.slotData.perms[index].code);
        }
        return result;
      }
    },
    watch: {
      '$store.state.sideSliderState': function (value) {
        if (!value) {
          this.onSearch();
        }
      }
    },
    methods: {
      async onSearch() {
        const result = await this.$http.get('/djfactory/role/perms');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.results = result;
      },
      getValue() {
        return this.$refs['tree'].getCheckedKeys();
      }
    },
    data() {
      return {
        results: [],
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
