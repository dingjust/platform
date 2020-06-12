<template>
  <div>

  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';


  const {
    mapMutations
  } = createNamespacedHelpers('ApparelProductsModule');

  export default {
    name: 'ProductSelect',
    props: ["page"],
    computed: {},
    components: {
      // ApparelProductDetailsPage
    },
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
        setQueryFormData: 'queryFormData'
      }),
    },
    data() {
      return {
      }
    }
  }

</script>
<style>

</style>
