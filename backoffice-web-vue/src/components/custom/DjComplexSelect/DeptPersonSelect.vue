<template>
  <div>
    <el-tooltip :content="tipTilte" placement="top" effect="light" :disabled="selectData.length <= 0">
      <el-cascader v-model="selectData" :options="treeData"
                  :style="'width:' + width + 'px'"
                  :disabled="cascaderDisabled"
                  :props=" { 
                    multiple: true,
                    checkStrictly: checkStrictly,
                    value: 'mark',
                    label: 'name'
                  }" clearable>
      </el-cascader>
    </el-tooltip>
  </div>
</template>

<script>
import {
  createNamespacedHelpers
} from 'vuex';

const {
  mapGetters,
} = createNamespacedHelpers(
  'CacheModule'
);

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
      default: true
    },
    dataQuery: {
      type: Object,
      default: () => {}
    },
    width: {
      type: String,
      default: '194'
    }
  },
  components: {
  },
  computed: {
    ...mapGetters({
      deptListLoaded: 'deptListLoaded',
      personListLoaded: 'personListLoaded',
      deptList: 'deptList',
      personList: 'personList'
    }),
    cascaderDisabled: function () {
      return this.dataQuery.users.length > 0;
    },
    tipTilte: function () {
      let str = '';
      str = this.selectData.map(item => {
        return item.map(val => {
          return val.name;
        }).join('/');
      }).join(', ');
      return str;
    }
  },
  methods: {
    async initData () {
      if (!this.deptListLoaded) {
        // 部门数据没有加载过，调用加载函数
        await this.$store.dispatch('PersonnelModule/searchDeptList');
      }
      if (!this.personListLoaded) {
        // 员工数据没有加载过，调用加载函数
        await this.$store.dispatch('PersonnelModule/searchPersonList');
      }

      if (this.deptList.loaded && this.personList.loaded) {
        this.handleData();
      }
    },
    handleData () {
      let depts = JSON.parse(JSON.stringify(this.deptList.options));
      // 数据权限未部门权限，过滤其他部门数据
      if (this.dataQuery && this.dataQuery.depts.length === 1 && this.dataQuery.depts[0] != 0) {
        depts = [this.breadthQuery(depts, this.dataQuery.depts[0])];
      } else if (this.dataQuery && this.dataQuery.depts.length <= 0 && this.dataQuery.users.length > 0) {
        depts = [];
      }
      this.treeData = depts;
      this.setMark(this.treeData, 'dept');
      this.createDeptPersonTree();
    },
    setMark (tree, type) {
      let stark = [];

      stark = stark.concat(tree);

      while (stark.length) {
        let temp = stark.shift();
        this.$set(temp, 'mark', {
          type: type,
          id: temp.id,
          name: temp.name
        })
        if (temp.children) {
          stark = stark.concat(temp.children);
        }
      }
    },
    createDeptPersonTree () {
      if (this.dataQuery && this.dataQuery.depts.length <= 0 && this.dataQuery.users.length > 0) {
        this.personList.options.forEach(item => {
          if (item.id === this.dataQuery.users[0]) {
            this.$set(item, 'mark', {
              type: 'person',
              id: item.id,
              name: item.name
            })
            this.treeData.push(item);
          }
        })
      } else {
        this.personList.options.forEach(item => {
          this.$set(item, 'mark', {
            type: 'person',
            id: item.id,
            name: item.name
          })
          if (item.b2bDept) {
            let temp = this.breadthQuery(this.treeData, item.b2bDept.id);
            if (temp && temp.children) {
              temp.children.push(item);
            }
          }
          
          // 主账号没所属部门时，跟一级部门同级
          if (item.root && item.b2bDept == null && this.dataQuery.depts[0] == 0) {
            this.treeData.push(item);
          } 
        })
      }
      
      // 回显
      if (this.dataQuery.depts.length > 0 || this.dataQuery.users.length > 0) {
        this.echoData();
      }
    },
    echoData () {
      let arr = [];
      if (this.dataQuery.depts.length > 0 && this.dataQuery.depts[0] !== 0) {
        arr = this.familyTree(this.treeData, this.dataQuery.depts[0]);
      } else if (this.dataQuery.depts.length > 0 && this.dataQuery.depts[0] === 0) {
        return;
      } else if (this.dataQuery.users.length > 0) {
        arr = this.familyTree(this.treeData, this.dataQuery.users[0]);
      }
      if (arr.length > 0) {
        let echo = arr.map(item => item.mark)
        this.selectData = [echo];
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
    setSelect (tree) {
      this.selectDept.length = [];
      this.selectPerson.length = [];
      let stark = [];
      stark = stark.concat(tree);
      stark.sort((o1,o2)=>o1.length-o2.length);
      let temp;
      let index;
      let middleStark;

      while (stark.length) {
        temp = stark.shift();
        // middleStark = JSON.parse(JSON.stringify(stark));
        
        middleStark = stark.filter(item => item.findIndex(val => val.id === temp[temp.length - 1].id) <= -1);
        // stark.forEach((item, starkIndex) => {
        //   if (item.findIndex(val => val.id === temp[temp.length - 1].id) > -1) {
        //     middleStark.splice(starkIndex, 1);
        //   }
        // })


        if (temp[temp.length -1].type === 'dept') {
          this.selectDept.push(temp[temp.length -1].id);
        } else {
          this.selectPerson.push(temp[temp.length -1].id);
        }

        stark = middleStark;
      }
    },
    // 回显数据处理
    familyTree (arr1, id) {
      var temp = []
      var forFn = function (arr, id) {
        for (var i = 0; i < arr.length; i++) {
          var item = arr[i]
          if (item.id === id) {
            temp.unshift(item)
            if (item.parentId) {
              forFn(arr1, item.parentId)
            } else if (item.parentId == null && item.b2bDept) {
              forFn(arr1, item.b2bDept.id)
            }
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
    },
    clearSelectData () {
      this.selectData = [];
    }
  },
  data () {
    return {
      treeData: [],
      selectData: []
    }
  },
  watch: {
    selectData: function (nval, oval) {
      // 数据清空,恢复默认权限
      if (nval.length <= 0) {
        this.selectDept.length = 0;
        this.selectPerson.length = 0;
        this.echoData();
        return;
      }
      if (nval) {
        this.setSelect(this.selectData);
      }
    },
    'deptList.options': function (nval, oval) {
      if (this.deptList.loaded && this.personList.loaded && this.treeData.length <= 0) {
        this.handleData();
      }
    },
    'personList.options': function (nval, oval) {
      if (this.deptList.loaded && this.personList.loaded && this.treeData.length <= 0) {
        this.handleData();
      }
    }
  },
  created () {
    this.initData();
  }
}
</script>

<style scoped>
  /deep/ .el-cascader__tags {
    flex-wrap: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
</style>