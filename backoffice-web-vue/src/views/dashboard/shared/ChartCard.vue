<template>
  <div class="animated fadeIn dashboard-card">
    <div ref="chart" class="dashboard-chart" />
  </div>
</template>

<script>
import * as echarts from "echarts/core";
import {
  ToolboxComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent,
} from "echarts/components";
import { BarChart, LineChart } from "echarts/charts";
import { CanvasRenderer } from "echarts/renderers";

// var colors = ['#5793f3', '#d14a61', '#675bba'];

echarts.use([
  ToolboxComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent,
  BarChart,
  LineChart,
  CanvasRenderer,
]);

export default {
  name: "ChartCard",
  components: {},
  computed: {},
  mounted() {
    this.initCharts();
  },
  methods: {
    initCharts() {
      let that = this;
      const chart = this.$refs.chart;
      if (chart) {
        const myChart = echarts.init(chart);
        const option = {
          tooltip: {
            trigger: "axis",
            axisPointer: {
              type: "cross",
              crossStyle: {
                color: "#999999",
              },
            },
          },
          toolbox: {
            feature: {
              dataView: {
                show: true,
                readOnly: false,
              },
              magicType: {
                show: true,
                type: ["line", "bar"],
              },
              restore: {
                show: true,
              },
              saveAsImage: {
                show: true,
              },
            },
          },
          legend: {
            data: ["延期天数", "出货率"],
          },
          xAxis: [
            {
              type: "category",
              data: [
                "1月",
                "2月",
                "3月",
                "4月",
                "5月",
                "6月",
                "7月",
                "8月",
                "9月",
                "10月",
                "11月",
                "12月",
              ],
              axisPointer: {
                type: "shadow",
              },
              axisLine: {
                lineStyle: {
                  color: "#999999",
                },
              },
            },
          ],
          yAxis: [
            {
              type: "value",
              name: "延期天数",
              min: 0,
              max: 12,
              interval: 2,
              axisLabel: {
                formatter: "{value}",
              },
              axisLine: {
                lineStyle: {
                  color: "#999999",
                },
              },
            },
            {
              type: "value",
              name: "出货率",
              min: 0,
              max: 1.2,
              interval: 0.2,
              axisLabel: {
                formatter: "{value}",
              },
              axisLine: {
                lineStyle: {
                  color: "#999999",
                },
              },
            },
          ],
          series: [
            {
              name: "延期天数",
              type: "bar",
              data: [10, 8, 4, 3, 2, 12, 10, 8, 2, 2, 1, 6],
              itemStyle: {
                color: "#FFE373",
              },
            },
            {
              name: "出货率",
              type: "line",
              yAxisIndex: 1,
              data: [
                0.8,
                0.9,
                1.1,
                0.8,
                0.9,
                1.1,
                1.2,
                1.0,
                0.8,
                0.75,
                0.7,
                0.2,
              ],
              itemStyle: {
                color: "#FFA403",
              },
            },
          ],
        };
        myChart.setOption(option);
        window.addEventListener("resize", function () {
          that.$nextTick(() => {
            myChart.resize();
          });
        });
      }
    },
  },
  data() {
    return {};
  },
  created() {},
};
</script>
<style>
.dashboard-chart {
  width: 100%;
  height: 250px;
  display: flex;
  justify-content: center;
}
</style>
