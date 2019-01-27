<template>
  <div class="animated fadeIn">
    <el-row :gutter="15">
      <el-col :span="24">
        <product-media-entry-upload-form ref="masterPictureForm"
                                         :slot-data="masterPicture">
        </product-media-entry-upload-form>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-row :gutter="15">
      <el-col :span="24">
        <product-media-entry-upload-form ref="normalPictureForm"
                                         :slot-data="normalPicture">
        </product-media-entry-upload-form>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-row :gutter="15">
      <el-col :span="24">
        <product-media-entry-upload-form ref="detailPictureForm"
                                         :slot-data="detailPicture">
        </product-media-entry-upload-form>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-row :gutter="15">
      <el-col :span="24">
        <product-media-entry-upload-form ref="bomForm"
                                         :slot-data="bom">
        </product-media-entry-upload-form>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-row :gutter="15">
      <el-col :span="24">
        <product-media-entry-upload-form ref="technicalDocumentsForm"
                                         :slot-data="technicalDocuments">
        </product-media-entry-upload-form>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import ProductMediaEntryUploadForm from "./ProductMediaEntryUploadForm";

  export default {
    name: "ProductMediaUploadForms",
    components: {ProductMediaEntryUploadForm},
    props: ["slotData", "readOnly", "isNewlyCreated"],
    methods: {
      onSubmit() {
        this.$refs["masterPictureForm"].onSubmit();
        this.$refs["normalPictureForm"].onSubmit();
        this.$refs["detailPictureForm"].onSubmit();
        this.$refs["bomForm"].onSubmit();
        this.$refs["technicalDocumentsForm"].onSubmit();
      }
    },
    computed: {
      masterPicture: function () {
        return {
          code: this.slotData.code,
          format: {
            value: "masterPicture",
            label: "缩略图"
          }
        }
      },
      normalPicture: function () {
        return {
          code: this.slotData.code,
          format: {
            value: "normalPicture",
            label: "主图"
          }
        }
      },
      detailPicture: function () {
        return {
          code: this.slotData.code,
          format: {
            value: "detailPicture",
            label: "详细图"
          }
        }
      },
      bom: function () {
        return {
          code: this.slotData.code,
          format: {
            value: "bom",
            label: "BOM文件"
          }
        }
      },
      technicalDocuments: function () {
        return {
          code: this.slotData.code,
          format: {
            value: "technicalDocuments",
            label: "技术文件"
          }
        }
      }
    },
    data() {
      return {};
    }
  };
</script>
