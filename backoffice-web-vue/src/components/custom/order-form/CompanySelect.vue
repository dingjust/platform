<!-- 
 * @description: 公司选择组件
 * @fileName: CompanySelect.vue 
 * @author: yj 
 * @date: 2020-08-11 16:58:38
 * @version: V1.0.0 
!-->
<template>
  <div style="width:100%">
    <el-button @click="onSearch">搜索</el-button>
    <el-table :data="data" height="500">
      <el-table-column label="uid" prop="uid"></el-table-column>
    </el-table>
  </div>
</template>


<script>
  export default {
    name: 'CompanySelect',
    components: {

    },
    props: {

    },
    methods: {
      async onSearch() {
        const url = this.apis().findBrandAndFactory();
        const result = await this.$http.post(url, {
          keyword: this.keyword
        });
        
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.data = result; 
      },
    },
    data() {
      return {
        keyword: '',
        data: []
      };
    },
    created() {

    },
    directives: {
      loadmore: {
        // 指令的定义
        bind(el, binding) {
          const selectWrap = el.querySelector('.el-table__body-wrapper')
          selectWrap.addEventListener('scroll', function () {
            let sign = 0
            const scrollDistance = this.scrollHeight - this.scrollTop - this.clientHeight
            if (scrollDistance <= sign) {
              binding.value()
            }
          })
        }
      }
    }
  }

</script>

<style>

</style>
