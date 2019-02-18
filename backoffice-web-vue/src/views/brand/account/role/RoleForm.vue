<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>角色</span>
      </div>
      <role-base-form ref="baseForm"
                      :slot-data="slotData"
                      :read-only="false"
                      :is-newly-created="isNewlyCreated">
      </role-base-form>
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

  const {mapActions} = createNamespacedHelpers('BrandRolesModule');

  import RoleBaseForm from './RoleBaseForm';

  export default {
    name: 'RoleForm',
    components: {RoleBaseForm},
    props: ['slotData'],
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
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
        let request = this.$http.post;
        if (!this.isNewlyCreated) {
          request = this.$http.put;
        }
        const result = await request('/djbrand/role', this.slotData);
        if (result['errors']) {
          this.$message.error('保存失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$message.success('保存成功');
        this.refresh();
        this.fn.closeSlider(true);
      }
    },
    data() {
      return {};
    }
  };
</script>
