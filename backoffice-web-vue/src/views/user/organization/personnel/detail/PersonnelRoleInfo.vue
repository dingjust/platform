<template>
  <div class="personnel-role-info-container">
    <el-row type="flex" justify="center" align="middel" :gutter="50">
      <el-col :span="16">
        <div class="personnel-role-info-main">
          <el-table ref="resultTable" :data="formData.b2bRoleGroupList" style="width: 100%" row-key="id" 
                    @row-click="rowClick" @selection-change="selectionChange">
            <el-table-column type="selection" width="55"></el-table-column>
            <el-table-column label="角色名称" prop="name"></el-table-column>
            <el-table-column label="角色描述" prop="name"></el-table-column>
          </el-table>
        </div>
      </el-col>
      <el-col :span="4">
        <Authorized :permission="['COMPANY_CUSTOMER_MODIFY']">
          <el-button class="personnel-role-btn" @click="dialogVisible = !dialogVisible">添加</el-button>
        </Authorized>
        <Authorized :permission="['COMPANY_CUSTOMER_MODIFY']">
          <el-button class="personnel-role-btn1" @click="onDelete">删除</el-button>
        </Authorized>
      </el-col>
    </el-row>
    <el-dialog :visible.sync="dialogVisible" width="50%" append-to-body :close-on-click-modal="false" :show-close="false">
      <role-select-list v-if="dialogVisible" :originData="formData.b2bRoleGroupList" 
                        @onAppendRole="onAppendRole" @onCancel="onCancel"/>
    </el-dialog>
  </div>
</template>

<script>
import { RoleSelectList } from '@/views/user/organization'
export default {
  name: 'PersonnelRoleInfo',
  props: ['formData'],
  components: {
    RoleSelectList
  },
  computed: {
    tableHeight: function () {
      if (this.formData.b2bRoleGroupList && this.formData.b2bRoleGroupList.length === 1) {
        return 108;
      }
    }
  },
  methods: {
    selectionChange (val) {
      this.selectData = val;
    },
    rowClick (row, column, event) {
      this.$refs.resultTable.toggleRowSelection(row);
    },
    onDelete () {
      let index;
      if (this.selectData != '' && this.selectData.length > 0) {
        this.selectData.forEach(item => {
          index = this.formData.b2bRoleGroupList.findIndex(val => val.id == item.id);
          if (index >= 0) {
            this.formData.b2bRoleGroupList.splice(index, 1);
          }
        })
      }
      this.$emit('onSave');
    },
    onAppendRole (data) {
      // let val= Object.assign([],this.formData.b2bRoleGroupList);

      // data.forEach(item => {
      //   val.push(item);
      // });
      // this.$set(this.formData,'b2bRoleGroupList',val);
      this.formData.b2bRoleGroupList.push.apply(this.formData.b2bRoleGroupList, data);
      this.dialogVisible = false;
      this.$emit('onSave');
    },
    onCancel () {
      this.dialogVisible = false;
    }
  },
  data () {
    return {
      selectData: '',
      dialogVisible: false
    }
  },
  created () {

  }  
}
</script>

<style scoped>
  .personnel-role-info-main {
    border: 2px solid #E5E5E5;
    height: 350px;
    overflow-x: auto;
  }

  .personnel-role-btn {
    margin-left: 10px;
    background-color: #ffd60c;
    color: #000;
    width: 80px;
    height: 35px;
    border-radius: 6px;
    margin-bottom: 10px;
  }

  .personnel-role-btn1 {
    background-color: #FFFFFF;
    color: #000;
    width: 80px;
    height: 35px;
    border-radius: 6px;
    margin-bottom: 10px;
  }

  .personnel-role-info-container >>> .el-button+.el-button {
    margin-left: 0px;
  }

  .personnel-role-info-container >>> .el-table__row>td {
    border: none;
  }

  .personnel-role-info-container >>> .el-table::before {
    height: 0px;
  }

  /* 修改dialog样式 */
  /deep/ .el-dialog__header {
    padding: 0px;
  }
  /deep/ .el-dialog__body {
    padding: 20px 20px;
  }
  /deep/ .el-dialog__body {
    padding-top: 20px !important;
  }
</style>