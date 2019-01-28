<style type="scss">
  .height-70 {
    height: 70px;
  }
</style>
<template>
  <div class="animated fadeIn content">
    <b-row>
      <b-col sm="6" lg="3">
        <b-card no-body class="bg-info">
          <b-card-body class="pb-0">
            <b-dropdown class="float-right" variant="transparent p-0" right>
              <template slot="button-content">
                <i class="icon-settings"></i>
              </template>
              <b-dropdown-item>更多...</b-dropdown-item>
            </b-dropdown>
            <h4 class="mb-0">1000</h4>
            <p>产品</p>
          </b-card-body>
          <product-card-line-chart class="chart-wrapper px-3 height-70" height="70"/>
        </b-card>
      </b-col>
      <b-col sm="6" lg="3">
        <b-card no-body class="bg-info">
          <b-card-body class="pb-0">
            <b-dropdown class="float-right" variant="transparent p-0" right>
              <template slot="button-content">
                <i class="icon-settings"></i>
              </template>
              <b-dropdown-item>更多...</b-dropdown-item>
            </b-dropdown>
            <h4 class="mb-0">5000</h4>
            <p>订单</p>
          </b-card-body>
          <order-card-line-chart class="chart-wrapper px-3 height-70" height="70"/>
        </b-card>
      </b-col>
      <b-col sm="6" lg="3">
        <b-card no-body class="bg-info">
          <b-card-body class="pb-0">
            <b-dropdown class="float-right" variant="transparent p-0" right>
              <template slot="button-content">
                <i class="icon-settings"></i>
              </template>
              <b-dropdown-item>更多...</b-dropdown-item>
            </b-dropdown>
            <h4 class="mb-0">200</h4>
            <p>品牌</p>
          </b-card-body>
          <brand-card-line-chart class="chart-wrapper px-3 height-70" height="70"/>
        </b-card>
      </b-col>
      <b-col sm="6" lg="3">
        <b-card no-body class="bg-info">
          <b-card-body class="pb-0">
            <b-dropdown class="float-right" variant="transparent p-0" right>
              <template slot="button-content">
                <i class="icon-settings"></i>
              </template>
              <b-dropdown-item>更多...</b-dropdown-item>
            </b-dropdown>
            <h4 class="mb-0">1000</h4>
            <p>工厂</p>
          </b-card-body>
          <factory-card-line-chart class="chart-wrapper px-3 height-70" height="70"/>
        </b-card>
      </b-col>
    </b-row>

    <b-card>
      <b-row>
        <b-col sm="5">
          <h4 class="card-title mb-0">流量统计</h4>
          <div class="small text-muted">2018年8月</div>
        </b-col>
        <b-col sm="7" class="d-none d-md-block">
          <b-button-toolbar class="float-right" aria-label="Toolbar with buttons group">
            <b-form-radio-group class="mr-3" id="radiosBtn" buttons button-variant="outline-secondary"
                                v-model="trafficDimension" name="radiosBtn">
              <b-form-radio class="mx-0" value="Day">Day</b-form-radio>
              <b-form-radio class="mx-0" value="Month">Month</b-form-radio>
              <b-form-radio class="mx-0" value="Year">Year</b-form-radio>
            </b-form-radio-group>
          </b-button-toolbar>
        </b-col>
      </b-row>
      <traffic-statistics-chart class="chart-wrapper" style="height:300px;margin-top:40px;" height="300"/>
      <div slot="footer">
        <ul>
          <li>
            <div class="text-muted">访问量</div>
            <strong>29.703 用户 (40%)</strong>
            <b-progress height={} class="progress-xs mt-2" :precision="1" variant="success" :value="40"></b-progress>
          </li>
          <li class="d-none d-md-table-cell">
            <div class="text-muted">独立访问量</div>
            <strong>24.093 用户 (20%)</strong>
            <b-progress height={} class="progress-xs mt-2" :precision="1" variant="info" :value="20"></b-progress>
          </li>
          <li>
            <div class="text-muted">页面浏览量</div>
            <strong>78.706 浏览量 (60%)</strong>
            <b-progress height={} class="progress-xs mt-2" :precision="1" variant="warning" :value="60"></b-progress>
          </li>
          <li class="d-none d-md-table-cell">
            <div class="text-muted">新增用户</div>
            <strong>22.123 用户 (80%)</strong>
            <b-progress height={} class="progress-xs mt-2" :precision="1" variant="danger" :value="80"></b-progress>
          </li>
          <li class="d-none d-md-table-cell">
            <div class="text-muted">弹跳率</div>
            <strong>40.15%</strong>
            <b-progress height={} class="progress-xs mt-2" :precision="1" :value="40"></b-progress>
          </li>
        </ul>
      </div>
    </b-card>
  </div>
</template>

<script>
  import ProductCardLineChart from './dashboard/ProductCardLineChart';
  import OrderCardLineChart from './dashboard/OrderCardLineChart';
  import BrandCardLineChart from './dashboard/BrandCardLineChart';
  import FactoryCardLineChart from './dashboard/FactoryCardLineChart';
  import TrafficStatisticsChart from './dashboard/TrafficStatisticsChart';

  export default {
    name: 'Dashboard',
    components: {
      ProductCardLineChart,
      OrderCardLineChart,
      BrandCardLineChart,
      FactoryCardLineChart,
      TrafficStatisticsChart
    },
    data() {
      return {
        trafficDimension: 'Month'
      }
    }
  }
</script>
