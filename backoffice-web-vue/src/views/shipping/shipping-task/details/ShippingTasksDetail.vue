<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="title">
            <h6>发货任务单</h6>
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
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="24">
          <shipping-tasks-orders-list :formData="formData" @onCreate="onCreate"/>
        </el-col>
      </el-row>
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px">
        <el-button class="shipping-btn" :disabled="isFinish" @click="onFinish">发货完结</el-button>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import ShippingTasksQuantityTable from '@/views/shipping/shipping-Task/table/ShippingTasksQuantityTable'
  import ShippingTasksOrdersList from '@/views/shipping/shipping-task/list/ShippingTasksOrdersList'
  export default {
    name: 'ShippingTasksDetail',
    props: ['id'],
    components: {
      ShippingTasksQuantityTable,
      ShippingTasksOrdersList
    },
    computed: {
      isFinish: function () {
        // TODO 判断是否所有发货单都已收货
        return false;
      }
    },
    methods: {
      async getDetail () {
        // TODO 获取发货任务详情
        const url = this.apis().getProductionTaskDetails(this.id);
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.formData = result.data;
      },
      onCreate () {
        // TODO 整理需要传递的数据
        let taskData = this.formData;
        this.$router.push({
          name: '创建发货单',
          params: {
            taskData: taskData
          }
        });
      },
      onFinish () {
        this.$confirm('确认发货完结后，不能再创建发货单了，表示改发货任务完结，是否确认该操作。', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onFinish();
        });
      },
      _onFinish () {
        // 发货完结
      }
    },
    data() {
      return {
        formData: {
          orders: []
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
    margin-top: 20px;
  }

  .shipping-btn {
    width: 120px;
    height: 40px;
  }
</style>
