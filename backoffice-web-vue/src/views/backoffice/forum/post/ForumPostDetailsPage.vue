<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <el-form ref="form" label-position="top" :model="slotData" disabled>
        <el-row :gutter="10">
          <el-col :span="12">
            <el-form-item label="标题" prop="title">
              <el-input v-model="slotData.title"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="帖子分类" prop="category">
              <el-input v-model="slotData.category.name"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="10">
          <el-col :span="12">
            <el-form-item label="是否置顶" prop="topped">
              <el-radio-group v-model="slotData.topped">
                <el-radio :label="true">是</el-radio>
                <el-radio :label="false">否</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="是否精华帖" prop="distillated">
              <el-radio-group v-model="slotData.distillated">
                <el-radio :label="true">是</el-radio>
                <el-radio :label="false">否</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="10">
          <el-col :span="24">
            <el-form-item label="内容" prop="content">
              <el-input type="textarea" :rows="10" v-model="slotData.content"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <el-row :gutter="10">
        <el-col :span="8">
          <el-button type="primary" class="btn-block" size="mini" @click="onTop()">
            <span v-show="!slotData.topped">置顶</span>
            <span v-show="slotData.topped">取消置顶</span>
          </el-button>
        </el-col>
        <el-col :span="8">
          <el-button type="primary" class="btn-block" size="mini" @click="onDistillate()">
            <span v-show="!slotData.distillated">设置为精华贴</span>
            <span v-show="slotData.distillated">取消设置为精华贴</span>
          </el-button>
        </el-col>
        <el-col :span="8">
          <el-button class="btn-block" size="mini" @click="onDelete()">
            删除
          </el-button>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import axios from "axios";

  export default {
    name: "ForumPostDetailsPage",
    props: ["slotData"],
    methods: {
      onTop() {
        axios.put("/djforum/post/top", {
          id: this.slotData.id,
          topped: !this.slotData.topped
        }).then(response => {
          this.$message.success("设置成功");

          this.$set(this.slotData, "topped", response.data);
        }).catch(error => {
          this.$message.error("设置失败，原因：" + error.response.data);
        });
      },
      onDistillate() {
        axios.put("/djforum/post/distillate", {
          id: this.slotData.id,
          distillated: !this.slotData.distillated
        }).then(response => {
          this.$message.success("设置成功");

          this.$set(this.slotData, "distillated", response.data);
        }).catch(error => {
          this.$message.error("设置失败，原因：" + error.response.data);
        });
      },
      onDelete() {
        this.$confirm("此操作将永久删除该帖子, 是否继续?", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }).then(() => {
          axios.delete("/djforum/post/" + this.slotData.id)
            .then(() => {
              this.$message.success("删除成功");

              this.fn.closeSlider();
            }).catch(error => {
              this.$message.error("删除失败，原因：" + error.response.data);
            }
          );
        });
      },
      onCancel() {
        this.fn.closeSlider();
      }
    },
    computed: {},
    data() {
      return {};
    }
  };
</script>
