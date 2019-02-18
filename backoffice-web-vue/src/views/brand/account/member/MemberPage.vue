<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <el-tabs value="members" type="card">
        <el-tab-pane label="所有会员" name="members">
          <members-page/>
        </el-tab-pane>
        <el-tab-pane label="会员申请" name="memberRequests">
          <member-requests-page/>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
  import {
    MemberRequestsPage,
    MembersPage
  } from './';

  export default {
    name: 'MemberPage',
    components: {MemberRequestsPage, MembersPage},
    data() {
      return {};
    }
  };
</script>
