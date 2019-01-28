<script type="text/javascript">
  import axios from 'axios';

  export default {
    data() {
      return {
        excelImportTemplateName: '样例模板.xlsx',
        excelImportDialogVisible: false,
        excelImportAccepts: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      }
    },
    computed: {
      excelImportActionUrl: function () {
        return '/excel/import/' + this.domainClass;
      }
    },
    methods: {
      onTemplateDownload() {
        const config = {
          method: 'post',
          url: "/excel/import/template/" + this.domainClass,
          responseType: 'blob'
        };

        axios(config).then(response => {
          this.downloadTemplate(response.data);
        }).catch((error) => {
          console.error(error);
          this.$message.error(error.message);
        });
      },
      downloadTemplate(data) {
        if (!data) {
          return
        }

        let url = URL.createObjectURL(new Blob([data]));
        let link = document.createElement('a');
        link.style.display = 'none';
        link.href = url;
        link.target = '_blank';
        link.setAttribute('download', this.excelImportTemplateName);

        document.body.appendChild(link);
        link.click();
      },
      onImport() {
        this.excelImportDialogVisible = true;
        this.$nextTick(() => {
          this.$refs.upload.clearFiles();
        });
      },
      onCancelImport() {
        this.excelImportDialogVisible = false;
        this.$refs.upload.clearFiles();
      },
      onSubmitImport() {
        this.$refs.upload.submit();
      },
      onBeforeImport(file) {
        const allowed = file.size / 1024 / 1024 < 5;
        if (!allowed) {
          this.$message.error('上传文件大小不能超过 5MB!');
        }

        return allowed;
      },
      onImportProgress(event, file, fileList) {
        this.$message.error('数据导入中，请稍等');
      },
      onImportSuccess(response, file, fileList) {
        console.log('response: ' + JSON.stringify(response));

        this.excelImportDialogVisible = false;
        this.$refs.upload.clearFiles();
        if (response && response.length) {
          this.$message.error({
            type: 'success',
            message: '数据导入失败，原因如下：行号：' + response[0]['rowNum'] + ', 原因：' + response[0]['reason']
          });

          return;
        }

        this.$message({
          type: 'success',
          message: '数据导入成功'
        });

        this.excelImportDialogVisible = false;
      },
      onImportError(error, file, fileList) {
        this.$message.error('文件导入失败');

        console.log(JSON.stringify(error));
      }
    }
  }
</script>
