<template>
  <div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <sample-checkout-hist-basic-form :slot-data="slotData" :read-only="canNotUpdate"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>附件</span>
      </div>
      <sample-checkout-hist-images-form :slot-data="slotData" :read-only="canNotUpdate"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div class="animated fadeIn">
        <el-button-group>
          <el-button size="mini" type="primary" @click="onSubmit()">提交</el-button>
          <el-button size="mini" @click="onCancel">取消</el-button>
        </el-button-group>
      </div>
    </el-card>
  </div>
</template>

<script>
  import SampleCheckoutHistBasicForm from '../form/SampleCheckoutHistBasicForm';
  import SampleCheckoutHistImagesForm from '../form/SampleCheckoutHistImagesForm';

  export default {
    name: 'SampleCheckoutHistForm',
    props: ['slotData'],
    components: {
      SampleCheckoutHistBasicForm,
      SampleCheckoutHistImagesForm,
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    methods: {
      async onSubmit() {
        const url = this.apis().updateSampleCheckoutHist(this.slotData.id);
        const result = await this.$http.put(url, this.slotData);
        if (result['errors']) {
          this.$message.error('获取数据失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$message.success('更新样衣借还记录成功，样衣编号：' + result);
        this.fn.closeSlider();
      },
      onCancel() {
        this.fn.closeSlider();
      }
    },
    data() {
      return {
          canNotUpdate:true,
      }
    },
    created() {
    }
  }
</script>
