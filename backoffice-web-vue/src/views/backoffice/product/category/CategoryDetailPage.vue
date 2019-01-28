<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>产品分类</span>
      </div>
      <el-form ref="form" label-position="top" :model="slotData" :rules="rules">
        <el-row :gutter="10">
          <el-col :span="8">
            <el-form-item label="编码" prop="code">
              <el-input v-model="slotData.code"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="名称" prop="name">
              <el-input v-model="slotData.name"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="分组" prop="group">
              <el-select v-model="slotData.group" class="w-100">
                <el-option v-for="item in groups" :key="item.code" :label="item.name" :value="item.code"></el-option>
              </el-select>
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
      <category-icon-form ref="CategoryIconForm"
                          :slot-data="slotData"
                          :read-only="readOnly">

      </category-icon-form>
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
  import CategoryIconForm from "./CategoryIconForm";
  import CategoryGroupMixin from "mixins/commerce/CategoryGroupMixin";

  export default {
    name: "CategoryForm",
    components: {CategoryIconForm},
    mixins:[CategoryGroupMixin],
    props: ["slotData", "readOnly"],
    methods: {
      onSubmit() {
        this.$refs.form.validate(valid => {
          if (!valid) {
            return false;
          }

          let formData = {
            name: this.slotData.name,
            description: this.slotData.description,
            parent: this.slotData.parent,
            code: this.slotData.code,
            group: this.slotData.group
          };

          axios.put("/djbackoffice/product/category", formData)
            .then(() => {
              this.$message({
                type: "success",
                message: "保存成功"
              });
              this.$refs["CategoryIconForm"].onSubmit();

              this.fn.closeSlider(true);
            }).catch(error => {
              this.$message.error(error.response.data);
            }
          );

          return true;
        });
      },
      onCancel() {
        this.fn.closeSlider(false);
      }
    },
    computed: {},
    data() {
      return {
        rules: {
          code: [{required: true, message: "必填", trigger: "blur"}],
          name: [{required: true, message: "必填", trigger: "blur"}]
        },

      };
    }
  };
</script>
