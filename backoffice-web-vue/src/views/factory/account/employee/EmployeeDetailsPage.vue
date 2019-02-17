<style>
  .el-tag + .el-tag {
    margin-left: 10px;
    margin-top: 5px;
  }
</style>
<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
        <span class="float-right">
          <el-button type="primary" size="mini" @click="resetFormDialogVisible = true">
            重置密码
          </el-button>
          <el-button type="primary" :disabled=false size="mini" @click="updateRoleDialogVisible = true">
          修改角色
          </el-button>
        </span>
      </div>
      <employee-base-form :slot-data="slotData"
                          :is-newly-created="false"
                          :read-only="true">
      </employee-base-form>
      <el-dialog title="重置密码" :visible.sync="resetFormDialogVisible" :close-on-click-modal="false" :modal="false">
        <el-form :model="resetFormData" :rules="resetPasswordRules" ref="resetForm">
          <el-form-item label="新密码" prop="password">
            <el-input type="password" auto-complete="off" v-model="resetFormData.password">
            </el-input>
          </el-form-item>
          <el-form-item label="确认新密码" prop="confirmPassword">
            <el-input type="password" auto-complete="off" v-model="resetFormData.confirmPassword">
            </el-input>
          </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button @click="resetFormDialogVisible = false">取 消</el-button>
          <el-button type="primary" @click="onResetPassword">确 定</el-button>
        </div>
      </el-dialog>

      <el-dialog title="修改角色" :visible.sync="updateRoleDialogVisible" :close-on-click-modal="false" :modal="false">
        <el-form ref="form" label-position="top" :model="slotData">
          <el-row :gutter="10">
            <el-col :span="22">
              <el-form-item label="角色" prop="roles">
                <el-checkbox-group v-model="slotData.roles">
                  <el-checkbox v-for="item in roles" :label="item.uid" :key="item.uid">
                    {{item.name}}
                  </el-checkbox>
                </el-checkbox-group>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button @click="updateRoleDialogVisible = false">取 消</el-button>
          <el-button type="primary" @click="onUpdateRole">确 定</el-button>
        </div>
      </el-dialog>
    </el-card>
  </div>
</template>

<script>
  import axios from 'axios';
  import EmployeeBaseForm from './EmployeeBaseForm';

  export default {
    name: 'EmployeeDetailsPage',
    props: ['slotData'],
    components: {EmployeeBaseForm},
    methods: {
      onResetPassword() {
        this.$refs['resetForm'].validate(valid => {
          if (!valid) {
            return false;
          }
          axios.post('/djfactory/user/resetPassword', {
            uid: this.slotData.uid,
            password: this.resetFormData.password
          }).then(() => {
            this.$message.success('重置密码成功');
            this.resetFormDialogVisible = false;
          }).catch(() => {
            this.$message.error('重置密码失败');
          });

          return true;
        });
      },
      getRoles() {
        axios
          .get('/djfactory/role?text=')
          .then(response => {
            console.log(response.data.content);
            this.roles = response.data.content;
          })
          .catch(error => {
            this.$message.error(error.response.statusText);
          });
      },
      onUpdateRole() {
        console.log(this.slotData);
        axios.put('/djfactory/employee', this.slotData)
          .then(() => {
            this.$message.success('保存成功');
            this.fn.closeSlider(true);
            //刷新主体数据
          }).catch(error => {
            this.$message.error('保存失败，原因：' + error.response.data.message);
          }
        );
      }
    },
    created() {
      this.getRoles();
    },
    data() {
      // 重置密码校验
      const validateResetPass = (rule, value, callback) => {
        if (value === '') {
          callback(new Error('请输入密码'));
        } else {
          if (this.resetFormData.confirmPassword !== '') {
            this.$refs['resetForm'].validateField('confirmPassword');
          }
          callback();
        }
      };
      // 重置密码校验
      const validateResetPass2 = (rule, value, callback) => {
        if (value === '') {
          callback(new Error('请再次输入密码'));
        } else if (value !== this.resetFormData.password) {
          callback(new Error('两次输入密码不一致!'));
        } else {
          callback();
        }
      };
      return {
        resetFormDialogVisible: false,
        updateRoleDialogVisible: false,
        resetFormData: {
          password: '',
          confirmPassword: ''
        },
        resetPasswordRules: {
          password: [{validator: validateResetPass, trigger: 'blur'},
            {
              required: true, message: '密码格式不正确，必须包含数字,字母,特殊符号两种或以上组合，且长度为6-16位',
              trigger: 'blur', pattern: '^(?![0-9]+$)(?![a-zA-Z]+$)(?!([^(0-9a-zA-Z)]|[\\(\\)])+$)([^(0-9a-zA-Z)]|[\\(\\)]|[a-zA-Z]|[0-9]){6,16}$'
            }],
          confirmPassword: [{validator: validateResetPass2, trigger: 'blur'}]
        },
        userGroups: [],
        //动态标签
        // tags:tagData,
        inputVisible: false,
        inputValue: '',
        newGroup: '',
        roles: []
      };
    }
  };
</script>

