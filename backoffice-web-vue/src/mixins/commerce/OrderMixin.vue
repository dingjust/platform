<script type="text/javascript">
  export default {
    data() {
      return {
        orderStatuses: [
          {
            code: 'WAIT_FOR_PROCESSING',
            name: '待处理'
          },
          {
            code: 'PENDING_APPROVAL',
            name: '待确认'
          },
          {
            code: 'APPROVED',
            name: '已确认'
          },
          {
            code: 'WAIT_FOR_OUT_OF_STORE',
            name: '待出库'
          },
          {
            code: 'OUT_OF_STORE',
            name: '已出库'
          },
          {
            code: 'COMPLETED',
            name: '已完成'
          },
          {
            code: 'PENDING_PAYMENT',
            name: '待付款'
          },
          {
            code: 'PENDING_DELIVERY',
            name: '待发货'
          },
          {
            code: 'SHIPPED',
            name: '已发货'
          }
        ],
        orderStatusProcessFlow: {
          'WAIT_FOR_PROCESSING': 0, // 待处理
          'PENDING_APPROVAL': 1, // 待确认
          'APPROVED': 2, // 已确认
          'WAIT_FOR_OUT_OF_STORE': 3, // 待出库
          'OUT_OF_STORE': 4, // 已出库
          'COMPLETED': 5 // 已完成
        },
        salesOrderStatusProcessFlow: {
          'PENDING_PAYMENT': 0,
          'PENDING_DELIVERY': 1,
          'SHIPPED': 2,
          'COMPLETED': 3
        }
      }
    }
  }
</script>
