<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>颜色</span>
      </div>
      <color-base-form ref="baseForm" :slot-data="slotData" :is-newly-created="isNewlyCreated"></color-base-form>
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
  import {mapActions} from 'vuex';

  import ColorBaseForm from "./ColorBaseForm";

  export default {
    name: "ColorForm",
    components: {ColorBaseForm},
    props: ["slotData"],
    methods: {
      ...mapActions({
        refresh: "ColorsModule/refresh"
      }),
      onSubmit() {
        this.$refs["baseForm"].validate(valid => {
          if (!valid) {
            return false;
          }

          this._create(this.slotData);

          return true;
        });
      },
      onCancel() {
        this.fn.closeSlider();
      },
      async _create(item) {
        const response = await this.$http.post("/djbackoffice/product/color", item);
        if (response["errors"]) {
          this.$message.error(response["errors"][0].message);
          return;
        }

        this.$message.success("保存成功");
        this.refresh();
        this.fn.closeSlider(true);
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
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
