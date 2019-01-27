<script type="text/javascript">
  import axios from 'axios';

  export default {
    data() {
      return {
        URLS: {
          exportUrl: "TODO URL",
        },
        excelExportTemplateName: "TODO.xlsx"
      }
    },
    methods: {
      onExport() {
        const config = {
          method: "post",
          url: this.URLS.exportUrl,
          data: this.query,
          responseType: "blob"
        };
        axios(config).then(response => {
          this.doExport(response.data);
        }).catch(error => {
          this.$message({
            type: "error",
            message: error.message
            // message: error.response.data.message
          });
        });
      },
      doExport(data) {
        if (!data) {
          return
        }

        let url = URL.createObjectURL(new Blob([data]));
        let link = document.createElement("a");
        link.style.display = "none";
        link.href = url;
        link.target = "_blank";
        link.setAttribute("download", this.excelExportTemplateName);

        document.body.appendChild(link);
        link.click();
      }
    }
  }
</script>
