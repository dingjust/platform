<template>
  <el-row type="flex" align="middle" :gutter="5">
    <div class="form-label_bubble">
    </div>
    <div class="form-label">
    <h6 class="form-label_text">{{label}}</h6>
    </div>
  </el-row>
</template>

<script>
  export default {
    name: "FormLabel",
    props: {
      label: {
        type: String,
        required: true,
        default: () => ""
      },
    },
    components: {},
    computed: {},
    methods: {},
    data() {
      return {};
    },
    created() {}
  };

</script>
<style>
  .form-label_bubble {
    width: 5px;
    height: 5px;
    border-radius: 50%;
    background: rgba(255, 214, 12, 1);
    text-align: center;
  }

  .form-label_text {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    text-align: center;
    /* line-height:  */
  }
  .form-label{
    height: 10px;
    margin-left: 8px;
  }

</style>
