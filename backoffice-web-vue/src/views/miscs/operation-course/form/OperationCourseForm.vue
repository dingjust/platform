<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
      <span>基本信息</span>
    </div>
      <operation-course-basic-form ref="basicForm"
                           :slot-data="slotData"
                           :read-only="readOnly">
      </operation-course-basic-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
    <div slot="header" class="clearfix">
      <span>教程信息</span>
    </div>

        <operation-course-title-form ref="imageForm"
                             :slot-data="slotData"
                             :read-only="readOnly">
        </operation-course-title-form>


    </el-card>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import OperationCourseBasicForm from './OperationCourseBasicForm';
  import OperationCourseTitleForm from './OperationCourseTitleForm';

  export default {
    name: 'OperationCourseFrom',
    components: {
      OperationCourseBasicForm,
      OperationCourseTitleForm,
    },
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        return this.$refs['basicForm'].validate(callback);
      }
    },
    computed: {},
    data() {
      return {}
    }
  }
</script>
