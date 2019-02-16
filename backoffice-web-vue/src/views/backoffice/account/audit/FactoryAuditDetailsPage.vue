<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <el-form ref="form" label-position="top" :model="slotData" :disabled="true">
        <el-row :gutter="10">
          <el-col :span="6">
            <el-form-item label="UID" prop="uid">
              <el-input v-model="slotData.uid" :disabled="!isNewlyCreated"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="工厂名称" prop="name">
              <el-input v-model="slotData.name"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="联系人" prop="contactPerson">
              <el-input v-model="slotData.contactPerson"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="手机号" prop="contactPhone">
              <el-input v-model="slotData.contactPhone"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="10">
          <el-col :span="6">
            <el-form-item label="邮箱" prop="email">
              <el-input v-model="slotData.email"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="座机" prop="phone">
              <el-input v-model="slotData.phone"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="经营地址" prop="address">
              <el-input v-model="slotData.address"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="合作品牌" prop="cooperativeBrand">
              <el-input v-model="slotData.cooperativeBrand"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="10">
          <el-col :span="6">
            <el-form-item label="月均产能" prop="monthlyCapacityRange">
              <el-select v-model="slotData.monthlyCapacityRange" class="w-100">
                <el-option v-for="item in monthlyCapacityRanges" :key="item.code" :label="item.name"
                           :value="item.code"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="产值规模" prop="scaleRange">
              <el-select v-model="slotData.scaleRange" class="w-100">
                <el-option v-for="item in scaleRanges" :key="item.code" :label="item.name"
                           :value="item.code"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="合作方式" prop="cooperationModes">
              <el-select v-model="slotData.cooperationModes" class="w-100" multiple>
                <el-option v-for="item in cooperationModes" :key="item.code" :label="item.name"
                           :value="item.code"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="车位数量" prop="latheQuantity">
              <el-input-number class="w-100" v-model="slotData.latheQuantity" :min="0"></el-input-number>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="10">
          <el-col :span="6">
            <el-form-item label="优势品类" prop="adeptAtCategories">
              <el-checkbox-group v-model="slotData.adeptAtCategories">
                <el-checkbox v-for="item in categories" :label="item.code" :key="item.code">
                  {{item.name}}
                </el-checkbox>
              </el-checkbox-group>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="开发能力" prop="developmentCapacity">
              <el-radio-group v-model="slotData.developmentCapacity">
                <el-radio :label="true">是</el-radio>
                <el-radio :label="false">否</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-card>

    <div class="pt-2"></div>

    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>认证信息</span>
      </div>
      <el-form ref="form" label-position="top" :model="slotData" :disabled="true">
        <el-row :gutter="10">
          <el-col :span="8">
            <el-form-item label="注册时间" prop="registrationDate">
              <el-date-picker class="w-100" type="month" placeholder="选择日期"
                              v-model="slotData.registrationDate"
                              :value-format="defaultDateValueFormat">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="税号" prop="taxNumber">
              <el-input v-model="slotData.taxNumber"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开户行" prop="bankOfDeposit">
              <el-input v-model="slotData.bankOfDeposit"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="10">
          <el-col :span="8">
            <el-form-item label="认证证件" prop="certificate">
              <img v-model="slotData.certificate"></img>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
    <div class="pt-2"></div>
    <el-row :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" type="primary" size="mini" @click="onApprove">
          同意
        </el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" size="mini" @click="onReject">
          拒绝
        </el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('AuditFactoriesModule');

  import CompanyMixin from "mixins/commerce/CompanyMixin";

  export default {
    name: "FactoryAuditDetailsPage",
    props: ["slotData", "isNewlyCreated"],
    components: {},
    mixins: [CompanyMixin],
    methods: {
      ...mapActions({
        refresh: "refresh"
      }),
      onApprove() {
        //调用审核通过接口
        this.$confirm("确认账号审核通过, 是否继续?", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }).then(() => this._onApprove());
      },
      async _onApprove() {
        const result = await this.$http.put("/djbackoffice/b2bUnit/approve", {
          uid: this.slotData.uid
        });

        if (result["errors"]) {
          this.$message.error("通过失败，原因：" + result["errors"][0].message);
          return;
        }

        this.$message.success("确认成功");
        this.refresh();
        this.fn.closeSlider(true);
      },
      onReject() {
        //调用审核拒绝接口
        this.$prompt("请输认不通过原因", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消"
        }).then(({value}) => {
          this._onReject(value);
        });
      },
      async _onReject(value) {
        const result = await this.$http.put("/djbackoffice/b2bUnit/reject", {
          uid: this.slotData.uid,
          comment: value
        });

        if (result["errors"]) {
          this.$message.error("拒绝失败，原因：" + result["errors"][0].message);
          return;
        }

        this.$message.success("拒绝成功");
        this.refresh();
        this.fn.closeSlider(true);
      },
      async getCategories() {
        this.categories = await this.$http.get("/djbackoffice/product/category/majors");
      }
    },
    created() {
      this.getCategories();
    },
    data() {
      return {
        categories: []
      };
    }
  };
</script>
