<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <el-form ref="form" label-position="top" :model="slotData" :rules="rules">
        <el-row :gutter="10">
          <el-col :span="12">
            <el-form-item label="编码" prop="code">
              <el-input v-model="slotData.code"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="名称" prop="name">
              <el-input v-model="slotData.name"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="10">
          <el-col :span="12">
            <el-form-item label="父分类" prop="parent">
              <el-input v-model="slotData.parent.name" disabled></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="描述" prop="description">
              <el-input v-model="slotData.description"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-card>

    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>分类图标</span>
      </div>
      <forum-category-icon-form ref="ForumCategoryIconForm"
                                :slot-data="slotData"
                                :read-only="readOnly">

      </forum-category-icon-form>
    </el-card>

    <div class="pt-2"></div>
    <el-row :gutter="10">
      <el-col :span="12">
        <el-button type="primary" class="btn-block" size="mini" @click="onSubmit">保存</el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" size="mini" @click="onCancel">取消</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import axios from "axios";
  import ForumCategoryIconForm from "./ForumCategoryIconForm";

  export default {
    name: "ForumCategoryForm",
    components: {ForumCategoryIconForm},
    props: ["slotData", "readOnly"],
    methods: {
      onSubmit() {
        this.$refs.form.validate(valid => {
          if (!valid) {
            return false;
          }

          let formData = {
            code: this.slotData.code,
            name: this.slotData.name,
            description: this.slotData.description,
            parent: this.slotData.parent
          };

          axios.post("/djforum/category", formData)
            .then(response => {
              this.$message.success("保存成功");
              console.log(this.slotData);

              this.$set(this.slotData, "code", response.data.code);

              this.$refs.ForumCategoryIconForm.onSubmit();

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
    computed: {},
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
