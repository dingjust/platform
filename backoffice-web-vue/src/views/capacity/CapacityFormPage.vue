<template>
  <div>
    <el-form ref="form" :model="formData" :rules="rules">
      <el-card class="box-card">
        <el-row class="info-title-row">
          <div class="info-title">
            <h6 class="info-title_text">产能</h6>
          </div>
        </el-row>
        <el-row class="capacity-form-row" type="flex" align="bottom">
          <el-col :span="5">
            <el-form-item prop="title">
              <el-input placeholder="请输入标题" v-model="formData.title">
                <template slot="prepend">标题</template>
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row class="capacity-form-row" type="flex" align="bottom">
          <el-radio v-model="formData.longTerm" :label="false">
            <span class="capacity-form-label">选择空闲日期</span>
          </el-radio>
          <el-date-picker v-model="dateRange" @change="onDateChange" value-format="timestamp" type="daterange"
            :disabled="formData.longTerm" range-separator="-" start-placeholder="开始日期" end-placeholder="结束日期">
          </el-date-picker>
        </el-row>
        <el-row class="capacity-form-row">
          <el-radio v-model="formData.longTerm" :label="true">
            <span class="capacity-form-label">
              长期有效
              <span class="capacity-form-info">(不需要选择具体日期)</span>
            </span>
          </el-radio>
        </el-row>
        <el-row class="info-title-row-2">
          <h6 class="info-title_text">选择品类：</h6>
        </el-row>
        <category-select :selectDatas="formData.categoryCapacities" :maxNum="4"></category-select>
        <el-divider></el-divider>
        <template v-for="(item,index) in formData.categoryCapacities">
          <el-row type="flex" :key="index" style="margin-top:10px;">
            <el-col :span="2">
              <h6>{{item.category.name}}</h6>
            </el-col>
            <el-col :span="6">
              <el-input placeholder="请输入数量" v-model.number="item.capacityRange">
                <template slot="prepend">日产能</template>
                <template slot="suffix">
                  <h6 class="input-row-suffix">件/天</h6>
                </template>
              </el-input>
            </el-col>
          </el-row>
        </template>
        <el-row type="flex" justify="center" class="product-form-row">
          <el-button class="product-form-btn" @click="onSave">
            确认保存</el-button>
        </el-row>
      </el-card>
    </el-form>
  </div>
</template>

<script>
  import CategorySelect from "./components/CategorySelect";
  export default {
    name: "capacityFormPage",
    components: {
      CategorySelect
    },
    methods: {
      onSave() {
        this.$refs['form'].validate(valid => {
          if (valid) {
            if (this.formData.categoryCapacities.length < 1) {
              this.$message.error('请添加品类');
            } else {
              this._onSave();
              return true;
            }
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      async _onSave() {
        let postForm = Object.assign({}, this.formData);
        postForm.dateStartPoint = this.timestampToTime(this.dateRange[0]);
        postForm.dateEndPoint = this.timestampToTime(this.dateRange[1]);
        const url = this.apis().capacitySave();
        const result = await this.$http.post(url, this.formData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success('保存成功');
        this.$router.push('/product/capacity');
      },
      onDateChange(val) {
        this.$set(this.formData, "dateStartPoint", val[0]);
        this.$set(this.formData, "dateEndPoint", val[1]);
      },
      onInput(item) {
        this.$set(item, "capacityRange", item.capacityRange);
      },
      timestampToTime(timestamp) {
        const date = new Date(timestamp); // 时间戳为10位需*1000，时间戳为13位的话不需乘1000
        const M =
          (date.getMonth() + 1 < 10 ?
            "0" + (date.getMonth() + 1) :
            date.getMonth() + 1) + ""; // 当前月份(0-11,0代表1月)
        const D = date.getDate() + " "; // 当前日(1-31)
        return M + "." + D; // 此处可以自定义需要的显示类型
      },
    },
    created() {
      if (this.$route.params.formData != null) {
        this.formData = this.$route.params.formData;
        this.dateRange = [];
        this.dateRange.push(this.formData.dateStartPoint);
        this.dateRange.push(this.formData.dateEndPoint);
      } else {
        this.formData = this.$store.state.CapacityModule.formData;
      }
      //初始化
      this.categories = this.formData.categoryCapacities.map(categoryCapacity => {
        return categoryCapacity.category;
      });
    },
    data() {
      return {
        formData: {},
        dateRange: [],
        categories: [],
        categoryCapacities: [],
        rules: {
          title: [{
            required: true,
            message: '请输入标题',
            trigger: 'blur'
          }, ],
        }
      };
    }
  };

</script>
<style lang="scss" scoped>
  .info-title {
    width: 100%;
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
    height: 14px;
  }

  .info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 0.85);
  }

  .info-title-row {
    margin-bottom: 35px;
  }

  .info-title-row-2 {
    margin-top: 20px;
    font-weight: bold;
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    /* margin-top: 5px; */
    width: 60px;
    font-size: 12px;
    font-weight: 500;
  }

  .info-input-prepend2 {
    display: inline-block;
    margin: 0 5px;
    width: 20px;
    font-size: 12px;
    color: rgba(0, 0, 0, 0.45);
  }

  .product-form-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 150px;
  }

  .product-form-row {
    margin-top: 20px;
  }

  .capacity-form-row {
    margin-top: 20px;
  }

  .capacity-form-label {
    padding-left: 30px;
  }

  .capacity-form-info {
    font-size: 10px;
    color: grey;
  }

  .input-row-suffix {
    padding-top: 8px;
  }

</style>
