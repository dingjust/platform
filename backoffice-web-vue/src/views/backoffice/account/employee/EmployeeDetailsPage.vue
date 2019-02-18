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
      <hr/>
      <label>用户组</label>
      <div>
        <el-row :gutter="20">
          <el-col :span="24">
            <el-tag v-for="tag in this.slotData.groups" closable
                    :key="tag.uid"
                    :disable-transitions="false"
                    @close="onRemove(tag)">
              {{tag.name}}
            </el-tag>
          </el-col>
        </el-row>
        <div class="pt-3"></div>
        <el-form>
          <el-row>
            <el-col :span="8">
              <el-form-item v-if="inputVisible">
                <el-select v-model="newGroup" placeholder="请选择用户组" size="small">
                  <el-option v-for="item in this.userGroups"
                             :key="item.id"
                             :label="item.uid"
                             :value="item.uid">
                    {{item.uid}}
                  </el-option>
                </el-select>
                <el-button-group v-if="inputVisible" style="margin-left:5px;">
                  <el-button type="primary" size="mini" @click="onJoin">加入</el-button>
                  <el-button @click="inputVisible=false" size="mini">取消</el-button>
                </el-button-group>
              </el-form-item>
              <el-button v-if="!inputVisible" type="primary" size="mini"
                         @click="onNewGroup" style="margin-top: 10px;">
                加入用户组
              </el-button>
            </el-col>
          </el-row>
        </el-form>
      </div>
    </el-card>
  </div>
</template>

<script>
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

          this._resetPassword();

          return true;
        });
      },
      async _resetPassword() {
        const result = await this.$http.post('/djbackoffice/user/resetPassword', {
          uid: this.slotData.uid,
          password: this.resetFormData.password
        });

        if (result["errors"]) {
          this.$message.error('重置密码失败，原因：' + result["errors"][0].message);
          return;
        }

        this.$message.success('重置密码成功');
        this.resetFormDialogVisible = false;
      },
      async getUserGroups() {
        const result = await this.$http.get('/djbackoffice/group/platform/all');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.userGroups = result.members;
      },
      onNewGroup() {
        this.newGroup = '';
        this.inputVisible = true;
      },
      onRemove(group) {
        //调用推出该用户组接口
        this.$confirm('此操作将退出该用户组, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => this._onRemove(group))
          .catch(() => {
            this.$message.info('已取消退出');
          });
      },
      async _onRemove(group) {
        const result = await this.$http.delete('/djbackoffice/group/members', {
          employeeUid: this.slotData.uid,
          groupUid: group.uid
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.slotData.groups.splice(this.slotData.groups.indexOf(group), 1);
        this.$message.success('退出用户组成功');
      },
      showInput(inputName) {
        this.inputVisible = true;
        this.$nextTick(() => {
          this.$refs.saveTagInput.$refs.input.focus();
        });
      },
      async onJoin() {
        const result = await this.$http.post('/djbackoffice/group/members?employeeUid=' +
          this.slotData.uid +
          '&groupUid=' +
          this.newGroup
        );
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        if (result !== '') {
          this.slotData.groups.push({
            id: result.id,
            uid: result.uid,
            name: result.name
          });
        }
        this.inputVisible = false;
        this.$message.success('加入用户组成功');
      },
      async getRoles() {
        const result = await this.$http.get('/djbackoffice/role?text=');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.roles = result.content;
      },
      async onUpdateRole() {
        const result = this.$http.put('/djbackoffice/employee', this.slotData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('保存成功');
        this.fn.closeSlider(true);
      }
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
              required: true,
              message: '密码格式不正确，必须包含数字,字母,特殊符号两种或以上组合，且长度为6-16位',
              trigger: 'blur',
              pattern: '^(?![0-9]+$)(?![a-zA-Z]+$)(?!([^(0-9a-zA-Z)]|[\\(\\)])+$)([^(0-9a-zA-Z)]|[\\(\\)]|[a-zA-Z]|[0-9]){6,16}$'
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
    },
    created() {
      this.getUserGroups();
      this.getRoles();
    }
  };
</script>

