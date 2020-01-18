<template>
  <div>
    <el-row>
      <div class="customer-list-title">
        <h6>邀请员工</h6>
      </div>
    </el-row>
    <div class="pt-2"></div>
    <el-row type="flex" justify="center">
      <el-form ref="form" :model="slotData" :rules="rules" :hide-required-asterisk="true">
        <el-form-item prop="contactPhone">
          <template slot="label">
            <h6 class="titleTextClass">账号<span style="color: #F56C6C">*</span></h6>
          </template>
          <el-row type="flex">
            <el-input placeholder="请填写手机号" v-model="contactPhone" style="width: 250px"></el-input>
          </el-row>
        </el-form-item>
        <el-form-item prop="dept">
          <template slot="label">
            <h6 class="titleTextClass">所属部门<span style="color: #F56C6C">*</span></h6>
          </template>
          <el-row type="flex">
            <el-select v-model="value" placeholder="请选择所属部门">
              <el-option
                v-for="item in options"
                :key="item.value"
                :label="item.label"
                :value="item.value">
              </el-option>
            </el-select>
          </el-row>
        </el-form-item>
        <el-form-item prop="role">
          <template slot="label">
            <h6 class="titleTextClass">角色</h6>
          </template>
          <el-row type="flex">
            <el-select v-model="value" placeholder="请选择角色">
              <el-option
                v-for="item in options"
                :key="item.value"
                :label="item.label"
                :value="item.value">
              </el-option>
            </el-select>
          </el-row>
        </el-form-item>
      </el-form>
    </el-row>
    <el-row type="flex" justify="space-around">
      <el-button @click="onCannel" size="mini">取消</el-button>
      <el-button style="background-color: #FFD60C" @click="onConfirm" size="mini">确定</el-button>
    </el-row>
  </div>
</template>

<script>
    export default {
      name: 'B2BCustomerInviteDialog',
      props: ['slotData'],
      data() {
        return {
          rules: {
            contactPhone: [{required: true, message: '必填', trigger: 'blur'}],
            dept: [{required: true, message: '必填', trigger: 'blur'}]
          },
          contactPhone: '',
          dept: '',
          options: [{
            value: '选项1',
            label: '黄金糕'
          }, {
            value: '选项2',
            label: '双皮奶'
          }, {
            value: '选项3',
            label: '蚵仔煎'
          }, {
            value: '选项4',
            label: '龙须面'
          }, {
            value: '选项5',
            label: '北京烤鸭'
          }],
          value: ''
        }
      },
      methods: {
        onCannel () {
          this.$emit('onCannel')
        },
        onConfirm () {
          this.$refs['form'].validate(valid => {
            if (valid) {
              let formData = {

              };
              this.$emit('onConfirm', formData);
            } else {
              this.$message.error('请完善表单信息');
              return false;
            }
          });
        }
      }
    }
</script>

<style scoped>
  .customer-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .formLabel {
    font-size: 12px;display: inline-block;
  }

  .titleTextClass {
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 65px;
    font-size: 14px;
  }
</style>
