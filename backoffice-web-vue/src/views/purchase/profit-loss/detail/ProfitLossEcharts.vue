<!--
* @Description: 盈亏分析详情图表
* @Date 2021/03/26 14:44
* @Author L.G.Y
-->
<template>
  <div>
    <div id="main" :style="'width: 100%;height:' + echartHeight + 'px'"></div>
  </div>
</template>

<script>
// import * as echarts from "echarts/core";
// import {
//   TooltipComponent,
//   GridComponent,
//   LegendComponent,
// } from "echarts/components";
// import { BarChart } from "echarts/charts";
// import { CanvasRenderer } from "echarts/renderers";

// echarts.use([
//   TooltipComponent,
//   GridComponent,
//   LegendComponent,
//   BarChart,
//   CanvasRenderer,
// ]);

export default {
  name: "ProfitLossEcharts",
  props: ["detail"],
  data() {
    return {
      echartHeight: 100,
      echartData: [],
    };
  },
  methods: {
    initData() {
      if (this.detail && this.detail.entries) {
        this.echartHeight += 60 * this.detail.entries.length;

        this.echartData = this.echartData
          .concat(
            this.detail.entries.map((item) => {
              return {
                title: item.skuID + " / " + this.colorName(item),
                totalProfitLossAmount: item.totalProfitLossAmount,
                totalContractAmount: item.totalContractAmount,
                totalAmount: -item.totalAmount,
              };
            })
          )
          .reverse();
      }
    },
    colorName(row) {
      if (row.colors) {
        let str = "";
        row.colors.forEach((item) => {
          str += item.name + "， ";
        });

        return str.substring(0, str.length - 2);
      }
    },
    initEchart() {
      let chartDom = document.getElementById("main");
      let myChart = echarts.init(chartDom);

      let option;

      option = {
        tooltip: {
          trigger: "axis",
          axisPointer: {
            // 坐标轴指示器，坐标轴触发有效
            type: "shadow", // 默认为直线，可选为：'line' | 'shadow'
          },
        },
        legend: {
          data: ["合同金额", "总金额（成本）", "总盈亏"],
        },
        grid: {
          left: "3%",
          right: "4%",
          bottom: "3%",
          containLabel: true,
        },
        xAxis: [
          {
            type: "value",
          },
        ],
        yAxis: [
          {
            type: "category",
            axisTick: {
              show: false,
            },
            data: this.echartData.map((item) => item.title),
          },
        ],
        series: [
          {
            name: "合同金额",
            type: "bar",
            stack: "总量",
            label: {
              show: true,
            },
            emphasis: {
              focus: "series",
            },
            data: this.echartData.map((item) => item.totalContractAmount),
          },
          {
            name: "总金额（成本）",
            type: "bar",
            stack: "总量",
            label: {
              show: true,
              position: "left",
            },
            emphasis: {
              focus: "series",
            },
            data: this.echartData.map((item) => item.totalAmount),
          },
          {
            name: "总盈亏",
            type: "bar",
            label: {
              show: true,
              position: "inside",
            },
            emphasis: {
              focus: "series",
            },
            data: this.echartData.map((item) => item.totalProfitLossAmount),
          },
        ],
      };

      option && myChart.setOption(option);

      let that = this;
      window.addEventListener("resize", function () {
        that.$nextTick(() => {
          myChart.resize();
        });
      });
    },
  },
  mounted() {
    this.initData();

    this.$nextTick(() => {
      this.initEchart();
    });
  },
};
</script>

<style scoped>
</style>
