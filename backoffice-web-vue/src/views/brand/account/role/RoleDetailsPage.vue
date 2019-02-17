<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <role-base-form :slot-data="slotData"
                      :read-only="true"
                      :is-newly-created="isNewlyCreated">
      </role-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>权限</span>
      </div>
      <role-perms-form ref="permsForm"
                       :slot-data="slotData"
                       :read-only="true"
                       :is-newly-created="isNewlyCreated">
      </role-perms-form>
      <el-row :gutter="10">
        <el-col :span="24">
          <el-button class="btn-block" type="primary" size="mini" @click="onUpdatePerms()">更新</el-button>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import axios from 'axios';
  import RoleBaseForm from './RoleBaseForm';
  import RolePermsForm from './RolePermsForm';

  export default {
    name: 'RoleDetailsPage',
    components: {RoleBaseForm, RolePermsForm},
    props: ['slotData', 'isNewlyCreated', 'preview'],
    methods: {
      onClose() {
        this.fn.closeSlider();
      },
      onUpdatePerms() {
        const perms = this.$refs['permsForm'].getValue();

        this.$confirm('是否确认更新', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          axios.put('/djbrand/role/' + this.slotData.uid + '/perms', perms)
            .then(() => {
              this.$message.success('更新权限成功');
            }).catch(error => {
              console.log(JSON.stringify(error.response.data));
            }
          )
        }).catch(() => {
        });


      }
    },
    computed: {},
    data() {
      return {}
    }
  }
</script>
