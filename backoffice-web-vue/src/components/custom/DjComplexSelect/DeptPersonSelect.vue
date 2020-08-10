<template>
  <div>
    <el-cascader v-model="data" :options="deptList"
                :props=" { 
                  multiple: true,
                  checkStrictly: checkStrictly,
                  value: 'mark',
                  label: 'name'
                }" collapse-tags clearable>
    </el-cascader>
  </div>
</template>

<script>
export default {
  name: 'DeptPersonSelect',
  props: {
    selectDept: {
      type: Array,
      default: () => []
    },
    selectPerson: {
      type: Array,
      default: () => []
    },
    checkStrictly: {
      type: Boolean,
      default: false
    },
    onlyDept: {
      type: Boolean,
      default: true
    }
  },
  components: {
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
      this.setMark(this.deptList, 'dept');

      if (!this.onlyDept) {
        await this.getPersonList();
      }
    },
    async getPersonList () {
      const url = this.apis().getB2BCustomers();
      const result = await this.$http.post(url, {}, {
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
    setMark (tree, type) {
      let stark = [];

      stark = stark.concat(tree);

      while (stark.length) {
        let temp = stark.shift();
        this.$set(temp, 'mark', {
          type: type,
          id: temp.id
        })
        if (temp.children) {
          stark = stark.concat(temp.children);
        }
      }
    },
    createDeptPersonTree () {
      this.personList.forEach(item => {
        this.$set(item, 'mark', {
          type: 'person',
          id: item.id
        })
        if (item.b2bDept) {
          let temp = this.breadthQuery(this.deptList, item.b2bDept.id);
          temp.children.push(item);
        }
      })
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
    setSelect (tree) {
      this.selectDept = [];
      this.selectPerson = [];
      let stark = [];
      stark = stark.concat(tree);
      stark.sort((o1,o2)=>o1.length-o2.length);

      let temp;
      let index;
      let middleStark;

      while (stark.length) {
        temp = stark.shift();
        middleStark = JSON.parse(JSON.stringify(stark));

        stark.forEach(item => {
          index = item.findIndex(val => val.id == temp[temp.length -1].id);
          if (index > -1) {
            middleStark.splice(index, 1);
          }
        })
        if (temp[temp.length -1].type === 'dept') {
          this.selectDept.push(temp[temp.length -1].id);
        } else {
          this.selectPerson.push(temp[temp.length -1].id);
        }
        stark = middleStark;
      }
    },
  },
  data () {
    return {
      deptList: [],
      personList: [],
      selectData: [],
      data: ''
    }
  },
  watch: {
    selectData: function (nval, oval) {
      if (nval) {
        this.setSelect(this.selectData);
      }
    }
  },
  created () {
    this.getDeptList();
  }
}
</script>

<style scoped>

</style>