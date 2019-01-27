<style type="scss">
  .el-carousel__item h3 {
    color: #475669;
    font-size: 14px;
    opacity: 0.75;
    line-height: 200px;
    margin: 0;
  }

  .el-carousel__item:nth-child(2n) {
    background-color: #99a9bf;
  }

  .el-carousel__item:nth-child(2n + 1) {
    background-color: #d3dce6;
  }
</style>
<template>
  <div class="animated fadeIn">
    <el-tabs v-model="activeName">
      <el-tab-pane v-for="group in groups" :key="group.name" :label="getGroupName(group.name)">
        <media-file-list v-if="!isPicture(group)" :file="group.medias" @onDelete="onDelete"></media-file-list>
        <el-row :gutter="20" v-if="isPicture(group)">
          <el-col :span="6" v-for="media in group.medias" :key="media.url">
            <img style="width:100%;height: 100%" :src="media.url"/>
            <div style="text-align: center;padding-top: 2px;">
              <el-button @click="onDelete(media)">删除</el-button>
            </div>
          </el-col>
        </el-row>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import axios from "axios";
  import MediaFileList from "../../../../components/custom/MediaFileList.vue";

  export default {
    name: "ProductMediasForm",
    props: ["slotData", "readOnly", "isNewlyCreated"],
    components: {MediaFileList},
    methods: {
      onDelete(item) {
        this.$confirm("此操作将永久删除该图片, 是否继续?", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }).then(() => {
          axios.delete("/djbrand/product/media/" + item.id, {
            params: {
              code: this.slotData.code
            }
          }).then(() => {
            this.refresh();
            this.$message.success("图片删除成功");
          }).catch(error => {
            this.$message.error("图片删除失败");
          });
        });
      },
      refresh() {
        if (this.slotData.code) {
          this.doRefresh();
        }
      },
      doRefresh() {
        if (this.slotData.code != null && this.slotData.code !== '') {
          axios
            .get("/djbrand/product/mediaGroups/" + this.slotData.code)
            .then(response => {
              this.groups = response.data;
            })
            .catch(error => {
              console.log(JSON.stringify(error));
              this.$message.error(error.response.statusText);
            });
        }
      },
      isPicture(group) {
        return !(group.name === "bom" || group.name === "technicalDocuments");
      },
      getGroupName(group) {
        var result = "";
        switch (group) {
          case "masterPicture":
            result = "缩略图";
            break;
          case "detailPicture":
            result = "详细图";
            break;
          case "normalPicture":
            result = "主图";
            break;
          case "bom":
            result = "BOM文件";
            break;
          case "technicalDocuments":
            result = "技术文件";
            break;
          default:
            break;
        }

        return result;
      }
    },
    computed: {},
    data() {
      return {
        activeName: "0",
        groups: []
      };
    },
    created() {
      if (!this.isNewlyCreated) {
        this.doRefresh();
      }
    }
  };
</script>
