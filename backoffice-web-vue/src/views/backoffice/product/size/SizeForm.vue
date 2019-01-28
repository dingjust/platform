<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>颜色</span>
      </div>
      <size-base-form ref="baseForm" :slot-data="slotData"></size-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-row :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" size="mini" type="primary" @click="onSubmit">
          提交
        </el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" size="mini" @click="onCancel">
          取消
        </el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import axios from "axios";
  import SizeBaseForm from "./SizeBaseForm";

  export default {
    name: "SizeForm",
    components: {SizeBaseForm},
    props: ["slotData"],
    methods: {
      onSubmit() {
        this.$refs["baseForm"].validate(valid => {
          if (!valid) {
            return false;
          }

          axios.post("/djbackoffice/product/size", this.slotData)
            .then(() => {
              this.$message.success("保存成功");
              this.fn.closeSlider(true);
            }).catch(error => {
              this.$message.error(error.response.data);
            }
          );
          return true;
        });
      },
      onCancel() {
        this.fn.closeSlider();
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {
        rules: {
          code: [{required: true, message: "必填", trigger: "blur"}],
          name: [{required: true, message: "必填", trigger: "blur"}]
        }
      };
    }
  };
</script>
