<template>
  <div class="animated fadeIn">
    <role-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
    <div class="pt-2"></div>
    <role-form ref="form" :slot-data="slotData" :read-only="!isNewlyCreated"/>
    <div class="pt-2"></div>
    <role-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('RolesModule');

  import RoleFormToolbar from '../toolbar/RoleFormToolbar';
  import RoleForm from '../form/RoleForm';

  export default {
    name: 'RoleDetailsPage',
    props: ['slotData'],
    components: {RoleFormToolbar, RoleForm},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onSubmit() {
        if (this.$refs['form'].validate()) {
          this._onSubmit();
        }
      },
      onCancel() {
        this.fn.closeSlider();
      },
      async _onSubmit() {
        let formData = this.slotData;

        const url = this.apis().createRole();
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('品牌创建成功');
        this.$set(this.slotData, 'code', result);
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
      return {}
    }
  }
</script>
