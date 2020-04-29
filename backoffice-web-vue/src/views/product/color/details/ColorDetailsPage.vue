<template>
  <div class="animated fadeIn">
<!--    <div class="pt-2"></div>-->
    <color-form ref="form" :slot-data="slotData" :read-only="!isNewlyCreated"/>
<!--    <div class="pt-2"></div>-->
    <color-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('ColorsModule');

  import ColorFormToolbar from '../toolbar/ColorFormToolbar';
  import ColorForm from '../form/ColorForm';

  export default {
    name: 'ColorDetailsPage',
    props: ['slotData'],
    components: {ColorFormToolbar, ColorForm},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onSubmit () {
        if (this.$refs['form'].validate()) {
          if (this.isNewlyCreated) {
            this._onSubmit();
          } else {
            // this._updateColor();
            this.$emit('_updateColor', this.slotData);
          }
        }
      },
      onCancel () {
        // this.fn.closeSlider();
        this.$emit('colorDetailsPageVisibleTurn');
      },
      async _onSubmit () {
        let formData = this.slotData;

        const url = this.apis().createColor();
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('保存成功');
        this.$set(this.slotData, 'code', result);
        this.refresh(this.apis().getColors());
        // this.fn.closeSlider(true);
        this.$emit('onSearch');
        this.$emit('colorDetailsPageVisibleTurn');
      },
      // async _updateColor () {
      //   let formData = this.slotData;
      //
      //   const url = this.apis().updateColor(formData.code);
      //   const result = await this.$http.put(url, formData);
      //   if (result['errors']) {
      //     this.$message.error(result['errors'][0].message);
      //     return;
      //   }
      //
      //   this.$message.success('修改成功');
      //   this.$set(this.slotData, 'code', result);
      //   this.refresh(this.apis().getColors());
      //   // this.fn.closeSlider(true);
      //   this.$emit('onSearch');
      //   this.$emit('colorDetailsPageVisibleTurn');
      // }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data () {
      return {}
    }
  }
</script>
