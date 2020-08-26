<template>
  <div class="headerBox">
    <el-row type="flex">
      <i class="el-icon-warning-outline warning-icon"></i>
      <el-button type="text" @click="onClick">{{label}}</el-button>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'TwinkleWarningButton',
    props:{
      label:{
        default:''
      }
    },
    methods:{
      onClick(){
        this.$emit('click');
      }
    }
  }

</script>
<style scoped>
  @keyframes fade {
    from {
      opacity: 1.0;
    }

    50% {
      opacity: 0.4;
    }

    to {
      opacity: 1.0;
    }
  }

  @-webkit-keyframes fade {
    from {
      opacity: 1.0;
    }

    50% {
      opacity: 0.4;
    }

    to {
      opacity: 1.0;
    }
  }

  .headerBox {
    color: #fff;
    padding: 10px;
    font-size: 15px;
    height: 60px;
    animation: fade 600ms infinite;
    -webkit-animation: fade 600ms infinite;
    cursor: pointer;
  }

  .warning-icon {
    color: red;
    padding-top: 6px;
    font-size: 20px;
  }

</style>
