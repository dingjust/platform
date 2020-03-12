<template>
  <div>
    <el-row>
      <div class="customer-list-title">
        <h6>邀请员工</h6>
      </div>
    </el-row>
    <div class="pt-2"></div>
    <el-row type="flex" justify="center">
      <el-form ref="form" :model="formData" :rules="rules" :hide-required-asterisk="true" :validate-on-rule-change="false">
        <el-form-item prop="contactPhone">
          <template slot="label">
            <h6 class="titleTextClass">账号<span style="color: #F56C6C">*</span></h6>
          </template>
          <el-row type="flex">
            <el-input placeholder="请填写手机号" v-model="formData.contactPhone" style="width: 250px"></el-input>
          </el-row>
        </el-form-item>
        <el-form-item prop="deptId">
          <template slot="label">
            <h6 class="titleTextClass">所属部门<span style="color: #F56C6C">*</span></h6>
          </template>
          <el-row type="flex">
            <!-- <el-select v-model="value" placeholder="请选择所属部门">
              <el-option
                v-for="item in deptList[0].children"
                :key="item.id"
                :label="item.name"
                :value="item.id">
              </el-option>
            </el-select> -->
            <el-tree-select :props="props"
                            :placeholder="'请选择部门'"
                            :options="deptList[0].children"
                            @getValue="selectDept">
            </el-tree-select>
          </el-row>
        </el-form-item>
        <el-form-item prop="role">
          <template slot="label">
            <h6 class="titleTextClass">角色</h6>
          </template>
          <el-row type="flex">
            <el-select v-model="value" placeholder="请选择角色">
              <el-option
                v-for="item in roleGroupList[0].children"
                :key="item.id"
                :label="item.name"
                :value="item.id">
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
    import {createNamespacedHelpers} from 'vuex';
    import ElTreeSelect from '../tree/treeSelect';

    const {mapGetters} = createNamespacedHelpers('B2BCustomersModule');
    export default {
      name: 'B2BCustomerInviteDialog',
      props: [],
      components: { ElTreeSelect },
      computed: {
        ...mapGetters({
          deptList: 'deptList',
          roleGroupList: 'roleGroupList'
        })
      },
      data () {
        var validatePass = (rule, value, callback) => {
          if (this.formData.deptId == null || this.formData.deptId == '') {
            callback(new Error('请选择部门'));
          } else {
            callback();
          }
        };
        return {
          rules: {
            contactPhone: [{required: true, message: '必填', trigger: 'blur'}],
            deptId: [{ validator: validatePass, trigger: ['blur', 'change'] }]
          },
          formData: {
            contactPhone: '',
            deptId: ''
          },
          dept: '',
          props: {
            value: 'id',
            label: 'name',
            children: 'children'
            // disabled:true
          },
          value: ''
        }
      },
      methods: {
        selectDept (val) {
          this.formData.deptId = val;
        },
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
      },
      watch: {
        'rules': function (n, o) {
          if (n) {
            this.$nextTick(() => {
              this.$refs.form.clearValidate();
            })
          }
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
