<template>
  <div class="animated fadeIn">
    <user-group-form-toolbar :read-only="isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
    <div class="pt-2"></div>
    <user-group-form ref="form" :slot-data="slotData" :read-only="isNewlyCreated"/>
    <div class="pt-2"></div>
    <user-group-form-toolbar :read-only="isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('UserGroupsModule');

  import UserGroupFormToolbar from '../toolbar/UserGroupFormToolbar';
  import UserGroupForm from '../form/UserGroupForm';

  export default {
    name: 'UserGroupDetailsPage',
    props: ['slotData'],
    components: {UserGroupFormToolbar, UserGroupForm},
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

        let url = this.apis().createUserGroup();
        let result = {};
        if(formData.id&&formData.id!=null&&formData.id!=''){
          url = this.apis().updateUserGroup();
          result = await this.$http.put(url, formData);
        }else {
          result = await this.$http.post(url, formData);
        }

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('保存成功');
        this.$set(this.slotData, 'code', result);
        const searchUrl = this.apis().getUserGroups();
        this.refresh({searchUrl});
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
