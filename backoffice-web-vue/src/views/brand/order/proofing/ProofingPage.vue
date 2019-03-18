<template>
  <div class="animated fadeIn content">
    <el-card>
      <proofing-toolbar @onSearch="onSearch"/>
      <proofing-search-result-list :page="page" @onDetails="onDetails"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('BrandProofingsModule');

  import ProofingToolbar from './toolbar/Toolbar';
  import ProofingSearchResultList from './list/SearchResultList';
  import ProofingForm from './form/ProofingForm';
  import ProofingDetailForm from './list/ProofingDetailForm';

  export default {
    name: 'ProofingPage',
    components: {
      ProofingToolbar,
      ProofingSearchResultList
    },
    computed: {
      ...mapGetters({
        page: 'page'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
        searchRequirementRef: 'searchRequirementRef',
      }),
      onSearch(requirementOrderRef) {
        console.log(requirementOrderRef);
        this.searchRequirementRef({requirementOrderRef});
      },
      onDetails(row) {
        console.log('onDetails: ' + JSON.stringify(row));
        this.fn.openSlider('查看打样订单明细', ProofingDetailForm, row);
      }
    },
    data() {
      return {
      }
    },
    created() {
      this.search('');
    }
  }
</script>
