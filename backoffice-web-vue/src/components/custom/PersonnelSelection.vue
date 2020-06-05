<template>
  <el-select v-model="person" filterable placeholder="请选择" value-key="id" :disabled="readOnly" :size="size"
    :style="'width:'+ width +'px'">
    <el-option v-for="item in personnelList" :key="item.id" :label="item.name" :value="item">
    </el-option>
  </el-select>
</template>

<script>
  /**
   * @module  '@/components/custom/PersonnelSelection'
   * @example 调用示例
   *  <personnel-selection :vPerson.sync="vPerson"/>
   */
  export default {
    name: 'PersonnelSelection',
    props: {
      vPerson: {
        type: Object,
        default: {}
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

    },
    methods: {
      // 获取人员列表
      async getPersonnelList() {
        const url = this.apis().getB2BCustomers();
        const result = await this.$http.post(url, {}, {
          page: 0,
          size: 99
        })
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.personnelList = result.content;
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
