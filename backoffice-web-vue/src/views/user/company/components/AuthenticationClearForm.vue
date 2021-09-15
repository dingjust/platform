<template>
  <div class="basic-row">
    <el-row style="margin-bottom: 10px">
      <h6 class="form-h">公司编号：{{clearRow.uid}}</h6>
    </el-row>
    <el-row style="margin-bottom: 10px">
      <h6 class="form-h">公司名称：{{clearRow.name}}</h6>
    </el-row>
    <el-row style="margin-bottom: 10px">
      <h6 class="form-h" >认证状态：
        <span :class="approvalStatus ? 'approval-color' : ''">{{getEnum('AuthApprovalStatus', approvalStatus)}}</span>
        <span v-if="clearRow.approvalType" class="approval-color"> ({{getEnum('ApprovalType', clearRow.approvalType)}})</span>
      </h6>
    </el-row>
    <el-divider></el-divider>
    <el-row type="flex">
      <el-radio label="DELETE" v-model="selection">{{options.DELETE}}</el-radio>
    </el-row>
    <el-row type="flex">
      <el-radio label="ENTERPRISE" v-model="selection">{{options.ENTERPRISE}}</el-radio>
    </el-row>
    <collapse-transition>
      <div class="collapse-wrap" v-show="showComSelection">
        <slot>
          <div class="basic-row">
            <h6>是否强制清除，已经认证的公司必须强制清除</h6>
            <el-radio-group v-model="enterpriseData.forceClean">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false" :disabled="approvalStatus === 'approved'">否</el-radio>
            </el-radio-group>
            <h6>是否重新生成customerId</h6>
            <el-radio-group v-model="enterpriseData.recreateCustomerId">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
          </div>
        </slot>
      </div> 
    </collapse-transition>
    <el-row type="flex">
      <el-radio label="PERSON" v-model="selection">{{options.PERSON}}</el-radio>
    </el-row>
    <collapse-transition>
      <div class="collapse-wrap" v-show="showPerSelection">
        <slot>
          <div class="basic-row">
            <h6>是否强制清除，已经认证的公司必须强制清除</h6>
            <el-radio-group v-model="personData.forceClean">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false" :disabled="approvalStatus === 'approved'">否</el-radio>
            </el-radio-group>
          </div>
        </slot>
      </div> 
    </collapse-transition>
    <el-row type="flex" justify="end">
      <el-button @click="onCancel">取消</el-button>
      <el-button type="primary" @click="onConfirm">清除</el-button>
    </el-row>
  </div>
</template>

<script>
import CollapseTransition from './collapseTransition.js';
export default {
  name: 'AuthenticationClearForm',
  props: ['clearRow'],
  components: {
    CollapseTransition
  },
  computed: {
    approvalStatus: function () {
      if (!this.clearRow.approvalStatus) {
        return 'unapproved';
      }
      return this.clearRow.approvalStatus;
    },
    confirmText: function () {
      return '是否对公司编号：' + this.clearRow.uid + ', ' + this.clearRow.name + ' 执行 ' + this.options[this.selection] + ' 操作？'
    }
  },
  data () {
    return {
      selection: '',
      showComSelection: false,
      showPerSelection: false,
      enterpriseData: {
        forceClean: false,
        recreateCustomerId: false
      },
      personData: {
        forceClean: false
      },
      options: {
        DELETE: '删除认证',
        ENTERPRISE: '清除企业认证',
        PERSON: '清除个人认证'
      }
    }
  },
  methods: {
    onCancel () {
      this.$emit('onCancel');
    },
    onConfirm () {
      if (this.selection === '') {
        this.$message.error('请先选择要清除的认证类型！');
        return;
      }

      const h = this.$createElement;
      this.$msgbox({
        title: '提示',
        message: h('div', {style: 'display: flex'}, [
          h('div', null , [h('i', {class: 'el-icon-warning', style: 'color: #e6a23c;font-size: 24px'})]),
          this.selection === 'ENTERPRISE' ? h('div', {style: 'margin-left: 11px'}, [
            h('p', {style: 'margin-top: 3px'}, this.confirmText),
            this.enterpriseData.forceClean ? h('p', {style: 'margin-left: 20px'}, '强制清除 ✔️') 
                                            : h('p', {style: 'margin-left: 20px'}, '强制清除 ❌'),
            this.enterpriseData.recreateCustomerId ? h('p', {style: 'margin-left: 20px'}, '重新生成customerId ✔️') 
                                                    : h('p', {style: 'margin-left: 20px'}, '重新生成customerId ❌')
          ]) :  (
            this.selection === 'PERSON' ? h('div', {style: 'margin-left: 11px'}, [
            h('p', {style: 'margin-top: 3px'}, this.confirmText),
            this.enterpriseData.forceClean ? h('p', {style: 'margin-left: 20px'}, '强制清除 ✔️') 
                                            : h('p', {style: 'margin-left: 20px'}, '强制清除 ❌')
            ]) :
            h('div', {style: 'margin-left: 11px'}, [
            h('p', {style: 'margin-top: 3px'}, this.confirmText)
          ])
          )
        ]),
        showCancelButton: true,
        confirmButtonText: '确定',
        cancelButtonText: '取消',
      }).then(() => {
        switch (this.selection) {
          case 'DELETE':
            this.deleteAuth();
            break;
          case 'ENTERPRISE':
            this.clearEnterpriseAuth();
            break;
          case 'PERSON':
            this.clearPersonAuth();
            break;
          default:
            this.$message.warning('请先选择要清除的认证类型');
            break;
        }
      })
    },
    async deleteAuth () {
      const id = this.clearRow.id;

      const url = this.apis().deleteAuth(id);
      const result = await this.$http.post(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message ? result['errors'][0].message : '操作失败，请稍后再试');
        return;
      }

      if (result.code === 1) {
        this.$message.success('操作成功！');
        this.$emit('callback');
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('操作失败！');
      }
    },
    async clearEnterpriseAuth () {
      const uid = this.clearRow.uid;

      const url = this.apis().clearEnterpriseAuth(uid);
      const result = await this.$http.post(url, {}, {
        forceClean: this.enterpriseData.forceClean,
        recreateCustomerId: this.enterpriseData.recreateCustomerId
      });

      if (result['errors']) {
        this.$message.error(result['errors'][0].message ? result['errors'][0].message : '操作失败，请稍后再试');
        return;
      }
      
      if (result.code === 1) {
        this.$message.success('操作成功！');
        this.$emit('callback');
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('操作失败！');
      }
    },
    async clearPersonAuth () {
      const contactUid = this.clearRow.contactUid;

      const url = this.apis().clearPersonAuth(contactUid);
      const result = await this.$http.post(url, {}, {
        forceClean: this.personData.forceClean
      });

      if (result['errors']) {
        this.$message.error(result['errors'][0].message ? result['errors'][0].message : '操作失败，请稍后再试');
        return;
      }
      
      if (result.code === 1) {
        this.$message.success('操作成功！');
        this.$emit('callback');
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('操作失败！');
      }
    }
  },
  watch: {
    'selection': function (nval, ovla) {
      if (nval && nval === 'ENTERPRISE') {
        this.showComSelection = true;
        this.showPerSelection = false;
      } else if (nval && nval === 'PERSON') {
        this.showComSelection = false;
        this.showPerSelection = true;
      } else {
        this.showComSelection = false;
        this.showComSelection = false;
      }
    }
  },
  mounted () {
    if (this.approvalStatus) {
      this.enterpriseData.forceClean = true;
      this.personData.forceClean = true;
    }
  }
}
</script>

<style scoped>
  /deep/ .el-divider--horizontal {
    margin: 12px 0;
  }

  .basic-row {
    margin-left: 25px;
  }

  .form-h {
    margin: 0px;
  }

  .approval-color {
    color: #F56C6C
  }
</style>