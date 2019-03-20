<template>
  <div class="animated fadeIn content">
    <el-card>
      <production-progress-report-toolbar @onSearch="onSearch"/>
      <production-progress-report-list :page="page" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {ExcelExportMixin} from '@/mixins';

  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('ProductionProgressReportsModule');

  import ProductionProgressReportToolbar from './toolbar/ProductionProgressReportToolbar';
  import ProductionProgressReportList from './list/ProductionProgressReportList';

  export default {
    name: 'ProductionProgressReportPage',
    mixins: [ExcelExportMixin],
    components: {
      ProductionProgressReportToolbar,
      ProductionProgressReportList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
      }),
      data: function () {
        return {
          format: this.slotData.format.value,
          files: this.files
        };
      },
    },
    methods: {
      ...mapActions({
        search: 'search',
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.apis().getProductionProgressReports();
        this.search({url, keyword, page, size});
      },
      async getBrands() {
        const result = await this.$http.get('/djbrand/brand', {
          text: '',
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.brands = result.content;
      },
      async getFactories() {
        const result = await this.$http.get('/djfactory/factory', {
          text: '',
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.factories = result.content;
      },
    },
    data() {
      return {
        URLS: {
          exportUrl: '/djbackoffice/report/production/progress/export',
        },
        excelExportTemplateName: '生产进度报表' + new Date().getTime() + '.xlsx',
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        },
        query: {
          requirementOrderCode: '',
          productionOrderCode: '',
          brand: null,
          factory: null,
          isDelay: true,
          status: [],
          expectedDeliveryDateFrom: null,
          expectedDeliveryDateTo: null,
          createdDateFrom: null,
          createdDateTo: null,
        },
        brands: [],
        factories: [],
        value: '',
        statuses: [
          {code: 'WAIT_FOR_ALLOCATION', name: '待分配'},
          {code: 'WAIT_FOR_PURCHASE', name: '备料中'},
          {code: 'PENDING_CUTTING', name: '待裁剪'},
          {code: 'CUTTING', name: '裁剪中'},
          {code: 'STITCHING', name: '车缝中'},
          {code: 'QC', name: '待验货'},
          {code: 'PENDING_DELIVERY', name: '待发货'},
          {code: 'DELIVERING', name: '已发货'},
          {code: 'DELIVERY_COMPLETED', name: '已完成'},
        ]
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
