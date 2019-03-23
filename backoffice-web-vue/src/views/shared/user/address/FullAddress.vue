<template>
  <div>{{address}}</div>
</template>

<script>
  export default {
    name: 'FullAddress',
    props: ['slotData'],
    mixins: [],
    computed: {
      address: function () {
        const region = this.slotData.region;
        const city = this.slotData.city;
        const cityDistrict = this.slotData.cityDistrict;
        const line1 = this.slotData.line1;

        // 省份和城市相同的情况
        if (region.name === city.name) {
          return region.name + cityDistrict.name + line1;
        }

        return region.name + city.name + cityDistrict.name + line1;
      }
    },
    methods: {},
    data() {
      return {}
    },
    created() {
    }
  }
</script>
