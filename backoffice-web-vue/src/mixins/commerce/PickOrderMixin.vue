<script type="text/javascript">
  export default {
    data() {
      return {
        pickOrderStatuses: [
          {
            code: "WAIT_FOR_CONFIRM",
            name: "待处理"
          },
          {
            code: "CONFIRMED",
            name: "已确认"
          }
        ],
        pickOrderStatusProcessFlow: {
          "WAIT_FOR_CONFIRM": 0, // 待处理
          "CONFIRMED": 1,//已确认
        }
      }
    }
  }
</script>
