<template>
  <div class="animated fadeIn category-basic">
    <el-row class="category-info-title-row">
      <div class="category-info-title">
        <h6 class="category-info-title_text">{{operationStateName}}</h6>
      </div>
    </el-row>
    <div class="titleCardClass">
      <div slot="header" class="titleClass">
        <span>分类图标</span>
      </div>
      <el-row class="category-info-title-row categoryt-form">
        <images-upload :limit="1" :slot-data="images" />
      </el-row>
      <div slot="header" class="titleClass">
        <span>产品分类</span>
      </div>
      <div style="margin: 15px 15px 15px 15px">
        <el-form ref="form" label-position="top" :model="slotData" :rules="rules" >
          <el-row type="flex" align="middle" :gutter="20">
            <el-col :span="8">
              <el-form-item label="编码" prop="code">
                <el-input v-model="slotData.code" :disabled="operationType === 'update'"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="名称" prop="name">
                <el-input v-model="slotData.name"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="分组" prop="group">
                <el-select v-model="slotData.group" class="w-100">
                  <el-option v-for="item in groups" :key="item.code" :label="item.name" :value="item.code"></el-option>
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex" align="middle" :gutter="20">
            <el-col :span="8">
              <el-form-item label="父分类" prop="parent">
                <el-input v-model="slotData.parent.name" disabled></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="描述" prop="description">
                <el-input v-model="slotData.description"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </div>
    </div>
    <el-row class="categoryt-form" type="flex" justify="center" align="middle" :gutter="100">
      <el-col :span="6">
        <el-button class="btn-block" size="mini" type="primary" @click="onSubmit">
          提交
        </el-button>
      </el-col>
      <el-col :span="6">
        <el-button class="btn-block" size="mini" @click="onCancel">
          取消
        </el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('CategoriesModule');

  import CategoryIconForm from './CategoryIconForm';
  import CategoryGroupMixin from 'mixins/commerce/CategoryGroupMixin';
  import ImagesUpload from '../../../../components/custom/ImagesUpload';

  export default {
    name: 'CategoryForm',
    components: {ImagesUpload, CategoryIconForm},
    mixins: [CategoryGroupMixin],
    props: ['slotData', 'readOnly', 'operationType'],
    computed: {
      operationStateName () {
        if (this.operationType === 'create') {
          return '添加子分类';
        }
        return '修改';
      }
    },
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onSubmit () {
        this.$refs.form.validate(valid => {
          if (!valid) {
            return false;
          }
          if (this.operationType === 'create') {
            this._onSubmit();
          } else {
            this._onUpdate();
          }
          return true;
        });
      },
      onCancel () {
        // const searchUrl = this.apis().getCategories();
        // this.refresh({url: searchUrl});
        this.$emit('operationTypeTurn');
      },
      async _onUpdate () {
        var thumbnail = null;
        if (this.images != null) {
          thumbnail = this.images[0];
        }
        let formData = {
          name: this.slotData.name,
          description: this.slotData.description,
          parent: this.slotData.parent,
          code: this.slotData.code,
          group: this.slotData.group,
          thumbnail: thumbnail
        };
        const url = this.apis().createCategories();
        const result = await this.$http.put(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('修改成功');
        const searchUrl = this.apis().getCategories();
        this.refresh({url: searchUrl});
        this.$emit('operationTypeTurn');
      },
      async _onSubmit () {
        var thumbnail = null;
        if (this.images != null) {
          thumbnail = this.images[0];
        }
        let formData = {
          name: this.slotData.name,
          description: this.slotData.description,
          parent: this.slotData.parent,
          code: this.slotData.code,
          group: this.slotData.group,
          thumbnail: thumbnail
        };
        const url = this.apis().createCategories();
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('保存成功');
        const searchUrl = this.apis().getCategories();
        this.refresh({url: searchUrl});
        this.$emit('operationTypeTurn');
      }
    },
    data () {
      return {
        rules: {
          code: [{required: true, message: '必填', trigger: 'blur'}],
          name: [{required: true, message: '必填', trigger: 'blur'}]
        },
        images: []
      }
    },
    created () {
      if (this.slotData.thumbnail != null) {
        this.images.push(this.slotData.thumbnail);
      }
    }
  };
</script>

<style scoped>
  .category-info-title-row {
    margin-bottom: 20px;
  }
  .categoryt-form {
    margin-left: 20px;
    margin-top: 20px;
  }
  .category-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }
  .category-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }
  .category-basic .titleClass{
    padding: 10px 0px 1px 10px;
    background-color: #DCDCDC;
  }
  .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }
</style>
