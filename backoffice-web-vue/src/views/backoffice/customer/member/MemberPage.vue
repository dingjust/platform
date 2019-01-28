<template>
  <div class="animated fadeIn content">
    <el-tabs value="brandMember" type="border-card">
      <el-tab-pane name="brandMember">
        <span slot="label">
          <i class="el-icon-date"></i> 品牌会员
        </span>
        <brand-members-page/>
      </el-tab-pane>
      <el-tab-pane name="factoryMember">
        <span slot="label">
          <i class="el-icon-date"></i> 工厂会员
        </span>
        <factory-members-page/>
      </el-tab-pane>
      <el-tab-pane name="memberList">
        <span slot="label">
          <i class="el-icon-date"></i> 会员列表
        </span>
        <member-list-page/>
      </el-tab-pane>
      <el-tab-pane name="applicationList">
        <span slot="label">
          <i class="el-icon-date"></i> 会员申请
        </span>
        <application-list-page/>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import {
    BrandMembersPage,
    FactoryMembersPage,
    MemberListPage,
    ApplicationListPage
  } from "./";

  export default {
    name: "MemberPage",
    components: {
      BrandMembersPage,
      FactoryMembersPage,
      MemberListPage,
      ApplicationListPage
    }
  };
</script>
