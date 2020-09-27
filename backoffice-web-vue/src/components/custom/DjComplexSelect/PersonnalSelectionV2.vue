<template>
  <el-cascader v-model="person" 
                :disabled="disabled"
                :options="deptList" 
                :show-all-levels="false"
                :props="{ label: 'name', value: value }" 
                clearable></el-cascader>
</template>

<script>
import {
  createNamespacedHelpers
} from "vuex";

const {
  mapState,
} = createNamespacedHelpers(
  "OrganizationModule"
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
      deptList: [],
      person: [],
      personList: []
    }
  },
  computed: {
    ...mapState({
      deptOptions: state => state.deptList.options,
      loading: state => state.deptList.loading,
      personOptions: state => state.personList.options,
    })
  },
  methods: {
    initData () {
      this.deptList = JSON.parse(JSON.stringify(this.deptOptions));
      this.personList = JSON.parse(JSON.stringify(this.personOptions));
      this.createDeptPersonTree();
    },
    createDeptPersonTree () {
      let index;
      this.personList.forEach(item => {
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
          let temp = this.breadthQuery(this.deptList, item.b2bDept.id);
          temp.children.push(item);
        }

        // 主账号没所属部门时，跟一级部门同级
        if (item.root && item.b2bDept == null) {
          this.deptList.push(item);
        } 
      })

      // 处理数据回显
      if (this.vPerson && this.vPerson.id) {
        console.log(this.vPerson.name);
        console.log(this.deptList);  
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
      this.initData();
    },
    loading: function (nval, oval) {
      if (nval === false && this.deptOptions.length > 0) {
        this.initData();
      }
    }
  },
  created () {
    if (this.loading === false) {
      this.initData();
      // 处理数据回显
      if (this.vPerson && this.vPerson.id) {  
        let arr = this.familyTree(this.deptList, this.vPerson.id);
        this.person = arr.map(item => item.id);
      }
    }
  },
  beforeCreate () {
    this.$store.commit('OrganizationModule/deptList', {cmd: 'plusRef'});
    if (this.$store.state.OrganizationModule.deptList.refNum <= 1) {
      this.$store.dispatch('OrganizationModule/loadDeptList', this);
    }
  },
  destroyed() {
    this.$store.commit('OrganizationModule/deptList', {cmd: "minusRef"});
  }
}
</script>

<style scoped>

</style>
