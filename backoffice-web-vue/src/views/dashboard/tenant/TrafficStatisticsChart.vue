<script>
  import {Line} from 'vue-chartjs';

  // const brandPrimary = '#20a8d8'
  const brandSuccess = '#4dbd74';
  const brandInfo = '#63c2de';
  const brandDanger = '#f86c6b';

  function convertHex(hex, opacity) {
    hex = hex.replace('#', '');
    const r = parseInt(hex.substring(0, 2), 16);
    const g = parseInt(hex.substring(2, 4), 16);
    const b = parseInt(hex.substring(4, 6), 16);

    return 'rgba(' + r + ',' + g + ',' + b + ',' + opacity / 100 + ')';
  }

  function random(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min)
  }

  export default {
    name: 'TrafficStatisticsChart',
    extends: Line,
    props: ['height'],
    mounted() {
      const elements = 31;
      let data1 = [];
      let data2 = [];
      let data3 = [];

      for (var i = 0; i < elements; i++) {
        data1.push(random(50, 200));
        data2.push(random(80, 100));
        data3.push(65);
      }
      this.renderChart({
          labels: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31'],
          datasets: [
            {
              label: '独立用户',
              backgroundColor: convertHex(brandInfo, 10),
              borderColor: brandInfo,
              pointHoverBackgroundColor: '#fff',
              borderWidth: 2,
              data: data1
            },
            {
              label: '用户',
              backgroundColor: 'transparent',
              borderColor: brandSuccess,
              pointHoverBackgroundColor: '#fff',
              borderWidth: 2,
              data: data2
            },
            {
              label: '新增用户',
              backgroundColor: 'transparent',
              borderColor: brandDanger,
              pointHoverBackgroundColor: '#fff',
              borderWidth: 1,
              borderDash: [8, 5],
              data: data3
            }
          ]
        },
        {
          maintainAspectRatio: false,
          legend: {
            display: false
          },
          scales: {
            xAxes: [{
              gridLines: {
                drawOnChartArea: false
              }
            }],
            yAxes: [{
              ticks: {
                beginAtZero: true,
                maxTicksLimit: 5,
                stepSize: Math.ceil(250 / 5),
                max: 250
              },
              gridLines: {
                display: true
              }
            }]
          },
          elements: {
            point: {
              radius: 0,
              hitRadius: 10,
              hoverRadius: 4,
              hoverBorderWidth: 3
            }
          }
        })
    }
  }
</script>
