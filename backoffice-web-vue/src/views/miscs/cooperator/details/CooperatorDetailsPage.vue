<template>
  <div class="animated fadeIn">
    <cooperator-info-page :itemData="itemData"></cooperator-info-page>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('CooperatorsModule');

  import CooperatorInfoPage from '@/views/miscs/cooperator/info/CooperatorInfoPage';

  export default {
    name: 'CooperatorDetailsPage',
    props: ['itemData'],
    components: {CooperatorInfoPage},
    methods: {
      ...mapActions({
      }),
    },
    computed: {
    },
    data () {
      return {}
    },
    created () {
    }
  }
</script>
