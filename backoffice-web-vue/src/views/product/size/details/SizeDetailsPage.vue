<template>
  <div class="animated fadeIn">
<!--    <div class="pt-2"></div>-->
    <size-form ref="form" :slot-data="slotData" :read-only="!isNewlyCreated"/>
<!--    <div class="pt-2"></div>-->
    <size-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('SizesModule');

  import SizeFormToolbar from '../toolbar/SizeFormToolbar';
  import SizeForm from '../form/SizeForm';

  export default {
    name: 'SizeDetailsPage',
    props: ['slotData'],
    components: {SizeFormToolbar, SizeForm},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onSubmit () {
        if (this.$refs['form'].validate()) {
          if (this.isNewlyCreated) {
            this._onSubmit();
          } else {
            // this._updateSize();
            this.$emit('_updateSize', this.slotData);
          }
        }
      },
      onCancel () {
        // this.fn.closeSlider();
        this.$emit('sizeDetailsPageVisibleTurn');
      },
      async _onSubmit () {
        let formData = this.slotData;

        const url = this.apis().createSize();
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('尺码创建成功');
        this.$set(this.slotData, 'code', result);
        this.refresh(this.apis().getSizes());
        // this.fn.closeSlider(true);
        this.$emit('onSearch');
        this.$emit('sizeDetailsPageVisibleTurn');
      },
      // async _updateSize () {
      //   let formData = this.slotData;
      //
      //   const url = this.apis().updateSize(formData.code);
      //   const result = await this.$http.put(url, formData);
      //   if (result['errors']) {
      //     this.$message.error(result['errors'][0].message);
      //     return;
      //   }
      //
      //   this.$message.success('尺码修改成功');
      //   this.$set(this.slotData, 'code', result);
      //   this.refresh(this.apis().getSizes());
      //   // this.fn.closeSlider(true);
      //   this.$emit('onSearch')
      //   this.$emit('sizeDetailsPageVisibleTurn');
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
