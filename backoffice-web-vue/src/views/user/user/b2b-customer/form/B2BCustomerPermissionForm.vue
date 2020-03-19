<template>
  <div class="animated fadeIn">
    <el-row>
<!--      <el-form-item>-->
<!--        <template slot="label">-->
<!--          <h6 class="titleTextClass">权限选择</h6>-->
<!--        </template>-->
<!--      </el-form-item>-->
<!--      <el-button style="background-color: #FFD60C" @click="handleCheckAllChange" size="mini">全选</el-button>-->
<!--      <el-button native-type="reset" @click="onReset" size="mini">重置</el-button>-->
      <b2-b-customer-authority-tree1 :formData="formData" ref="authorityTree"/>
    </el-row>
  </div>
</template>

<script>
    import B2BCustomerAuthorityTree1 from '../tree/B2BCustomerAuthorityTree1';
    export default {
      name: 'B2BCustomerPermissionForm',
      props: ['formData'],
      components: {B2BCustomerAuthorityTree1},
      data () {
        return {
        };
      },
      methods: {
        setCheckChange (data) {
          this.$refs.authorityTree.setCheckChange(data);
        },
        setCheckRoleList (data) {
          this.$refs.authorityTree.setCheckRoleList(data);
        },
        handleCheckAllChange () {
          this.$refs.authorityTree.handleCheckAllChange();
        },
        onReset () {
          this.$refs.authorityTree.onReset([]);
        }
      }
    }
</script>

<style scoped>
  .titleTextClass {
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 60px;
    font-size: 14px;
  }

  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .buttonClass{
    padding: 10px 120px 0px 120px;
    margin-top: 40px;
    background-color: #ffd60c;
    color: #0b0e0f;
    border-radius: 8px;
  }

</style>
