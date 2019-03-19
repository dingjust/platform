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
            <h4 class="mb-0">{{product}}</h4>
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
            <h4 class="mb-0">{{order}}</h4>
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
            <h4 class="mb-0">{{brand}}</h4>
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
            <h4 class="mb-0">{{factory}}</h4>
            <p>工厂</p>
          </b-card-body>
          <factory-card-line-chart class="chart-wrapper px-3 height-70" height="70"/>
        </b-card>
      </b-col>
    </b-row>
  </div>
</template>

<script>
  import ProductCardLineChart from './ProductCardLineChart';
  import OrderCardLineChart from './OrderCardLineChart';
  import BrandCardLineChart from './BrandCardLineChart';
  import FactoryCardLineChart from './FactoryCardLineChart';

  export default {
    name: 'TenantDashboardPage',
    components: {
      ProductCardLineChart,
      OrderCardLineChart,
      BrandCardLineChart,
      FactoryCardLineChart,
    },
    data() {
      return {
        trafficDimension: 'Month',
        product: '',
        order: '',
        brand: '',
        factory: '',
      }
    },
    mounted() {
    },
  }
</script>
