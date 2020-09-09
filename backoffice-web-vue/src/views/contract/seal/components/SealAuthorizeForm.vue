<template>
  <div>
    <el-row type="flex" justify="center" style="margin-bottom: 20px">
      <h6 style="font-size: 20px">印章授权</h6>
    </el-row>
    <el-row type="flex" justify="center">
      <el-form :inline="true">
        <el-form-item label="选择授权人员">
          <personnal-selection-v2 :vPerson.sync="person" value="uid"/>
        </el-form-item>
      </el-form>
    </el-row>
    <el-row type="flex" justify="center" align="middle" >
      <h6 style="color: #F56C6C">注：被授权人需要完成个人实名认证</h6>
    </el-row>
    <el-row type="flex" justify="center" align="middle" style="margin-top: 10px">
      <el-button class="create-btn" @click="onSumbit">确定</el-button>
    </el-row>
  </div>
</template>

<script>
import { PersonnalSelectionV2 } from '@/components'
export default {
  name: 'SealAuthorizeForm',
  props: ['slotData'],
  components: {
    PersonnalSelectionV2
  },
  methods: {
    async onSumbit () {
      if (this.person.length <= 0 || !this.person[this.person.length - 1]) {
        this.$message.error('请选择用户');
        return;
      }
      
      const sealCode = this.slotData.code;
      const customerUid = this.person[this.person.length - 1]

      const url = this.apis().sealGrant(sealCode, customerUid);
      const result = await this.$http.post(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }
      this.$message.success("授权成功！");
      this.$emit('callback');
    }
  },
  data () {
    return {
      person: []
    }
  }  
}
</script>

<style scoped>
  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    border-radius: 3px;
    width: 70px;
    height: 30px;
  }
</style>