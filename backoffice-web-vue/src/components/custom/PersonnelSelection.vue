<template>
  <el-select v-model="person" filterable placeholder="请选择" value-key="id" :disabled="readOnly" :size="size"
    :style="'width:'+ width +'px'">
    <el-option v-for="item in personList.options" :key="item.id" :label="item.name" :value="item">
    </el-option>
  </el-select>
</template>

<script>
/**
 * @module  '@/components/custom/PersonnelSelection'
 * @example 调用示例
 *  <personnel-selection :vPerson.sync="vPerson"/>
 */
import {
  createNamespacedHelpers
} from 'vuex';

const {
  mapGetters,
} = createNamespacedHelpers(
  'PersonnelModule'
);
export default {
  name: 'PersonnelSelection',
  props: {
    vPerson: {
      type: Object,
    },
    readOnly: {
      type: Boolean,
      default: false
    },
    size: {
      type: String,
      default: 'small'
    },
    width: {
      type: String,
      default: ''
    }
  },
  computed: {
    ...mapGetters({
      personListLoaded: 'personListLoaded',
      personList: 'cachePersonList'
    })
  },
  methods: {
    // 获取人员列表
    async getPersonnelList() {
      if (!this.personListLoaded) {
        // 员工数据没有加载过，调用加载函数
        await this.$store.dispatch('PersonnelModule/searchPersonList');
      }
    }
  },
  data() {
    return {
      personnelList: [],
      person: {}
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
  created() {
    this.getPersonnelList();
    this.person = this.vPerson;
  },
  mounted() {}
}
</script>

<style scoped>

</style>
