<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <div class="custom-create-contract-page">
        <el-row class="custom-item_row" type="flex" justify="center" align="middle">
          <span>创建合同（关联订单合同）</span>
        </el-row>
        <div class="custom-create-contract-page_content">
          <div class="custom-content_item">
            <el-row class="custom-content_title">合同类型</el-row>
            <el-row class="custom-item_row" type="flex" justify="space-between" align="middle">
              <el-row class="custom-radio-item custom-item_check" type="flex" align="middle">
                <el-col :span="2">
                  <i class="el-icon-check"></i>
                </el-col>
                <el-col :span="20" class="custom-radio-item_col">
                  <span class="custom-radio-item_title">新签合同（电子签章）——电子合同</span>
                  <span class="custom-radio-item_span">新创建电子合同或者上传未签署的纸质合同文件，使用在线电子签章签署合同</span>
                </el-col>
                <el-col :span="2">
                  <i class="el-icon-arrow-down"></i>
                </el-col>
              </el-row>
              <el-row class="custom-radio-item" type="flex" align="middle">
                <el-col :span="2">
                  <i class="el-icon-check"></i>
                </el-col>
                <el-col :span="21" class="custom-radio-item_col">
                  <span class="custom-radio-item_title">已签纸质合同</span>
                  <span class="custom-radio-item_span">把已签署的合同文件扫描件上传到订单附件中作为备份</span>
                </el-col>
              </el-row>
            </el-row>
          </div>
          <div class="custom-content_item">
            <el-row class="custom-content_title">合同内容</el-row>
            <el-row class="custom-item_row" type="flex" justify="space-between" align="middle">
              <el-col :span="10">
                <el-row class="custom-item_row-select">
                  <span>关联订单</span>
                  <el-select size="small" v-model="value" placeholder="请选择">
                    <el-option v-for="item in cities" :key="item.value" :label="item.label" :value="item.value">
                      <span style="float: left">{{ item.label }}</span>
                      <span style="float: right; color: #8492a6; font-size: 13px">{{ item.value }}</span>
                    </el-option>
                  </el-select>
                </el-row>
                <el-row class="custom-item_row-select">
                  <span>合同模板</span>
                  <el-select size="small" v-model="value" placeholder="请选择">
                    <el-option v-for="item in cities" :key="item.value" :label="item.label" :value="item.value">
                      <span style="float: left">{{ item.label }}</span>
                      <span style="float: right; color: #8492a6; font-size: 13px">{{ item.value }}</span>
                    </el-option>
                  </el-select>
                </el-row>
                <el-row class="custom-item_row-select">
                  <span>合同印章</span>
                  <el-select size="small" v-model="value" placeholder="请选择">
                    <el-option v-for="item in cities" :key="item.value" :label="item.label" :value="item.value">
                      <span style="float: left">{{ item.label }}</span>
                      <span style="float: right; color: #8492a6; font-size: 13px">{{ item.value }}</span>
                    </el-option>
                  </el-select>
                </el-row>
                <el-row class="custom-item_row-select">
                  <el-radio size="small" v-model="radio1" label="1" border>我是甲方</el-radio>
                  <el-radio size="small" v-model="radio1" label="2" border>我是乙方</el-radio>
                </el-row>
              </el-col>
              <el-col class="custom-item_row-select_right" :span="14"></el-col>
            </el-row>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script>
  export default {
    name: "CreateContract",
    methods: {
      handleClick() {
        alert("button click");
      }
    }
  };

</script>

<style lang="scss">
  .custom-create-contract-page_content {
    border: 1px solid #a4a4a4;
  }

  .custom-content_title {
    height: 45px;
    line-height: 45px;
    color: #101010;
    font-size: 20px;
    background-color: rgba(239, 239, 239, 1);
    text-align: left;
    padding-left: 10px;
  }

  .custom-item_row {
    padding: 60px;
  }

  .custom-item_row-select {
    margin: 30px 0;
  }

  .custom-radio-item {
    width: 690px;
    height: 106px;
    border-radius: 10px;
    border: 1px solid #a2a2a2;
  }

  .custom-radio-item_title {
    font-size: 24px;
    color: #101010;
    display: block;
    text-align: left;
  }

  .custom-radio-item_span {
    font-size: 20px;
    color: #a4a4a4;
    display: block;
    text-align: left;
  }

  .custom-radio-item_col {
    height: 100%;
    padding: 5px 0;
    background-color: #fff;
  }

  .custom-item_check {
    border: 1px solid #ffd60c;
    background-color: #ffd60c;
  }

  .custom-item_row-select_right {
    height: 400px;
    border: 1px solid #a4a4a4;
  }

</style>
