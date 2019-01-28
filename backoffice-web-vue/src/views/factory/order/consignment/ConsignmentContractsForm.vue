<template>
  <div class="animated fadeIn">
    <ul>
      <li v-for="item in slotData.contracts"><a :href="item.url" target="_blank">{{item.name}}</a></li>
    </ul>
  </div>
</template>

<script>
  export default {
    name: "ConsignmentContractsForm",
    props: ["slotData"],
    methods: {},
    computed: {},
    data() {
      return {};
    }
  };
</script>
