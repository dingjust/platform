<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>对账任务单</h6>
          </div>
        </el-col>
      </el-row>
      <el-form :inline="true" label-position="left" label-width="70px">
        <el-row type="flex" justify="start" class="basic-row">
          <el-col :span="3">
            <!-- <img width="54px" height="54px"
              :src="scope.row.thumbnail!=null&&scope.row.thumbnail.length!=0?scope.row.thumbnail.url:'static/img/nopicture.png'"> -->
            <img width="100px" height="100px" :src="'static/img/nopicture.png'">
          </el-col>
          <el-col :span="21">
            <el-row type="flex" style="padding: 10px 0px">
              <el-col :span="8">
                <h6 class="basic-label">产品名称：红烧猪蹄</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">货号：梅菜扣肉</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <el-col :span="8">
                <h6 class="basic-label">发货方：红烧猪蹄</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">收货方：梅菜扣肉</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">发货负责人：烧鸡翅</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <el-col :span="12">
                <h6 class="basic-label">收货地址：广州市海珠区云顶同创汇二期</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px" v-if="formData.online">
              <el-col :span="8">
                <h6 class="basic-label">发货方式：顺丰快递</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">发货单号：SF017532492929</h6>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="basic-row">
          <el-col :span="24">
            <reconciliation-tasks-quantity-table :formData="formData"/>
          </el-col>
        </el-row>
        <el-row type="flex" justify="end">
          <el-col :span="2">
            <el-button @click="onCreate">创建对账单</el-button>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start">
          <el-col :span="24">
            <reconciliation-tasks-orders-list :formData="formData" @onCreate="onCreate"/>
          </el-col>
        </el-row>
        <el-row type="flex" justify="center" align="middle" style="margin-top: 30px">
          <el-col :span="4">
            <el-button class="sumbit-btn" @click="onSumbit" v-if="canFinish">对账完结</el-button>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import ReconciliationTasksQuantityTable from '../table/ReconciliationTasksQuantityTable'
  import ReconciliationTasksOrdersList from '../list/ReconciliationTasksOrdersList'
  export default {
    name: 'ReconciliationTasksDetail',
    props: ['id'],
    components: {
      ReconciliationTasksQuantityTable,
      ReconciliationTasksOrdersList
    },
    computed: {
      canFinish: function () {
        // TODO 判断是否能对账完结
        return true;
      }
    },
    methods: {
      async getDetail () {
        // TODO 获取发货单详情
      },
      onCreate () {
        this.$router.push('/reconciliation/create/orders');
      },
      onSumbit () {
        this.$confirm('确认对账完结后，不能再创建对账单了，表示该对账任务完结，是否确认该操作?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onSumbit();
        });
      },
      _onSumbit () {

      }
    },
    data() {
      return {
        formData: {
          online: false,
          carrier: ''
        },
        taskData: '',
        carriers: ''
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

  .basic-label {
    font-size: 14px;
    color: #606266;
  }

  /deep/ .el-form-item {
    margin-bottom: 0px;
  }

  .sumbit-btn {
    width: 125px;
    height: 40px;
    border-radius: 10px;
  }
</style>
