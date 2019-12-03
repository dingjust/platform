<template>
  <div class="animated fadeIn">
      <category-form ref="form" :slot-data="slotData" :operationType="operationType" :read-only="isNewlyCreated" @operationTypeTurn="operationTypeTurn"/>
  </div>
</template>

<script>
  import CategoryGroupMixin from '@/mixins/commerce/CategoryGroupMixin';
  import CategoryForm from '../form/CategoryForm';

  export default {
    name: 'CategoryDetailsPage',
    components: {CategoryForm},
    mixins: [CategoryGroupMixin],
    props: ['slotData', 'readOnly', 'operationType', 'CategoryDetailsPageVisible'],
    methods: {
      operationTypeTurn () {
        this.$emit('operationTypeTurn');
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data () {
      return {
        rules: {
          code: [{required: true, message: '必填', trigger: 'blur'}],
          name: [{required: true, message: '必填', trigger: 'blur'}]
        }
      };
    }
  };
</script>
