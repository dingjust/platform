<!--
* @Description: 合作商认证信息详情
* @Date 2021/03/26 17:49
* @Author L.G.Y
-->
<template>
  <div style="margin-left: 30px" >
    <el-row>
      <h6 class="detail-title">认证类型：{{AuthenticationType === 0 ? '企业认证' : '个人认证'}}</h6>
    </el-row>
    <template v-if="AuthenticationType === 0">
      <template v-for="row in strRows">
        <el-row :key="row.value">
          <h6 class="detail-title">{{row.name}}
            <span :style="!detail[row.value] ? 'color: #909399' : ''"> 
              {{detail[row.value] ? detail[row.value] : '暂无信息'}}
            </span>
          </h6>
        </el-row>
      </template>
      <template v-for="row in objRows">
        <el-row :key="row.value">
          <h6 class="detail-title">{{row.name}}
            <span :style="!detail[row.value] ? 'color: #909399' : ''"> 
              {{detail[row.value] ? '' : '暂无信息'}}
            </span>
          </h6>
          <template v-if="detail[row.value]">
            <template v-for="contact in row.children">
              <el-row :key="contact.value" style="margin-left: 30px">
                <h6 class="detail-title">{{contact.name}}
                  <span :style="!detail[row.value][contact.value] ? 'color: #909399' : ''"> 
                    {{detail[row.value][contact.value] ? detail[row.value][contact.value] : '暂无信息'}}
                  </span>
                </h6>
              </el-row>
            </template>
          </template>
        </el-row>
      </template>
      <!-- TODO 显示经营执照 -->
      <el-row type="flex">
        <h6 class="detail-title">经营执照：<span v-if="!detail.certImg" style="color: #909399">暂无信息</span></h6>
        <el-image v-if="detail.certImg"
          style="width: 100px; height: 100px; border-radius: 5px;"
          :src="certImg.url"
          :preview-src-list="[certImg.url]">
        </el-image>
      </el-row>
    </template>
    <template v-else>
      <template v-for="row in personRows">
        <el-row :key="row.value">
          <h6 class="detail-title">{{row.name}}
            <span :style="!detail[row.value] ? 'color: #909399' : ''"> 
              {{detail[row.value] ? detail[row.value] : '暂无信息'}}
            </span>
          </h6>
        </el-row>
      </template>
    </template>
  </div>
</template>

<script>
export default {
  name: 'CoopetatorAuthDetail',
  props: ['uid'],
  data () {
    return {
      // 企业认证信息
      strRows: [
        {
          name: '公司名称：',
          value: 'name'
        }, {
          name: '公司编号：',
          value: 'companyCode'
        }, {
          name: '信用代码：',
          value: 'organization'
        },{
          name: '银行名称：',
          value: 'bankName'
        },{
          name: '支行名称：',
          value: 'bankDetailName'
        },{
          name: '银行账号：',
          value: 'bankCardNo'
        }
      ],
      objRows: [
        {
          name: '法人：',
          value: 'legal',
          children: [
            {
              name: '姓名：',
              value: 'name'
            }, {
              name: '联系方式：',
              value: 'mobile'
            }, {
              name: '身份证：',
              value: 'idCardNum'
            }
          ]
        }, 
        {
          name: '代理人：',
          value: 'agent',
          children: [
            {
              name: '姓名：',
              value: 'name'
            }, {
              name: '联系方式：',
              value: 'mobile'
            }, {
              name: '身份证：',
              value: 'idCardNum'
            }
          ]
        }
      ],
      // 个人认证信息
      personRows: [
        {
          name: '认证用户：',
          value: 'name'
        }, {
          name: '联系方式：',
          value: 'mobile'
        }, {
          name: '身份证：',
          value: 'idCard'
        }
      ],
      detail: {},
      AuthenticationType: 0
    }
  },
  methods: {
    async getDetail () {
      const url = this.apis().getCooperatorAuthDetail(this.uid);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.detail = result.data;
      this.AuthenticationType = result.resultCode;
    }
  },
  created () {
    this.getDetail();
  }
}
</script>

<style scoped>
  .detail-title {
    font-size: 14px;
    color: #606266;
  }
</style>
