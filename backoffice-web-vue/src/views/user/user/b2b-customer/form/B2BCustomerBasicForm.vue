<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row>
        <div class="customer-list-title">
          <h6>添加员工</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <div class="titleCardClass">
        <el-form ref="form" :model="formData" :rules="rules" :inline="true" :hide-required-asterisk="true">
          <div class="titleClass">
            <h6>基本信息</h6>
          </div>
          <div style="margin: 20px 20px 40px 40px">
            <el-row type="flex">
              <el-col :span="12">
                <el-form-item prop="name">
                  <template slot="label">
                    <h6 class="titleTextClass">
                      员工姓名
                      <span style="color: #F56C6C">*</span>
                    </h6>
                  </template>
                  <el-row type="flex">
                    <el-input
                      placeholder="请填写员工姓名"
                      v-model="formData.name"
                      size="mini"
                      style="width: 194px"
                    ></el-input>
                  </el-row>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item prop="uid">
                  <template slot="label">
                    <h6 class="titleTextClass">
                      员工账号
                      <span style="color: #F56C6C">*</span>
                    </h6>
                  </template>
                  <el-row type="flex">
                    <el-input
                      placeholder="请输入员工账号"
                      v-model="formData.uid"
                      size="mini"
                      style="width: 194px"
                    ></el-input>
                  </el-row>
                </el-form-item>
                <h6 style="padding-left: 25%;color: #909399">员工初始密码与账号相同</h6>
              </el-col>
            </el-row>
            <el-row type="flex">

              <el-col :span="12">
                <el-form-item prop="b2bDept">
                  <template slot="label">
                    <h6 class="titleTextClass">
                      所属部门
                      <span style="color: #FFFFFF">*</span>
                    </h6>
                  </template>
                  <el-row type="flex">
                    <el-tree-select :props="props"
                                    :placeholder="'请选择部门'"
                                    :options="deptList"
                                    :value="formData.b2bDept.id"
                                    :label="formData.b2bDept.name"
                                    @getValue="selectDept">
                    </el-tree-select>
<!--                    <el-cascader-->
<!--                      v-model="formData.b2bDept.id"-->
<!--                      :options="deptList"-->
<!--                      :props="{ expandTrigger: 'hover' , value:'id',label:'name', checkStrictly: true, emitPath: false}"-->
<!--                      :change-on-select="true"-->
<!--                      :show-all-levels="false"-->
<!--                      @change="deptSelect"-->
<!--                    ></el-cascader>-->
                  </el-row>
                </el-form-item>
              </el-col>

              <el-col :span="12">
                <el-form-item prop="b2bRoleGroup">
                  <template slot="label">
                    <h6 class="titleTextClass">
                      选择角色
                      <span style="color: #FFFFFF">*</span>
                    </h6>
                  </template>
                  <el-row type="flex">
                    <el-select v-model="formData.b2bRoleGroup" placeholder="请选择角色" value-key="id" @change="roleSelect">
                      <el-option
                        v-for="item in roleGroupList"
                        :key="item.id"
                        :label="item.name"
                        :value="item"
                      ></el-option>
                    </el-select>
                  </el-row>
                </el-form-item>
              </el-col>
            </el-row>
          </div>
          <div class="titleClass">
            <h6>权限选择</h6>
          </div>
          <div style="margin: 20px 20px 40px 40px">
            <b2-b-customer-permission-form :formData="formData" ref="permissionForm"/>
          </div>
        </el-form>
      </div>
      <el-row type="flex" justify="center">
        <el-button class="buttonClass" @click="onSave">
          <h6>保存</h6>
        </el-button>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import B2BCustomerPermissionForm from './B2BCustomerPermissionForm';
  import ElTreeSelect from '../tree/treeSelect';
  export default {
    name: 'B2BCustomerBasicForm',
    components: {ElTreeSelect, B2BCustomerPermissionForm },
    props: [],
    computed: {},
    methods: {
      async getDeptList () {
        const url = this.apis().getB2BCustomerDeptList();
        const result = await this.$http.post(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.deptList = result.data;
        this.getTreeData(this.deptList);
      },
      async getRoleGroupList () {
        let formData = {};
        const url = this.apis().getB2BCustomerRoleGroupList();
        const result = await this.$http.post(url, formData, {
          page: 0,
          size: 100
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.roleGroupList = result.content;
      },
      async roleSelect (data) {
        const url = this.apis().getB2BCustomerRoleGroupDetails(data.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$refs.permissionForm.setCheckChange(result.data.roleList);
      },
      selectDept (val) {
        this.deptId = val;
      },
      async onSave () {
        // console.log(this.formData);
        let data = {
          name: this.formData.name,
          uid: this.formData.uid,
          b2bDept: this.deptId == 0 ? null : { id: this.deptId },
          b2bRoleGroup: this.formData.b2bRoleGroup,
          b2bRoleList: this.distinct(this.formData.b2bRoleList)
        };
        // console.log(data);
        // return ;
        const url = this.apis().createB2BCustomer();
        const result = await this.$http.post(url, data);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('添加员工成功');
        this.$router.push({
          name: '员工'
        });
      },
      // 数组去重
      distinct (arr) {
        let result = []
        let obj = {};
        for (let i of arr) {
          if (!obj[i]) {
            result.push(i)
            obj[i] = 1
          }
        }
        return result
      },
      getTreeData (data) {
        for (var i = 0; i < data.length; i++) {
          if (data[i].children == null) {
            return;
          }
          if (data[i].children.length < 1) {
            data[i].children = undefined;
          } else {
            this.getTreeData(data[i].children);
          }
        }
      }
    },
    data () {
      return {
        rules: {
          uid: [{ required: true, message: '必填', trigger: 'blur' }],
          name: [{ required: true, message: '必填', trigger: 'blur' }]
        },
        uid: '',
        name: '',
        mobileNumber: '',
        formData: {},
        roleGroupList: [],
        deptList: [],
        deptId: 0,
        props: {
          value: 'id',
          label: 'name',
          children: 'children'
          // disabled:true
        }
      };
    },
    created () {
      this.getDeptList();
      this.getRoleGroupList();
      if (this.$route.params.formData != null) {
        this.formData = Object.assign({}, this.$route.params.formData);
        if (this.formData.b2bDept == null) {
          this.$set(this.formData, 'b2bDept', {id: 0});
        }
        this.deptId = this.formData.b2bDept.id;
      } else {
        this.formData = Object.assign({}, this.$store.state.B2BCustomersModule.formData);
      }
    }
  };
</script>
<style scoped>
  .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }

  .titleClass {
    padding: 10px 0px 1px 10px;
    background-color: #DCDCDC;
  }

  .customer-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .b2bCustomer-toolbar .formLabel {
    font-size: 12px;
    display: inline-block;
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

  .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 0px;
  }

  .buttonClass {
    padding: 10px 120px 0px 120px;
    margin-top: 40px;
    background-color: #ffd60c;
    color: #0b0e0f;
    border-radius: 8px;
  }
</style>
