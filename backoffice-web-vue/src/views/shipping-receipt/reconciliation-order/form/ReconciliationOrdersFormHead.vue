<template>
  <div>
    <el-row type="flex" justify="start">
      <el-col :span="8">
        <el-form-item label="外发子单号">
          <el-input :disabled="true"></el-input>
          <el-button>选择</el-button>
        </el-form-item>
      </el-col>
    </el-row>
  </div>  
</template>

<script>
  export default {
    name: 'ReconciliationOrdersFormHead',
    props: [],
    components: {

    },
    computed: {

    },
    methods: {

    },
    data () {

    },
    created () {

    }  
  }
</script>

<style scoped>

</style>