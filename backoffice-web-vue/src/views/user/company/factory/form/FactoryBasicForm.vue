<template>
  <div class="animated fadeIn factory-basic">
      <el-row>
        <div class="titleClass">
          <h6>基本信息</h6>
        </div>
      </el-row>
      <div style="margin: 20px 20px 40px 40px">
        <el-row type="flex" justify="start" align="center">
            <el-col :span="2">
              <h6>
                上传头像：
              </h6>
              <h6 style="color: grey">
                (最多一张)
              </h6>
            </el-col>
            <el-col :span="6">
              <images-upload :limit="1" :slot-data="this.profilePictures"/>
            </el-col>
            <el-col :span="2" style="margin-left: 20px">
              <h6>
                上传资质荣誉照片：
              </h6>
              <h6 style="color: grey">
                (最多五张)
              </h6>
            </el-col>
            <el-col :span="14">
              <images-upload :limit="5" :slot-data="formData.certificates" />
            </el-col>
        </el-row>
        <el-row class="rowClass">
          <el-form-item>
            <el-row type="flex">
              <el-col :span="2">
                <h6 class="titleTextClass">公司名称</h6>
              </el-col>
              <el-col :span="22">
                <el-input placeholder="请填写公司名称" v-model="formData.name" size="mini" :disabled="formData.approvalStatus === 'approved'"></el-input>
              </el-col>
            </el-row>
          </el-form-item>
        </el-row>
        <el-row class="rowClass">
          <el-form-item class="purchase-form-item">
            <el-row type="flex">
              <el-col :span="2">
                <h6 class="titleTextClass">自选标签</h6>
              </el-col>
              <el-col :span="22" >
                <el-select v-model="formData.labels" multiple value-key="id" size="mini" placeholder="请选择">
                  <el-option
                    v-for="item in labels"
                    :key="item.id"
                    :label="item.name"
                    :value="item">
                  </el-option>
                </el-select>
              </el-col>
            </el-row>
          </el-form-item>
        </el-row>
      </div>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapMutations} = createNamespacedHelpers('FactoriesModule');
  import ImagesUpload from '../../../../../components/custom/ImagesUpload';

  export default {
    name: 'FactoryBasicForm',
    props: ['formData'],
    components: {ImagesUpload},
    computed: {
      ...mapGetters({
        labels: 'labels'
      })
    },
    methods: {
      ...mapMutations({
        setLabels: 'setLabels'
      }),
      async getLabels () {
        const url = this.apis().getGroupLabels('FACTORY');
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setLabels(result);
      }
    },
    data () {
      return {
        profilePictures: []
      };
    },
    watch: {
      'profilePictures': function (n, o) {
        console.log(n);
        if (n != null && n.length > 0) {
          this.formData.profilePicture = n[0];
        } else {
          this.formData.profilePicture = null;
        }
      }
    },
    created () {
      if (this.labels <= 0) {
        this.getLabels();
      }
      this.profilePictures = [this.formData.profilePicture];
    }
  };
</script>

<style>
  .factory-basic .rowClass{
    margin-top:20px;
  }

  .factory-basic .titleClass{
    padding: 10px 0px 1px 10px;
    background-color: #DCDCDC;
  }

 .factory-basic .el-col-24 {
   width: auto;
  }

  .factory-basic .factory-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .factory-basic .factory-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .factory-basic .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    width: 70px;
    font-weight: bold;
    font-size: 10px;
  }

  .factory-basic .titleTextClass{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-size: 10px;
    font-weight: bold;
  }

  .factory-basic .el-input--mini .el-input__inner{
    width: 100%;
  }

</style>
