<template>
  <div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <sample-product-basic-form :slot-data="slotData" :read-only="!isNewlyCreated"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>附件</span>
      </div>
      <sample-product-pictures-form :slot-data="slotData" :read-only="!isNewlyCreated"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div class="animated fadeIn">
        <el-button-group v-if="!isNewlyCreated">
          <el-button size="mini" type="primary" @click="onSubmit()">提交</el-button>
          <el-button size="mini" @click="onCancel">取消</el-button>
        </el-button-group>
      </div>
    </el-card>
  </div>
</template>

<script>
  import SampleProductBasicForm from '../form/SampleProductBasicForm';
  import SampleProductPicturesForm from '../form/SampleProductPicturesForm';

  export default {
    name: 'SampleProductForm',
    props: ['slotData'],
    components: {
      SampleProductBasicForm,
      SampleProductPicturesForm,
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    methods: {
      async onSubmit() {
        const url = this.apis().createSampleProduct();
        const result = await this.$http.post(url, this.slotData);
        if (result['errors']) {
          this.$message.error('获取数据失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$message.success('修改样衣成功，样衣编号：' + result);
        this.fn.closeSlider();
      },
      onCancel() {
        this.fn.closeSlider();
      }
    },
    data() {
      return {
        readOnly: false,
      }
    },
    created() {
    }
  }
</script>
