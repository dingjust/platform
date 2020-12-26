<!-- 
 * @description: 公司选择组件
 * @fileName: CompanySelect.vue 
 * @author: yj 
 * @date: 2020-08-11 16:58:38
 * @version: V1.0.0 
!-->
<template>
  <div style="width:100%" class="company-select">
    <el-row type="flex" align="middle" justify="center" style="margin-bottom:20px">
      <el-col :span="8">
        <el-input v-model.trim="keyword" placeholder="输入公司名称或账号"></el-input>
      </el-col>
      <el-button @click="onSearch" style="margin-left:10px" type="warning" plain>搜索</el-button>
    </el-row>
    <el-row type="flex" justify="center">
      <h6 class="message">注：确保公司名称与账号都对，避免选错用户</h6>
    </el-row>
    <el-row type="flex" justify="center">
      <el-col :span="20">
        <el-card shadow="hover">
          <el-table :data="data" height="400" v-loadmore="loadMore" stripe highlight-current-row ref="table"
            @current-change="handleCurrentChange">
            <el-table-column label="公司名称" prop="name" align="center"></el-table-column>
            <el-table-column label="账号" align="center">
              <template slot-scope="scope">
                {{phoneNumEncode(scope.row.contactUid)}}
              </template>
            </el-table-column>
            <el-table-column label="认证状态" align="center">
              <template slot-scope="scope">
                <el-tag type="success" v-if="scope.row.approvalStatus!=null&&scope.row.approvalStatus=='approved'">
                  {{getEnum('AuthApprovalStatus', scope.row.approvalStatus)}}
                </el-tag>
                <el-tag type="info" v-else>未认证</el-tag>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" style="margin-top:20px">
      <el-button round class="submit-btn" @click="onSubmit">确定</el-button>
    </el-row>
  </div>
</template>


<script>
  export default {
    name: 'CompanySelect',
    components: {

    },
    props: {

    },
    methods: {
      async onSearch(page, size) {
        if (!this.validate()) {
          return null;
        }
        //重置页面数据
        this.page = 0;
        const url = this.apis().findBrandAndFactory();
        const result = await this.$http.post(url, {
          keyword: this.keyword
        }, {
          page: this.page,
          size: this.size
        });

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.data = result.content;

        //回滚顶部
        this.$refs.table.bodyWrapper.scrollTop = 0;
      },
      validate() {
        if (this.keyword == '') {
          this.$message.error('请输入关键字');
          return false;
        }
        return true;
      },
      async loadMore() {
        this.page++;
        const url = this.apis().findBrandAndFactory();
        const result = await this.$http.post(url, {
          keyword: this.keyword
        }, {
          page: this.page,
          size: this.size
        });

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.data = this.data.concat(result.content);
      },
      handleCurrentChange(val) {
        this.selectedData = val;
      },
      onSubmit() {
        if (this.selectedData.uid == this.currentUser.companyCode) {
          this.$message.error('不能选择自己公司作为合作商');
        } else {
          this.$emit('onSubmit', this.selectedData);
        }
      },
      phoneNumEncode(str) {
        if (str == null) {
          return '';
        }

        if (str.length > 6) {
          return str.substr(0, 3) + '*****' + str.substr(str.length - 4, 3);
        } else if (str.length > 3) {
          return str.substr(0, 1) + '***' + str.substr(str.length - 1, 1);
        } else {
          return '***';
        }
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        keyword: '',
        page: 0,
        size: 20,
        data: [],
        selectedData: ''
      };
    },
    created() {

    },
    directives: {
      //el-table滚动加载更多
      loadmore: {
        // 指令的定义
        bind(el, binding) {
          const selectWrap = el.querySelector('.el-table__body-wrapper')
          selectWrap.addEventListener('scroll', function () {
            let sign = 0
            const scrollDistance = this.scrollHeight - this.scrollTop - this.clientHeight
            if (scrollDistance <= sign) {
              binding.value()
            }
          })
        }
      }
    }
  }

</script>

<style scoped>
  .company-select>>>.current-row td {
    background-color: #FFD60C !important;
  }

  .submit-btn {
    background-color: #FFD60C;
    border-color: #FFD60C;
    width: 200px;
  }

  .message {
    color: red;
  }

</style>
