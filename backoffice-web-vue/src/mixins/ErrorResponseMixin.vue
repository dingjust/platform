<script type="text/javascript">
  export default {
    methods: {
      getErrorMessage(error) {
        const errors = error.response.data["errors"] || [];
        if (errors && errors.length) {
          return errors[0].message;
        }

        return "";
      }
    },
    data() {
      return {}
    }
  }
</script>
