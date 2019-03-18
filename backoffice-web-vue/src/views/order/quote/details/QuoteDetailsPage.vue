<template>
  <div class="animated fadeIn">
    <quote-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
    <div class="pt-2"></div>
    <quote-form :slot-data="slotData" :read-only="!isNewlyCreated"/>
    <div class="pt-2"></div>
    <quote-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('BrandQuotesModule');

  import QuoteFormToolbar from "../toolbar/QuoteFormToolbar";
  import QuoteForm from '../form/QuoteForm';

  export default {
    name: 'QuoteDetailsPage',
    props: ['slotData', 'readOnly'],
    components: {QuoteFormToolbar, QuoteForm},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
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
