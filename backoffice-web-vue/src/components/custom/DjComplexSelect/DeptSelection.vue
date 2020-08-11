<template>
  <el-cascader v-model="dept" 
                :disabled="disabled"
                :options="deptList"
                :show-all-levels="false"
                :props="{ checkStrictly: true, label: 'name', value: 'id', disabled: 'disabled' }" 
                clearable></el-cascader>
</template>

<script>
export default {
  name: 'DeptSelection',
  props: {
    // 关联对象为所选择项在 tree 中由 id组成的数组分支，取最后一项为选择项的id，引用处自行处理
    vDept: {
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
      dept: [],
      echoData: '',
      idArr: []
    }
  },
  methods: {
    async getDeptList () {
      let query = {
        functionTypeList: ['PRODUCTION']
      }
      const url = this.apis().getB2BCustomerDeptList();
      const result = await this.$http.post(url, query);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code == 0) {
        this.$message.error(result.msg);
        return;
      }
      this.deptList = result.data;

      this.setMark(this.deptList);

      // 处理数据回显
      if (this.vDept && this.vDept.id) {
        let arr = this.familyTree(result.data, this.vDept.id);
        this.dept = arr.map(item => item.id);
      }
    },
    setMark (tree) {
      let stark = [];

      stark = stark.concat(tree);

      while (stark.length) {
        let temp = stark.shift();
        let flag = true;
        if (temp.functionTypes.indexOf('PRODUCTION') > -1) {
          flag = false;
        }
        this.$set(temp, 'disabled', flag)
        if (temp.children) {
          stark = stark.concat(temp.children);
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
            forFn(arr1, item.parentId)
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
    vDept: function (newVal, oldVal) {
      this.dept = newVal;
    },
    dept: function (newVal, oldVal) {
      this.$emit('update:vDept', newVal);
    }
  },
  created () {
    this.getDeptList();
  }
}
</script>

<style scoped>

</style>