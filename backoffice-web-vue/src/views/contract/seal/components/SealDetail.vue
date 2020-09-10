<template>
  <div>
    <el-row type="flex" justify="center" align="top">
      <el-col :span="6">
        <img width="100px" :src="slotData.media.url">
      </el-col>
      <el-col :span="12">
        <el-row type="flex" justify="start" align="middle" style="margin-bottom: 20px;">
          <h6>印章名称：{{slotData.name}}</h6>
        </el-row>
        <el-row type="flex" justify="start" align="middle" style="margin-bottom: 20px;">
          <h6>创建日期：{{slotData.creationtime | timestampToTime}}</h6>
        </el-row>
        <div class="person-row">
          <div>
            <h6 style="margin: 6px">用印权限人：</h6>
          </div>
          <div>
            <el-row type="flex" justify="start" align="middle" v-for="item in grantList.content" :key="item.id" style="margin-bottom: 10px;">
              <el-col :span="8">
                <h6 style="margin: 0px;">{{item.name}}</h6>
              </el-col>
              <el-col :span="8">
                <el-button size="mini" class="create-btn" @click="onCancel(item)">解除用印权限</el-button>
              </el-col>
            </el-row>
          </div>
        </div>
        <el-row type="flex" justify="start" align="middle">
          <el-button type="text" style="color: #606266;margin-left: 40px;" @click="authorizeVislble=true">
            <div class="append-row">
              <i class="el-icon-plus icon-row"></i>
              <h6 style="margin: 0px">添加用印权限人</h6>
            </div>
          </el-button>
        </el-row>
        <el-row type="flex" justify="start" align="middle" style="margin-top: 20px">
          <h6 style="color: #F56C6C">注：用印授权只有主账号可以执行</h6>
        </el-row>
      </el-col>
    </el-row>
    <el-dialog :visible.sync="authorizeVislble" width="40%" append-to-body :close-on-click-modal="false">
      <seal-authorize-form v-if="authorizeVislble" :slotData="slotData" @callback="callback"/>
    </el-dialog>
  </div>
</template>

<script>
import SealAuthorizeForm from './SealAuthorizeForm'
export default {
  name: 'SealDetail',
  props: ['slotData'],
  components: {
    SealAuthorizeForm
  },
  methods: {
    async getGrantList () {
      const url = this.apis().sealGrantList(this.slotData.code);
      const result = await this.$http.post(url, {},{
        page: 0,
        size: 99
      });
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }
      this.grantList = result;
    },
    async onCancel (item) {
      const url = this.apis().sealRevoke(this.slotData.code, item.uid);
      const result = await this.$http.post(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }
      this.$message.success('解除用印权限成功！');
      this.getGrantList();
      this.$emit('callback');
    },
    callback () {
      this.getGrantList();
      this.authorizeVislble = false;
      this.$emit('callback');
    }
  },
  data () {
    return {
      authorizeVislble: false,
      grantList: {
        number: 0, // 当前页，从0开始
        size: 10, // 每页显示条数
        totalPages: 1, // 总页数
        totalElements: 0, // 总数目数
        content: [] // 当前页数据
      }
    }
  },
  created () {
    this.getGrantList();
  }  
}
</script>

<style scoped>
  .person-row {
    display: flex;
    justify-content: flex-start;
    align-items: flex-start;
  }

  .append-row{
    display: flex;
    flex-direction: column;
    justify-content: space-between;
  }

  .icon-row {
    display: flex;
    justify-content: center;
    font-size: 30px;
    font-weight: bold;
  }

  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    border-radius: 5px;
  }

  /deep/ .el-button--small, .el-button--small.is-round {
    padding: 0px 15px;
  }
</style>