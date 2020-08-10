<template>
  <el-cascader v-model="person" 
                :disabled="disabled"
                :options="deptList" 
                :show-all-levels="false"
                :props="{ label: 'name', value: 'id' }" 
                clearable></el-cascader>
</template>

<script>
export default {
  name: 'PersonnalSelectionV2',
  props: {
    // 关联对象为所选择项在 tree 中由 id组成的数组分支，取最后一项为选择项的id，引用处自行处理
    vPerson: {
      default: () => []
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  data () {
    return {
      deptList: [],
      person: []
    }
  },
  methods: {
    async getDeptList () {
      const url = this.apis().getB2BCustomerDeptList();
      const result = await this.$http.post(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }
      this.deptList = result.data;

      await this.getPersonList();
    },
    async getPersonList () {
      const url = this.apis().getB2BCustomers();
      const result = await this.$http.post(url, {
        enable: false
      }, {
        page: 0,
        size: 99
      })
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }

      this.personList = result.content;

      // 组建tree
      await this.createDeptPersonTree();
    },
    createDeptPersonTree () {
      this.personList.forEach(item => {
        if (item.b2bDept) {
          this.$set(item, 'parentId', item.b2bDept.id);
        }
        if (item.b2bDept) {
          let temp = this.breadthQuery(this.deptList, item.b2bDept.id);
          temp.children.push(item);
        }
      })

      // 处理数据回显
      if (this.vPerson && this.vPerson.id) {
        let arr = this.familyTree(this.deptList, this.vPerson.id);
        this.person = arr.map(item => item.id);
      }
    },
    breadthQuery (tree, id) {
      let stark = [];

      stark = stark.concat(tree);

      while(stark.length) {
        let temp = stark.shift();
        if(temp.children) {
            stark = stark.concat(temp.children);
        }
        if(temp.id === id) {
            return temp;
        }
      }
    },
    familyTree (arr1, id) {
      var temp = []
      var forFn = function (arr, id) {
        for (var i = 0; i < arr.length; i++) {
          var item = arr[i]
          if (item.id === id) {
            temp.unshift(item)
            // if (item.parentId) {
              forFn(arr1, item.parentId)
            // } else if (item.parentId == null && item.b2bDept) {
            //   forFn(arr1, item.b2bDept.id)
            // }
            break
          } else {
            if (item.children) {
              forFn(item.children, id)
            }
          }
        }
      }
      forFn(arr1, id)
      return temp
    }
  },
  watch: {
    vPerson: function (newVal, oldVal) {
      this.person = newVal;
    },
    person: function (newVal, oldVal) {
      this.$emit('update:vPerson', newVal);
    }
  },
  created () {
    this.getDeptList();
  }
}
</script>

<style scoped>

</style>