<template>
  <ol class="breadcrumb">
    <li :key="'bc'+index" class="breadcrumb-item" v-for="(item, index) in refactorList">
      <span class="active" v-if="isLast(index)">{{ showName(item) }}</span>
      <router-link :to="item.path" v-else>{{ showName(item) }}</router-link>
    </li>
  </ol>
</template>

<script>
  export default {
    props: {
      list: {
        type: Array,
        required: true,
        default: () => []
      }
    },
    computed: {
      //重构路由记录
      refactorList: function () {
        let result = this.list.map(item => {
          return {
            path: item.path,
            name: item.name,
            meta: item.meta
          }
        });
        for (let i = 0; i < result.length; i++) {
          //父路由记录修改
          if (result[i].meta && result[i].meta.breadCrumbParentName && result[i].meta.breadCrumbParentUrl && i != 0) {
            result[i - 1].path = result[i].meta.breadCrumbParentUrl;
            result[i - 1].name = result[i].meta.breadCrumbParentName;
          }
          //忽略路由记录显示
          if (result[i].meta && result[i].meta.breadCrumbSkip) {
            let a = result.splice(1, result[i].meta.breadCrumbSkip);
          }
        }
        return result
      }
    },
    methods: {
      // isLast(index) {
      //   return index === this.list.length - 1
      // },
      isLast(index) {
        return index === this.refactorList.length - 1
      },
      showName(item) {
        if (item.meta && item.meta.label) {
          item = item.meta && item.meta.label
        }
        if (item.name) {
          item = item.name
        }
        return item
      }
    }
  }

</script>
