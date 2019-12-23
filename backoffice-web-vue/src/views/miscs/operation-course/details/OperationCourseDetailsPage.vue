<template>
  <div class="animated fadeIn">
    <operation-course-form-toolbar :read-only="isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel" @onUpdate="onUpdate"/>
    <div class="pt-2"></div>
    <operation-course-form ref="form" :slot-data="slotData" :read-only="isNewlyCreated"/>
    <div class="pt-2"></div>
    <operation-course-form-toolbar :read-only="isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel" @onUpdate="onUpdate"/>
    <el-dialog v-if="isTenant()" title="修改" :modal="false"
               :visible.sync="updateDialogVisible"
               :show-close="false" append-to-body width="50%" :close-on-click-modal="false">
      <operation-course-form ref="form2" :slot-data="slotData" :read-only="true"/>
      <span slot="footer" class="dialog-footer">
        <el-button @click="updateDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="updateSubmit">确 定</el-button>
      </span>

    </el-dialog>
  </div>


</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('OperationCoursesModule');

  import OperationCourseFormToolbar from '../toolbar/OperationCourseFormToolbar';
  import OperationCourseForm from '../form/OperationCourseForm';

  export default {
    name: 'OperationCourseDetailsPage',
    props: ['slotData'],
    components: {OperationCourseFormToolbar, OperationCourseForm},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onUpdate(){
        this.updateDialogVisible = true;
      },
      async updateSubmit(){
          const url = this.apis().updateOperationCourse();
          const result = await this.$http.put(url, this.slotData);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.$message.success('修改成功');
          this.updateDialogVisible = false;
      },
      onSubmit() {
        console.log(this.slotData);
        this.$refs['form'].validate((valid)=> {
          if(valid){
            this._onSubmit();
          }

        })
      },
      onCancel() {
        this.fn.closeSlider();
      },
      async _onSubmit() {
        let formData = this.slotData;

        const url = this.apis().createOperationCourse();
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('保存成功');
        this.$set(this.slotData, 'name', result);
        const searchUrl = this.apis().getOperationCourses();
        this.refresh(searchUrl);
        this.fn.closeSlider(true);
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id == null;
      }
    },
    data() {
      return {updateDialogVisible:false,}
    }
  }
</script>
