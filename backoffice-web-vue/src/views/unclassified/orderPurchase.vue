<template>
  <div class="custom-order-purchase-page">
    <div class="general-title">创建线下订单</div>
    <el-collapse v-model="activeNames" @change="handleChange">
      <el-collapse-item name="1" class="custom-collapse-item">
        <template slot="title">
          <div class="custom-collapse-item_title">合作对象</div>
        </template>
        <div class="custom-collapse-item_content">
          <div class="custom-item_content">
            <div class="custom-item_content-left">
              <el-input size="small" placeholder="请输入内容" v-model="input1">
                <template slot="prepend">合作商</template>
              </el-input>
            </div>
            <div class="custom-item_content-mid">
              <el-input size="small" placeholder="请输入内容" v-model="input1">
                <template slot="prepend">联系人</template>
              </el-input>
            </div>
            <div class="custom-item_content-right">
              <el-input size="small" placeholder="请输入内容" v-model="input1">
                <template slot="prepend">联系方式</template>
              </el-input>
            </div>
          </div>
        </div>
      </el-collapse-item>
      <el-collapse-item name="2" class="custom-collapse-item">
        <template slot="title">
          <div class="custom-collapse-item_title">生产详情</div>
        </template>
        <div class="custom-collapse-item_content">
          <div class="custom-item_content">
            <div class="custom-item_content-left">
              <el-input size="small" placeholder="请输入内容" v-model="input1">
                <template slot="prepend">生产产品</template>
              </el-input>
            </div>
            <div class="custom-item_content-mid">
              <el-input size="small" placeholder="请输入内容" v-model="input1">
                <template slot="prepend">订单报价</template>
              </el-input>
            </div>
            <div class="custom-item_content-right">
              <el-date-picker size="small" v-model="value1" type="date" placeholder="交货日期"></el-date-picker>
            </div>
          </div>
          <div class="custom-item_content2">
            <img class="custom-item_content-img" />
            <div class="custom-item_content-table">
              <table class="order-table">
                <thead>
                  <tr class="table-header">
                    <th>颜色</th>
                    <th>S</th>
                    <th>M</th>
                    <th>L</th>
                    <th>XL</th>
                    <th>XXL</th>
                    <th>XXXL</th>
                    <th>小计</th>
                  </tr>
                </thead>
                <tbody>
                  <tr class="table-body">
                    <td>黑色</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr class="table-body">
                    <td>白色</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr class="table-body">
                    <td>红色</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr class="table-body">
                    <td>绿色</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr class="table-body">
                    <td>蓝色</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr class="table-body">
                    <td>灰色</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                  <tr class="table-body">
                    <td>紫色</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
          <div class="custom-item_content2">
            <div class="custom-item_content-radio1">
              <span>合作方式：</span>
              <el-radio-group v-model="radio">
                <el-radio :label="3">清加工</el-radio>
                <el-radio :label="6">包工包料</el-radio>
              </el-radio-group>
            </div>
            <div class="custom-item_content-radio2">
              <span>是否开票：</span>
              <el-radio-group v-model="radio">
                <el-radio :label="3">开发票</el-radio>
                <el-radio :label="6">不开发票</el-radio>
              </el-radio-group>
            </div>
          </div>
          <div class="custom-item_content3">
            <span>送货地址：</span>
            <el-dropdown @command="handleCommand">
              <span class="el-dropdown-link">
                选择省份
                <i class="el-icon-arrow-down el-icon--right"></i>
              </span>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item command="a">黄金糕</el-dropdown-item>
                <el-dropdown-item command="b">狮子头</el-dropdown-item>
                <el-dropdown-item command="c">螺蛳粉</el-dropdown-item>
                <el-dropdown-item command="d" disabled>双皮奶</el-dropdown-item>
                <el-dropdown-item command="e" divided>蚵仔煎</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
            <el-dropdown @command="handleCommand">
              <span class="el-dropdown-link">
                选择城市
                <i class="el-icon-arrow-down el-icon--right"></i>
              </span>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item command="a">黄金糕</el-dropdown-item>
                <el-dropdown-item command="b">狮子头</el-dropdown-item>
                <el-dropdown-item command="c">螺蛳粉</el-dropdown-item>
                <el-dropdown-item command="d" disabled>双皮奶</el-dropdown-item>
                <el-dropdown-item command="e" divided>蚵仔煎</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
            <el-dropdown @command="handleCommand">
              <span class="el-dropdown-link">
                选择区
                <i class="el-icon-arrow-down el-icon--right"></i>
              </span>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item command="a">黄金糕</el-dropdown-item>
                <el-dropdown-item command="b">狮子头</el-dropdown-item>
                <el-dropdown-item command="c">螺蛳粉</el-dropdown-item>
                <el-dropdown-item command="d" disabled>双皮奶</el-dropdown-item>
                <el-dropdown-item command="e" divided>蚵仔煎</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
            <div class="custom-item_content-input">
              <el-input placeholder="请输入内容" size="small" v-model="input3" class>
                <el-button slot="append">选择</el-button>
              </el-input>
            </div>
          </div>
        </div>
      </el-collapse-item>
      <el-collapse-item name="3" class="custom-collapse-item">
        <template slot="title">
          <div class="custom-collapse-item_title">账务设置</div>
        </template>
        <div class="custom-collapse-item_content">
          <el-row type="flex" justify="space-between" align="middle">
            <div class="custom-item_content-radio">
              <span>有无定金：</span>
              <el-radio-group v-model="radio">
                <el-radio :label="3">有定金</el-radio>
                <el-radio :label="6">无定金</el-radio>
              </el-radio-group>
            </div>
            <div class="custom-item_content-radio">
              <span>尾款期数：</span>
              <el-radio-group v-model="radio">
                <el-radio :label="3">1期尾款</el-radio>
                <el-radio :label="6">2期尾款</el-radio>
              </el-radio-group>
            </div>
            <el-row>
              <span>选用我的财务方案：</span>
              <el-button type="warning" size="small" plain>方案一</el-button>
              <el-button type="warning" size="small" plain>方案二</el-button>
              <el-button type="warning" size="small" plain>方案三</el-button>
              <a>更多</a>
            </el-row>
          </el-row>
          <el-row class="custom-el-row" type="flex" justify="space-between" align="middle">
            <span>定金</span>
            <el-row class="custom-el-row-width">
              <span class="custom-style-span">事件</span>
              <el-select class="custom-select" size="small" v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                ></el-option>
              </el-select>
              <span class="custom-style-span">后，</span>
              <span class="custom-style-span">时长</span>
              <el-select class="custom-select" size="small" v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                ></el-option>
              </el-select>
              <span class="custom-style-span">天</span>
              <el-select class="custom-select" size="small" v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                ></el-option>
              </el-select>
              <span class="custom-style-span">，付款金额比例</span>
              <el-select class="custom-select" size="small" v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                ></el-option>
              </el-select>
            </el-row>
          </el-row>
          <el-row class="custom-el-row" type="flex" justify="space-between" align="middle">
            <span>第一期尾款</span>
            <el-row class="custom-el-row-width">
              <span class="custom-style-span">事件</span>
              <el-select class="custom-select" size="small" v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                ></el-option>
              </el-select>
              <span class="custom-style-span">后，</span>
              <span class="custom-style-span">时长</span>
              <el-select class="custom-select" size="small" v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                ></el-option>
              </el-select>
              <span class="custom-style-span">天</span>
              <el-select class="custom-select" size="small" v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                ></el-option>
              </el-select>
              <span class="custom-style-span">，付款金额比例</span>
              <el-select class="custom-select" size="small" v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                ></el-option>
              </el-select>
            </el-row>
          </el-row>
          <el-row class="custom-el-row" type="flex" justify="space-between" align="middle">
            <span>第二期尾款</span>
            <el-row class="custom-el-row-width">
              <span class="custom-style-span">事件</span>
              <el-select class="custom-select" size="small" v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                ></el-option>
              </el-select>
              <span class="custom-style-span">后，</span>
              <span class="custom-style-span">时长</span>
              <el-select class="custom-select" size="small" v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                ></el-option>
              </el-select>
              <span class="custom-style-span">天</span>
              <el-select class="custom-select" size="small" v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                ></el-option>
              </el-select>
              <span class="custom-style-span">，付款金额比例</span>
              <el-select class="custom-select" size="small" v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                ></el-option>
              </el-select>
            </el-row>
          </el-row>
          <el-row class="custom-el-row">
            <el-input
              type="textarea"
              :autosize="{ minRows: 2}"
              placeholder="结果预览"
              v-model="textarea2"
            ></el-input>
          </el-row>
        </div>
      </el-collapse-item>
      <el-collapse-item name="4" class="custom-collapse-item">
        <template slot="title">
          <div class="custom-collapse-item_title">员工设置</div>
        </template>
        <div class="custom-collapse-item_content">
          <el-row type="flex" justify="space-between" align="middle">
            <el-row class="custom-row_width50">
              <span class="custom-style-span">跟单员</span>
              <el-select size="small" v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                ></el-option>
              </el-select>
            </el-row>
            <el-row class="custom-row_width50">
              <span class="custom-style-span">审批人</span>
              <el-select size="small" v-model="value" placeholder="请选择">
                <el-option
                  v-for="item in options"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                ></el-option>
              </el-select>
            </el-row>
          </el-row>
        </div>
      </el-collapse-item>
      <el-collapse-item name="5" class="custom-collapse-item">
        <template slot="title">
          <div class="custom-collapse-item_title">备注及附件</div>
        </template>
        <div class="custom-collapse-item_content">
          <el-row :gutter="20">
            <el-col :span="4">
              <el-row type="flex" justify="space-between" align="middle">
                <el-col :span="10">
                  <div class="grid-content bg-purple"></div>
                </el-col>
                <el-col :span="12">
                  <div class="grid-content bg-purple"></div>
                </el-col>
              </el-row>
            </el-col>
            <el-col :span="16">
              <div class="grid-content bg-purple"></div>
            </el-col>
            <el-col :span="4">
              <div class="grid-content bg-purple"></div>
            </el-col>
          </el-row>
          <el-row class="custom-el-row">
            <el-input
              type="textarea"
              :autosize="{ minRows: 4}"
              placeholder="备注"
              v-model="textarea2"
            ></el-input>
          </el-row>
          <el-button type="warning">添加附件</el-button>
        </div>
      </el-collapse-item>
    </el-collapse>
    <el-button type="success" round>提交</el-button>
    <el-dialog :visible.sync="dialogVisible" width="30%" :before-close="handleClose">
      <span>订单xx创建成功，请创建或上传合同</span>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">稍后再说</el-button>
        <el-button type="primary" @click="dialogVisible = false">创建或上传合同</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "OrderPurchase",
  data() {
    return {
      input1: "",
      value1: "",
      activeNames: ["1", "2", "3", "4", "5"],
      dialogVisible: true
    };
  },
  methods: {
    handleChange(val) {
      console.log(val);
    },
    handleCommand(command) {
      this.$message("click on item " + command);
    },
    handleClose() {
      this.$confirm("确认关闭？")
        .then(_ => {})
        .catch(_ => {});
    }
  }
};
</script>

<style lang="scss">
.general-title {
  margin-bottom: 5px;
}
.custom-collapse-item {
  border: 1px #e6e6e6 solid;
}
.custom-order-purchase-page .el-collapse-item__header {
  background-color: #efefef;
}
.custom-collapse-item_title {
  text-align: left;
  padding-left: 10px;
}
.custom-collapse-item_content {
  padding: 30px;
}
.custom-order-purchase-page .el-collapse-item__content {
  padding-bottom: 0px;
}
.custom-item_content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.custom-item_content2 {
  margin-top: 30px;
  display: flex;
  justify-content: flex-start;
  align-items: flex-start;
}
.custom-item_content3 {
  margin-top: 30px;
  display: flex;
  justify-content: flex-start;
  align-items: center;
}
.custom-item_content4 {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.custom-item_content-left,
.custom-item_content-mid,
.custom-item_content-right {
  width: 25%;
}
.custom-item_content-img {
  width: 200px;
  height: 200px;
}
.custom-item_content-table {
  // height: 200px;
  margin-left: 50px;
}
.custom-item_content-radio2 {
  margin-left: 50px;
}
.custom-item_content-input {
  width: 25%;
}
.order-table {
  width: 600px;
  border-collapse: collapse;
}
.order-table tr td,
.order-table tr th {
  border: 1px solid #aaa;
}
.custom-el-row {
  margin: 10px 0;
}
.custom-el-row-width {
  width: 90%;
}
.custom-select {
  width: 18%;
}
.custom-style-span {
  display: inline-block;
  margin: 0 5px;
}
.custom-row_width50 {
  width: 50%;
}
.bg-purple {
  background: #d3dce6;
}
.grid-content {
  border-radius: 4px;
  min-height: 36px;
}
</style>