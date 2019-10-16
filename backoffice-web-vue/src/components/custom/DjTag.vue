<template>
  <el-tag :type="tagType">{{approvalStatus|enumTranslate('ArticleApprovalStatus')}}</el-tag>
</template>
<script>
  export default {
    name: 'DjTag',
    props: ['type'],
    methods: {},
    computed: {
      tagType: function () {
        switch (this.type) {
          case 'check':
            return 'info';
          case 'approved':
            return 'success';
          case 'unapproved':
            return 'danger';
        }
      }
    }
  };
</script>
