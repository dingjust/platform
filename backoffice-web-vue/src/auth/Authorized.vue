<script>
    import { check } from './auth';
    export default {
      functional: true,
      props: {
        authority: {
          type: Array,
          required: true
        }
      },
      render (h, context) {
        const { props, scopedSlots } = context;
        // 如果校验通过，则返回子组件/插槽内容；否则返回null;
        return check(props.authority) ? scopedSlots.default() : null;
      }
    }
</script>
