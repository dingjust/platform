<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="organization-list-title">
            <h6>员工管理</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <personnel-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" 
                      @onCreate="onCreate" />
      <el-row type="flex" justify="start">
        <template v-for="(item, index) in statuses">
          <el-button @click="handleClick(item.code, index)" :key="item.code" class="state-btn" :style="item.backgroundColor">
            {{item.name}}
          </el-button>
        </template>
      </el-row>
      <personnel-list :page="page" @onAdvancedSearch="onAdvancedSearch" 
                      @onDetail="onDetail" @onForbidden="onForbidden" @onEnable="onEnable" @onDelete="onDelete" />
    </el-card>
  </div>
</template>

<script>
  import { createNamespacedHelpers } from 'vuex';
  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'PersonnelModule'
  );
  import PersonnelToolbar from './toolbar/PersonnelToolbar'
  import PersonnelList from './list/PersonnelList'
  export default {
    name: 'PersonnelPage',
    props: [],
    components: {
      PersonnelToolbar,
      PersonnelList
    },
    computed: {
      ...mapGetters({
        page: 'page',
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch (page, size) {
        const keyword = this.keyword;
        const url = this.apis().getB2BCustomers();
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch (page, size) {
        const query = this.queryFormData;
        const url = this.apis().getB2BCustomers();
        this.searchAdvanced({url, query, page, size});
      },
      handleClick (code, index) {
        this.statuses.forEach(item => item.backgroundColor = 'background-color: #FFFFFF');
        this.statuses[index].backgroundColor = 'background-color: #ffd60c';
        if (code === '') {
          this.$delete(this.queryFormData, 'enable');
        } else if (code === 'enabled') {
          this.$set(this.queryFormData, 'enable', false);
        } else if (code === 'forbidden') {
          this.$set(this.queryFormData, 'enable', true);
        }
        // this.queryFormData.state = code;
        this.onAdvancedSearch(0, 10);
      },
      onCreate () {
        this.$router.push('/account/create/personnel');
      },
      onDetail (row) {
        this.$router.push('/account/personnel/' + row.id);
      },
      onForbidden (row) {
        this.$confirm('禁用后员工将无法正常使用账号 ， 请问是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._changeLoginDisabled(row);
        });
      },
      onEnable (row) {
        this.$confirm('启用账号后账号将恢复正常使用 ， 请问是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._changeLoginDisabled(row);
        });
      },
      async _changeLoginDisabled (data) {
        const currentUser = this.$store.getters.currentUser;
        const url = this.apis().changeLoginDisabled(currentUser.uid);
        const result = await this.$http.put(url, data);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('更改员工账号状态成功');
        this.onSearch(0, 10);
      },
      onDelete (row) {
        this.$confirm('删除后员工将无法正常使用账号 ， 请问是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onDelete(row.uid);
        });
      },
      async _onDelete (uid) {
        const url = this.apis().removeB2BCustomer(uid);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('删除账号成功');
        this.onSearch(0, 10);
      },
    },
    data () {
      return {
        queryFormData: {
          keyword: '',
          roleGroupName: '',
          deptName: ''
        },
        statuses: [{
          code: '',
          name: '全部',
          backgroundColor: 'background-color: #ffd60c'
        }, {
          code: 'enabled',
          name: '启用',
          backgroundColor: 'background-color: #FFFFFF'
        }, {
          code: 'forbidden',
          name: '禁用',
          backgroundColor: 'background-color: #FFFFFF'
        }] 
      }
    },
    created () {
      this.onAdvancedSearch(0, 10);
    },
    destroyed () {

    }    
  }
</script>

<style scoped>
  .organization-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .state-btn {
    /* background-color: #ffd60c; */
    color: #000;
    width: 75px;
    height: 30px;
    border-radius: 5px;
  }
</style>