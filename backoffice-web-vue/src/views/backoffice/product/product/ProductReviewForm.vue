<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="评价标题" prop="product">
            <el-input v-model="slotData.product"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="评价标题" prop="headline">
            <el-input v-model="slotData.headline"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="内容" prop="comment">
            <el-input v-model="slotData.comment"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="等级" prop="rating">
            <el-input v-model="slotData.rating"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="15">
        <el-button class="btn-block" type="primary" size="mini" @click="onSubmit">保存</el-button>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    name: 'ProductReviewForm',
    components: {},
    props: ['slotData', 'readOnly', 'isNewlyCreated'],
    methods: {
      onSubmit() {
        console.log(this.slotData.product);
        let formData = Object.assign({}, this.slotData);
        console.log(formData);
        axios.post('/djbackoffice/product/reviews', formData)
          .then(response => {
            this.$message.success('创建成功，产品编码：');

          }).catch(error => {
            this.$message.error(error.response.data);
          }
        );
      }
    },
    computed: {},
    data() {
      return {};
    },
    created() {
    }
  };
</script>
