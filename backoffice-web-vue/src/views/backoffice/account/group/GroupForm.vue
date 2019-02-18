<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>用户组</span>
      </div>
      <group-base-form ref="baseForm"
                       :slot-data="slotData"
                       :read-only="false"
                       :is-newly-created="isNewlyCreated">
      </group-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-row :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" size="mini" type="primary" @click="onSubmit">确定</el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" size="mini" @click="onCancel">取消</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('UserGroupsModule');

  import GroupBaseForm from './GroupBaseForm';

  export default {
    name: 'GroupForm',
    components: {GroupBaseForm},
    props: ['slotData'],
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onSubmit() {
        const baseForm = this.$refs['baseForm'];
        baseForm.validate(valid => {
          if (!valid) {
            return false;
          }

          this._onSubmit();

          return true;
        });
      },
      onCancel() {
        this.fn.closeSlider();
      },
      async _onSubmit() {
        const result = await this.$http.post('/djbackoffice/group', this.slotData);
        if (result['errors']) {
          this.$message.error('保存失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$message.success('保存成功');
        this.refresh();
        this.fn.closeSlider(true);
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {};
    }
  };
</script>
