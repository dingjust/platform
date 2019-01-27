<template>
  <el-tag :type="tagType">{{approvalStatus|enumTranslate('ArticleApprovalStatus')}}</el-tag>
</template>
<script>
export default {
    name: "ApprovalStatus",
    props: ["approvalStatus"],
    methods: {},
    computed: {
        tagType: function() {
            switch (this.approvalStatus) {
                case "check":
                    return "info";
                case "approved":
                    return "success";
                case "unapproved":
                    return "danger";
            }
        }
    }
};
</script>