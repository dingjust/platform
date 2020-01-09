<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row>
        <div class="customer-list-title">
          <h6>添加员工</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <el-form ref="form" :model="slotData" :rules="rules" :inline="true" :hide-required-asterisk="true">
        <el-row type="flex">
          <el-col :span="9">
            <el-form-item prop="name">
              <template slot="label">
                <h6 class="titleTextClass">员工姓名<span style="color: #F56C6C">*</span></h6>
              </template>
              <el-row type="flex">
                <el-input placeholder="请填写员工姓名" v-model="uid" size="mini" style="width: 194px"></el-input>
              </el-row>
            </el-form-item>
          </el-col>
          <el-col :span="9">
            <el-form-item prop="uid">
              <template slot="label">
                <h6 class="titleTextClass">员工账号<span style="color: #F56C6C">*</span></h6>
              </template>
              <el-row type="flex">
                <el-input placeholder="请输入员工账号" v-model="name" size="mini" style="width: 194px"></el-input>
              </el-row>
              <h6 style="margin-left: 40px;">员工初始密码与账号相同</h6>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-button size="medium" type="primary" class="toolbar-search_input" @click="invite" style="margin-bottom: 10px">
              邀请
            </el-button>
          </el-col>
        </el-row>
        <el-row type="flex">
          <el-col :span="9">
            <el-form-item prop="name">
              <template slot="label">
                <h6 class="titleTextClass">所属部门<span style="color: #FFFFFF">*</span></h6>
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
          </el-col>
          <el-col :span="9">
            <el-form-item prop="uid">
              <template slot="label">
                <h6 class="titleTextClass">选择角色<span style="color: #FFFFFF">*</span></h6>
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
          </el-col>
        </el-row>
        <b2-b-customer-permission-form/>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import B2BCustomerPermissionForm from './B2BCustomerPermissionForm';
  export default {
    name: 'B2BCustomerBasicForm',
    components: {B2BCustomerPermissionForm},
    props: ['slotData', 'readOnly'],
    methods: {
      invite () {

      }
    },
    data () {
      return {
        rules: {
          uid: [{required: true, message: '必填', trigger: 'blur'}],
          name: [{required: true, message: '必填', trigger: 'blur'}]
        },
        uid: '',
        name: '',
        mobileNumber: '',
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
      };
    },
    created () {
    }
  };
</script>
<style scoped>
  .customer-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .b2bCustomer-toolbar .formLabel {
    font-size: 12px;display: inline-block;
  }

  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .titleTextClass {
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 70px;
    font-size: 14px;
    /*font-weight: bold;*/
  }

</style>
