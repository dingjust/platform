<!--
* @Description: 托管
* @Date 2021/08/13 16:02
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>热门推荐</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <el-row type="flex" justify="end">
        <el-button type="danger" @click="onDelete">删除</el-button>
        <el-button type="primary" @click="visible=true">添加热门推荐</el-button>
      </el-row>
      <el-table ref="resultTable" :data="words" :height="autoHeight" row-key="id"
              @selection-change="handleSelectionChange" @row-click="rowClick">
        <el-table-column type="selection" :reserve-selection="true" width="55" />
        <el-table-column label="词" prop="word"></el-table-column>
      </el-table>
    </el-card>
    <el-dialog title="添加热门推荐" :visible.sync="visible" width="80%" :close-on-click-modal="false">
      <el-row v-if="visible">
        <el-tag
          :key="tag"
          v-for="tag in dynamicTags"
          closable
          size="medium"
          :disable-transitions="false"
          @close="handleClose(tag)">
          {{tag}}
        </el-tag>
        <el-input
          class="input-new-tag"
          v-if="inputVisible"
          v-model="inputValue"
          ref="saveTagInput"
          @keyup.enter.native="handleInputConfirm"
          @blur="handleInputConfirm"
        >
        </el-input>
        <el-button v-else class="button-new-tag" @click="showInput">+ 添加新热门推荐</el-button>
      </el-row>
      <el-row type="flex" justify="end">
        <el-button @click="visible=false">取消</el-button>
        <el-button type="primary" @click="onSumbit">确定</el-button>
      </el-row>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'RecommendWordPage',
  methods: {
    async onSearch () {
      const url = this.apis().searchRecommendWord()
      const result = await this.$http.post(url, {})

      if (result.code === 1) {
        this.words = result.data
      }
    },
    handleClose(tag) {
      this.dynamicTags.splice(this.dynamicTags.indexOf(tag), 1);
    },
    showInput() {
      this.inputVisible = true;
      this.$nextTick(_ => {
        this.$refs.saveTagInput.$refs.input.focus();
      });
    },
    handleInputConfirm() {
      if (!this.inputVisible) {
        return
      }

      let inputValue = this.inputValue;
      const flag = this.words.some(item => item.word === inputValue)

      if (inputValue && !this.dynamicTags.some(item => item === inputValue) && !flag) {
        this.dynamicTags.push(inputValue);
      } else if (this.dynamicTags.some(item => item === inputValue) || flag) {
        this.$message.warning('此热门推荐已存在')
      }
      this.inputVisible = false;
      this.inputValue = '';
    },
    handleSelectionChange (val) {
      this.multipleSelection = val
    },
    rowClick (row) {
      this.$refs.resultTable.toggleRowSelection(row)
    },
    onSumbit () {
      this.$confirm('是否添加热门推荐?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onSumbit()
      });
    },
    async _onSumbit () {
      const data = this.dynamicTags.map(item => {
        return {
          word: item
        }
      })

      const url = this.apis().batchSavesRecommend()
      const result = await this.$http.post(url, data)

      if (result.code === 1) {
        this.$message.success('操作成功！')

        this.onSearch()
        this.visible = false

        this.$nextTick(() => {
          this.$refs.resultTable.clearSelection()
        })
      } else if (result.code === 0) {
        this.$message.error(result.msg)
      } else {
        this.$message.error('操作失败！')
      }
    },
    onDelete () {
      if (this.multipleSelection.length <= 0) {
        this.$message.error('请先选择需求删除的热门推荐！')
      }

      this.$confirm('是否批量删除?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onDelete()
      });
    },
    async _onDelete () {
      const ids = this.multipleSelection.map(item => item.id).join(',')

      const url = this.apis().batchDelectRecommend()
      const result = await this.$http.delete(url, {
        ids: ids
      })

      if (result.code === 1) {
        this.$message.success('操作成功！')
        this.onSearch()
      } else if (result.code === 0) {
        this.$message.error(result.msg)
      } else {
        this.$message.error('操作失败！')
      }
    }
  },
  data () {
    return {
      words: [],
      visible: false,
      dynamicTags: [],
      inputVisible: false,
      inputValue: '',
      multipleSelection: []
    }
  },
  created () {
    this.onSearch();
  }
}
</script>

<style scoped>
  .el-tag + .el-tag {
    margin-left: 10px;
  }
  .button-new-tag {
    margin-left: 10px;
    height: 32px;
    line-height: 30px;
    padding-top: 0;
    padding-bottom: 0;
  }
  .input-new-tag {
    width: 90px;
    margin-left: 10px;
    vertical-align: bottom;
  }
</style>