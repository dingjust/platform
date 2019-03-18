<template>
  <div>
    <quote_form :read-only="readOnly"></quote_form>
  </div>
</template>

<script>
  import {
    QuoteForm
  } from "@/views/shared/";

  export default {
    name: 'ShowQuoteForm',
    props: ['slotData', 'readOnly'],
    components: {
      QuoteForm
    },
    mixins: [],
    computed: {},
    methods: {
    },
    data() {
      return {}
    },
    created() {
    }
  }
</script>
