<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="title">
            <h6>创建发货任务单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="3">
          <!-- <img width="54px" height="54px"
            :src="scope.row.thumbnail!=null&&scope.row.thumbnail.length!=0?scope.row.thumbnail.url:'static/img/nopicture.png'"> -->
          <img width="100px" height="100px" :src="'static/img/nopicture.png'">
        </el-col>
        <el-col :span="21">
          <el-row type="flex" style="padding: 10px 0px">
            <el-col :span="8">
              <h6>产品名称：磨毛斜布棉毛</h6>
            </el-col>
            <el-col :span="8">
              <h6>货号：KY0000000001</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="8">
              <h6>发货方：宁波衣加衣有限公司</h6>
            </el-col>
            <el-col :span="8">
              <h6>收货方：宁波衣加衣有限公司</h6>
            </el-col>
            <el-col :span="8">
              <h6>发货负责人：麻花腾</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="12">
              <h6>收货地址：广州市海珠区云顶同创汇二期</h6>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="24">
          <shipping-tasks-quantity-table :formData="formData"/>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import ShippingTasksQuantityTable from '@/views/shipping/shipping-Task/table/ShippingTasksQuantityTable'
  export default {
    name: 'ShippingTasksDetail',
    props: ['id'],
    components: {
      ShippingTasksQuantityTable
    },
    computed: {
    },
    methods: {
      async getDetail () {
        const url = this.apis().getProductionTaskDetails(this.id);
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.formData = result.data;
      }
    },
    data() {
      return {
        formData: {

        }
      }
    },
    created() {
      this.getDetail();
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

  .basic-row {
    padding-left: 10px;
  }
</style>
