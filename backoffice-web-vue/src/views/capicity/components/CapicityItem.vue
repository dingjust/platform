<template>
  <div class="capicity-item-container">
    <el-card class="capicity-item">
      <el-row type="flex" align="middle">
        <el-col :span="6" :class="slotData.enabled?'capicity-item-left_active':'capicity-item-left'">
          <el-row type="flex" justify="center">
            <h6 class="capicity-text">{{dateRangeStr}}</h6>
          </el-row>
          <el-row type="flex" justify="center">
            <h6 class="capicity-text">空闲日期</h6>
          </el-row>
          <el-row type="flex" justify="center" style="margin-top:50px;">
            <el-switch v-model="slotData.enabled" active-text="开" inactive-text="关" active-color="#13ce66"
              inactive-color="#e0e0e0" @change="onStatusChange"></el-switch>
          </el-row>
        </el-col>
        <el-col :span="18" class="capicity-item-right">
          <el-row type="flex">
            <el-col :span="6">
              <h6 class="capicity-text title">标题</h6>
            </el-col>
            <el-col :span="18">
              <el-row type="flex" justify="center">
                <h6 class="capicity-text">{{slotData.title}}</h6>
              </el-row>
            </el-col>
          </el-row>
          <el-row type="flex">
            <el-col :span="16">
              <el-row type="flex">
                <el-col :span="24" class="capicity-category-container">
                  <template v-for="(item,index) in slotData.categoryCapacities">
                    <el-row :key="index" type="flex" align="middle" style="margin-top:5px;">
                      <el-col :span="8">
                        <el-row type="flex">
                          <h6 class="capicity-text" style="margin-left:20px;">{{item.categoryName}}</h6>
                        </el-row>
                      </el-col>
                      <el-col :span="16">
                        <el-row type="flex" justify="center">
                          <h6 class="capicity-text value">{{item.capacityRange}}/天</h6>
                        </el-row>
                      </el-col>
                    </el-row>
                  </template>
                </el-col>
              </el-row>
              <el-row type="flex" align="middle" style="margin-top:10px;">
                <el-col :span="12">
                  <el-row type="flex">
                    <h6 class="capicity-text info" style="margin-left:20px;">浏览量：{{slotData.showTimes}}</h6>
                  </el-row>
                </el-col>
                <el-col :span="12">
                  <el-row type="flex" justify="center">
                    <h6 class="capicity-text info" style="margin-left:20px;">点击量：{{slotData.clickTimes}}</h6>
                  </el-row>
                </el-col>
              </el-row>
            </el-col>
            <el-col :span="8">
              <el-row type="flex" justify="center">
                <el-button class="capicity-edit">
                  编辑</el-button>
              </el-row>
              <el-row type="flex" justify="center">
                <el-button class="capicity-refresh" @click="onRefresh"
                  :disabled="slotData.remainRefreshTimes==0||!slotData.enabled">
                  刷新({{slotData.remainRefreshTimes}})</el-button>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  export default {
    name: "CapicityItem",
    props: ["slotData"],
    components: {},
    computed: {
      dateRangeStr: function () {
        var result = "";
        if (this.slotData.longTerm) {
          result = "长期有效";
        } else {
          result =
            this.timestampToTime(this.slotData.dateStartPoint) +
            "~" +
            this.timestampToTime(this.slotData.dateEndPoint);
        }
        return result;
      }
    },
    methods: {
      timestampToTime(timestamp) {
        const date = new Date(timestamp); // 时间戳为10位需*1000，时间戳为13位的话不需乘1000
        // const Y = date.getFullYear() + '-'; // 此时为四位数字表示 getYear()的话为两位数字表示
        const M =
          (date.getMonth() + 1 < 10 ?
            "0" + (date.getMonth() + 1) :
            date.getMonth() + 1) + ""; // 当前月份(0-11,0代表1月)
        const D = date.getDate() + " "; // 当前日(1-31)
        /* const h = date.getHours() + ':';
             const  m = (date.getMinutes() < 10 ? '0' + date.getMinutes() : date.getMinutes()) + ':';
             const s = date.getSeconds() + ':';
             const ms = date.getMilliseconds();//毫秒值 */

        return M + "." + D; // 此处可以自定义需要的显示类型
      },
      async onStatusChange(val) {
        const url = this.apis().capacitySwitchStatus(this.slotData.code);
        const result = await this.$http.get(url, {
          'enabled': this.slotData.enabled
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success(val ? '开启成功' : '关闭成功');
      },
      async onRefresh() {
        const url = this.apis().capacityRefresh(this.slotData.code);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        if (result.resultCode == 1) {
          this.$message.success('刷新成功');
          this.$emit("refresh");
        } else {
          this.$message.error('刷新失败 : ' + result.msg);
        }
      },
    },
    data() {
      return {};
    },
    created() {},
    mounted() {}
  };

</script>
<style scoped>
  .capicity-item {
    height: 220px;
  }

  .capicity-item-left_active {
    height: 220px;
    background-color: #fff59d;
    padding-top: 20px;
  }

  .capicity-item-left {
    height: 220px;
    background-color: #eeeeee;
    padding-top: 20px;
  }

  .capicity-item-right {
    height: 220px;
    padding-top: 20px;
  }

  .capicity-item-container>>>.el-card__body {
    padding: 0px;
  }

  .capicity-text {
    font-size: 14px;
    color: #616161;
  }

  .title {
    margin-left: 20px;
    margin-right: 20px;
    font-weight: bold;
  }

  .capicity-edit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 80px;
    margin-top: 30px;
  }

  .capicity-refresh {

    width: 80px;
    margin-top: 30px;
  }

  .capicity-category-container {
    height: 120px;
  }

  .value {
    color: red;
  }

  .info {
    color: #bdbdbd;
  }

</style>
