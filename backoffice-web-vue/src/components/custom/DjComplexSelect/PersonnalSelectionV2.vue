<template>
  <el-cascader v-model="person" 
                :disabled="disabled"
                :options="treeData" 
                :show-all-levels="false"
                :props="{ label: 'name', value: value }" 
                clearable></el-cascader>
</template>

<script>
import {
  createNamespacedHelpers
} from 'vuex';

const {
  mapGetters,
} = createNamespacedHelpers(
  'PersonnelModule'
);
export default {
  name: 'PersonnalSelectionV2',
  props: {
    // 关联对象为所选择项在 tree 中由 id组成的数组分支，取最后一项为选择项的id，引用处自行处理
    vPerson: {
      default: () => {
        return [];
      }
    },
    disabled: {
      type: Boolean,
      default: false
    },
    // 是否需要排除本账号
    excludeMySelf: {
      type: Boolean,
      default: false
    },
    selectedRow: {
      type: Array,
      default: ()=>{
        return [];
      }
    },
    value: {
      type: String,
      default: 'id'
    }
  },
  data () {
    return {
      treeData: [],
      person: []
    }
  },
  computed: {
    ...mapGetters({
      deptListLoaded: 'deptListLoaded',
      personListLoaded: 'personListLoaded',
      deptList: 'cacheDeptList',
      personList: 'cachePersonList'
    })
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
        this.createDeptPersonTree();
      }
    },
    createDeptPersonTree () {
      this.treeData = JSON.parse(JSON.stringify(this.deptList.options));

      let index;
      this.personList.options.forEach(item => {
        if (item.uid === this.$store.getters.currentUser.uid && this.excludeMySelf) {
          return;
        }

        index = this.selectedRow.findIndex(val => {
          if (val) {
            return item.id === val[val.length - 1];
          }
        })

        if (index > -1 && item.id !== this.person[this.person.length - 1]) {
          return;
        }

        if (item.b2bDept) {
          this.$set(item, 'parentId', item.b2bDept.id);
          let temp = this.breadthQuery(this.treeData, item.b2bDept.id);
          temp.children.push(item);
        }

        // 主账号没所属部门时，跟一级部门同级
        if (item.root && item.b2bDept == null) {
          this.treeData.push(item);
        } 
      })

      // 处理数据回显
      if (this.vPerson && this.vPerson.id) {
        let arr = this.familyTree(this.treeData, this.vPerson.id);
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
    vPerson: function (newVal, oldVal) {
      this.person = newVal;
    },
    person: function (newVal, oldVal) {
      this.$emit('update:vPerson', newVal);
    },
    selectedRow: function (newVal, oldVal) {
      this.createDeptPersonTree();
    },
    'deptList.options': function (nval, oval) {
      if (this.deptList.loaded && this.personList.loaded && this.treeData.length <= 0) {
        this.createDeptPersonTree();
      }
    },
    'personList.options': function (nval, oval) {
      if (this.deptList.loaded && this.personList.loaded && this.treeData.length <= 0) {
        this.createDeptPersonTree();
      }
    }
  },
  created () {
    this.initData();
  }
}
</script>

<style scoped>

</style>
