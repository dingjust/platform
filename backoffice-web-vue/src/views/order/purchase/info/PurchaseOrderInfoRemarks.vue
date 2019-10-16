<template>
  <div class="info-remarks-body">
    <el-row type="flex" justify="space-between" align="middle" class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">备注及附件</h6>
      </div>
    </el-row>
    <el-row>
      <el-col :span="2">
        <h6>附件</h6>
      </el-col>
      <el-col :span="22">
        <el-row>
          <template v-for="item in slotData.attachments"
            v-if="slotData.attachments!=null&&slotData.attachments.length!=0">
            <a :href="item.url" target="_blank">
              <img :src="item.url" class="info-remarks-img" />
            </a>
          </template>
          <h6 v-if="slotData.attachments==null||slotData.attachments.length==0">暂无附件</h6>
        </el-row>
      </el-col>
    </el-row>
    <el-row class="info-remarks-row">
      <el-col :span="2">
        <h6>备注</h6>
      </el-col>
      <el-col :span="22">
        <el-row>
          <div class="info-remarks-textarea">
            <h6 class="info-remarks-textarea_text">{{slotData.remarks!=''?slotData.remarks:'暂无备注'}}</h6>
          </div>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'PurchaseOrderInfoRemarks',
    props: ['slotData'],
    components: {},
    mixins: [],
    computed: {

    },
    methods: {
      handleRemove(file, fileList) {
        console.log(file, fileList);
      },
      handlePreview(file) {
        console.log(file);
      },
      handleExceed(files, fileList) {
        this.$message.warning(`当前限制选择 3 个文件，本次选择了 ${files.length} 个文件，共选择了 ${files.length + fileList.length} 个文件`);
      },
      beforeRemove(file, fileList) {
        return this.$confirm(`确定移除 ${ file.name }？`);
      }
    },
    data() {
      return {
        mockAttachments: [
          "http://localhost:8081/resource/h0d/hc4/8797905682462.png",
          "http://localhost:8081/resource/h0d/hc4/8797905682462.png",
          "http://localhost:8081/resource/h0d/hc4/8797905682462.png",

        ]
      }
    },
    created() {}
  }

</script>
<style>
  .info-remarks-body {
    width: 100%;
    margin-top: 20px;
  }

  .info-remarks-img {
    width: 50px;
    height: 50px;
    border-radius: 10px;
    margin-right: 10px;
  }

  .info-remarks-row {
    margin-top: 20px;
  }

  .info-remarks-textarea {
    width: 100%;
    border: 0.5px solid rgba(0, 0, 0, 0.15);
    padding: 5px 10px;
    border-radius: 3px;
  }

  .info-remarks-textarea_text {
    font-size: 10px;
    color: rgba(0, 0, 0, 0.45);
  }

</style>
