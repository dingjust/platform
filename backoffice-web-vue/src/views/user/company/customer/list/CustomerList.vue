<template>
  <div class="recommend-code-list">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="名称" prop="name">
        <template slot-scope="scope">
          <span>{{scope.row.name}}<span v-if="scope.row.root" style="color: #F56C6C"> (主账号)</span></span>
        </template>
      </el-table-column>
      <el-table-column label="id" prop="id"></el-table-column>
      <el-table-column label="uid" prop="uid"></el-table-column>
      <el-table-column label="联系方式" prop="contactPhone"></el-table-column>
      <el-table-column label="受邀渠道码" prop="channelCode"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-dropdown @command="handleCommand($event, scope.row)" trigger="click">
            <span class="el-dropdown-link">
              更多操作<i class="el-icon-arrow-down el-icon--right"></i>
            </span>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="INVITE">查看邀约列表</el-dropdown-item>
              <el-dropdown-item command="RECOMMEND_CODE">更新渠道码</el-dropdown-item>
              <el-dropdown-item command="QRCODE">查看二维码</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <el-dialog title="用户二维码" :visible.sync="qrCodeVisible" width="400px" append-to-body :close-on-click-modal="false">
      <el-row type="flex" justify="center" align="middle">
        <div id="qrCode" ref="qrCodeDiv"></div>
      </el-row>
      <el-row type="flex" justify="end" style="margin-top: 10px">
        <el-button type="primary" @click="onDownload">下载</el-button>
      </el-row>
    </el-dialog>
    <el-dialog :visible.sync="inviteVisible" width="80%" append-to-body :close-on-click-modal="false">
      <invite-list v-if="inviteVisible" :id="handleRow.id" />
    </el-dialog>
    <el-dialog :visible.sync="selectVisible" width="80%" append-to-body :close-on-click-modal="false">
      <customer-select-page v-if="selectVisible" @setRecommendCode="setRecommendCode"/>
    </el-dialog>
  </div>
</template>

<script>
import QRCode from 'qrcodejs2';
import InviteList from '../components/InviteList.vue';
import CustomerSelectPage from '../components/CustomerSelectPage.vue';

export default {
  name: 'CustomerList',
  components: { InviteList, CustomerSelectPage },
  props: ['page'],
  methods: {
    handleCommand (command, row) {
      switch (command) {
        case 'INVITE':
          this.onInviteList(row);
          break;
        case 'RECOMMEND_CODE':
          this.updateRecommendCode(row);
          break;
        case 'QRCODE':
          this.onQRCode(row);
          break;
        default:
          break;
      }
    },
    onInviteList (row) {
      this.handleRow = row;
      this.inviteVisible = true;
    },
    updateRecommendCode (row) {
      this.handleRow = row;
      this.selectVisible = true;
    },
    setRecommendCode (row) {
      const h = this.$createElement;

      this.$msgbox({
        title: '提示',
        message: h('div', null, [
          h('p', {style: 'margin-bottom: 10px'}, '正在进行更新渠道码操作，请确认以下信息是否正确'),
          h('p', {style: 'margin-left: 20px'}, ('工厂编号：' + this.handleRow.uid)),
          h('p', {style: 'margin-left: 20px'}, ('工厂名称：' + this.handleRow.name)),
          h('p', {style: 'margin-left: 20px'}, ('渠道码编号：' + row.id)),
        ]),
        showCancelButton: true,
        confirmButtonText: '确定',
        cancelButtonText: '取消',
      }).then(() => {
        this._setRecommendCode(row.id);
      })
    },
    async _setRecommendCode (recommendCode) {
      const id = this.handleRow.id;

      const url = this.apis().updateRecommendCode();
      const result = await this.$http.post(url, {}, {
        id: id,
        channelCode: recommendCode
      });

      if (result.code === 1) {
        this.$message.success('操作成功！');
        this.selectVisible = false;
        this.$emit('onAdvancedSearch');
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('操作失败！');
      }
    },
    onQRCode (row) {
      this.qrCodeVisible = true;
      this.handleRow = row;

      // 如果已经生成过qrcode，在这一步清理
      if (this.$refs.qrCodeDiv && this.$refs.qrCodeDiv.innerHTML) {
        this.$refs.qrCodeDiv.innerHTML = '';
      }

      this.$nextTick(() => {
        new QRCode(this.$refs.qrCodeDiv, {
          text: "https://ht.nbyjy.net/app/page/register?channelCode=" + row.id,
          width: 200,
          height: 200,
          colorDark: "#333333", //二维码颜色
          colorLight: "#ffffff", //二维码背景色
          correctLevel: QRCode.CorrectLevel.H //容错率，L/M/H
        });
      })
    },
    onDownload () {
      const qrCodeDiv = document.getElementById('qrCode');
      const qrCode = qrCodeDiv.getElementsByTagName('img')[0]; 
      
      const url = qrCode.src;                            // 获取图片地址
      let a = document.createElement('a');          // 创建一个a节点插入的document
      const event = new MouseEvent('click')           // 模拟鼠标click点击事件
      a.download = this.handleRow.uid;                  // 设置a节点的download属性值
      a.href = url;                                 // 将图片的src赋值给a节点的href
      a.dispatchEvent(event)     
    },
    onPageSizeChanged(val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged(val) {
      this.$emit('onAdvancedSearch', val - 1);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    }
  },
  data () {
    return {
      qrCodeVisible: false,
      inviteVisible: false,
      selectVisible: false,
      handleRow: null
    }
  }
}
</script>

<style scoped>
  .el-dropdown-link {
    cursor: pointer;
    color: #409EFF;
    font-size: 12px;
  }
  .el-icon-arrow-down {
    font-size: 12px;
  }
</style>