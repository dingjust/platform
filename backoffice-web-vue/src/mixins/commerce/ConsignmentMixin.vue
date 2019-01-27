<script type="text/javascript">
  export default {
    data() {
      return {
        consignmentStatuses: [
          {
            code: "WAIT_FOR_ALLOCATION",
            name: "待分配"
          },
          {
            code: "WAIT_FOR_PURCHASE",
            name: "备料中"
          },
          {
            code: "PENDING_CUTTING",
            name: "待裁剪"
          },
          {
            code: "CUTTING",
            name: "裁剪中"
          },
          {
            code: "STITCHING",
            name: "车缝中"
          },
          {
            code: "QC",
            name: "待验货"
          },
          {
            code: "PENDING_DELIVERY",
            name: "待发货"
          },
          {
            code: "DELIVERING",
            name: "已发货"
          },
          {
            code: "DELIVERY_COMPLETED",
            name: "已完成"
          }
        ],
        consignmentStatusProcessFlow: {
          "WAIT_FOR_ALLOCATION": 0, // 待分配
          "WAIT_FOR_PURCHASE": 1, // 备料中
          "PENDING_CUTTING": 2, // 待裁剪
          "CUTTING": 3, // 裁剪中
          "STITCHING": 4, // 车缝中
          "QC": 5, // 待验货
          "PENDING_DELIVERY": 6, // 待发货
          "DELIVERING": 7, // 已发货
          "DELIVERY_COMPLETED": 8 // 已完成
        }
      }
    }
  }
</script>
