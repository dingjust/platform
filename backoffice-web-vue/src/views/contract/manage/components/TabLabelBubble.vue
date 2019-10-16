<template>
  <el-row type="flex" align="top" justify="space-between">
    <el-col :span="1">
      <!--<el-button type="text" icon="el-icon-edit" @click="onSearch(label)">{{label}}</el-button>-->
      <h6 @click="onSearch(label)">{{label}}</h6>
    </el-col>
    <!--<el-col :span="1">-->
      <!--<div class="tabs-label_bubble" v-show="num!=0">-->
        <!--&lt;!&ndash;<h6 class="tabs-label_text">{{num}}</h6>&ndash;&gt;-->
      <!--</div>-->
    <!--</el-col>-->
  </el-row>
</template>

<script>
  export default {
    name: "TabLabelBubble",
    props: {
      label: {
        type: String,
        required: true,
        default: () => ""
      },
      num: {
        type: Number,
        required: false,
        default: () => 0
      }
    },
    components: {},
    computed: {},
    methods: {
      onSearch(str){
        console.log(str);
      }
    },
    data() {
      return {};
    },
    created() {}
  };

</script>
<style>
  .tabs-label_bubble {
    width: 15px;
    height: 15px;
    border-radius: 50%;
    background-color: #FF3333;
    text-align: center;
  }

  .tabs-label_text {
    color: white;
    font-size: 12px;
  }
  .tabs-label{
    display: inline;
  }
</style>
