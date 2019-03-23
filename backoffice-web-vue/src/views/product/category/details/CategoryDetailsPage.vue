<template>
  <div class="animated fadeIn">
      <category-form ref="form" :slot-data="slotData" :read-only="isNewlyCreated"/>
  </div>
</template>

<script>
  import CategoryGroupMixin from '@/mixins/commerce/CategoryGroupMixin';
  import CategoryForm from "@/views/product/category/form/CategoryForm";

  export default {
    name: 'CategoryDetailsPage',
    components: {CategoryForm},
    mixins: [CategoryGroupMixin],
    props: ['slotData', 'readOnly'],
    methods: {

    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {
        rules: {
          code: [{required: true, message: '必填', trigger: 'blur'}],
          name: [{required: true, message: '必填', trigger: 'blur'}]
        },
      };
    }
  };
</script>
