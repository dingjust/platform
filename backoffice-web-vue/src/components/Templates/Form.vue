<template>
  <el-form ref="form" label-position="top" :model="slotData" :rules="rules">
    <el-row :gutter="10">
      <!--<el-col :span="12">
        <el-form-item label="UID" prop="uid">
          <el-input :disabled="!isNewlyCreated" v-model="slotData.uid"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="名称" prop="name">
          <el-input v-model="slotData.name"></el-input>
        </el-form-item>
      </el-col>-->
    </el-row>
  </el-form>
</template>

<script>
  import axios from "axios";

  export default {
    name: "XXXForm",
    props: ["slotData"],
    methods: {
      onSubmit() {
        this.$refs["form"].validate(valid => {
          if (!valid) {
            return false;
          }
          let request = axios.post;
          if (!this.isNewlyCreated) {
            request = axios.put;
          }
          // TODO: url
          request("/djbackoffice/xxx/xxx", this.slotData)
            .then(() => {
              this.$message({
                type: "success",
                message: "保存成功"
              });
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
          /*name: [{required: true, message: "必填", trigger: "blur"}]*/
        }
      };
    }
  };
</script>
