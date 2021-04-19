<template>
  <el-container>
    <el-main>
      <el-row
        type="flex"
        justify="start"
      >
        <el-col :span="4">
          <span>合同状态:{{getEnum('contractStates', slotData.state)}}</span>
        </el-col>
        <el-col :span="6">
          <span>合同编号:{{slotData.code}}</span>
        </el-col>
      </el-row>
      <el-row class="contract_custom-row contract_title text-align-center">
        <span>{{slotData.title}}</span>
      </el-row>
      <el-row>
        <div class="contract_custom-fixed_terms">
          <Viewer
            :value="slotData.content"
            class="contract_custom-viewer"
          />
        </div>
      </el-row>
    </el-main>
    <el-aside width="73px">
      <div class="dialog-aside_buttons">
        <el-button-group>
          <el-button v-if="slotData.state == 'SIGN' || slotData.state == 'PARTY_A_SIGN' || slotData.state == 'PARTY_B_SIGN'" icon="el-icon-edit" @click="onSearchSeal" >签署</el-button>
          <el-button icon="el-icon-share"  @click="onDownload(slotData.code)">下载</el-button>
          <el-button v-if="slotData.state == 'SIGN' || slotData.state == 'PARTY_A_SIGN' || slotData.state == 'PARTY_B_SIGN'" icon="el-icon-delete"  @click="onRefuse()">拒签</el-button>
        </el-button-group>
      </div>
    </el-aside>
  </el-container>
</template>

<script>
// import "tui-editor/dist/tui-editor.css";
// import "tui-editor/dist/tui-editor-contents.css";
// import "highlight.js/styles/github.css";
// import "codemirror/lib/codemirror.css";
import { Viewer, Editor } from "@toast-ui/vue-editor";
import http from '@/common/js/http';
export default {
  name: "ContractDetails",
  props: ["slotData"],
  data() {
    return {
      input1: "",
      input2: "",
      viewerText:
        "",
      dialogSealVisible:false,
    };
  },
  methods:{
    async onRefuse(){
      const url = this.apis().refuseContract(slotData.code);
      const result = await this.$http.get(url);

      this.$message.error(result.msg);
    },
    async onDownload(code){
      const url = this.apis().downContract(code);
      const result = await http.get(url);

      window.location.href = 'http://localhost:8081/b2b/user/agreement/download/' + result.data;

    },
    async onSearchSeal(keyword,page, size) {
      this.contractCode = slotData.code;
      if(keyword == null){
        keyword = '';
      }
      const url = this.apis().getSealsList();
      const result = await this.$http.post(url,{
        keyword: keyword
      }, {
        page: page,
        size: 10
      });
      if (result["errors"]) {
        this.$message.error(result["errors"][0].message);
        return;
      }
      this.sealPage = result;
      this.dialogSealVisible=true
    },
  },
  components: {
    Viewer,
    Editor
  },
  computed: {
    contractName() {
      return this.propdata.contractName;
    }
  },
  watch: {
    propdata(newValue, oldValue) {
    }
  }
};
</script>

<style lang="scss" scoped>
.contract_custom-row {
  // margin: 20px 0;
}

.contract_title {
  margin-top: 20px;
}

.text-align-center {
  text-align: center;
  color: #000;
  font-size: 20px;
  font-weight: bold;
}

.contract_custom-fixed_terms {
  padding: 20px;
  // border: 1px solid #969696;
  //   border-radius: 10px;
}

.contract_custom-viewer {
  min-height: 300px;
}
.dialog-aside_buttons {
  margin-top: 200px;
}
</style>
