<template>
  <div>
    <div class="el-progress-bar__outer" :style="{height: strokeWidth + 'px'}">
      <template v-for="(item,index) in divisionNum">
        <div class="el-progress-bar__inner" :style="getBarStyle(index)">
        </div>
      </template>
    </div>
  </div>
</template>

<script>
  export default {
    name: "WarningProgress",
    props: {
      divisionNum: {
        type: Number,
        default: 5,
      },
      remainDay: {
        type: Number,
        default: 0,
        required: true,
        validator: val => val <= 5
      },
      strokeWidth: {
        type: Number,
        default: 6
      },
      remainColor: {
        type: String,
        default: '#7AED8F'
      },
      warningColor: {
        type: String,
        default: '#FF6666'
      }
    },
    components: {},
    computed: {
      barStyle() {
        const style = {};
        style.width = this.remainDay + '%';
        style.backgroundColor = 'red';
        return style;
      },
    },
    methods: {
      getBarStyle(index) {
        const style = {};
        style.width = 100 / this.divisionNum - 0.5 + '%';
        style.borderRadius = '0px';
        style.left = index * 20 + '%';
        if (index + 1 <= this.divisionNum - this.remainDay) {
          style.backgroundColor = this.warningColor;
        } else {
          style.backgroundColor = this.remainColor;
        }
        if (index == this.divisionNum - 1) {
          style.width = 100 / this.divisionNum + '%';
        }
        return style;
      }
    },
    data() {
      return {};
    },
    created() {}
  };

</script>
<style>

</style>
