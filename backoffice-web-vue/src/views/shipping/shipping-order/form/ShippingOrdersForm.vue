<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>创建发货单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
    </el-card>
  </div>
</template>

<script>
  export default {
    name: 'ShippingOrdersPage',
    components: {
    },
    computed: {
    },
    methods: {
    },
    data() {
      return {
        formData: {
          
        }
      }
    },
    created() {
    },
    destroyed() {

    }
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
