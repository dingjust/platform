<template>
  <div class="animated fadeIn tags-of-text">
   <el-row type="flex" style="margin-bottom: 10px">
     <el-input placeholder="请输入关键词"  v-model="keywordInput" size="mini" style="width: 300px">
       <el-button slot="append" @click="onKeywordAdd">添加关键词</el-button>
     </el-input>
   </el-row>
    <el-row>
      <el-tag class="elTagTextClass"
              style="margin-right: 10px"
              v-if="textData != ''"
              v-for="keyword of keywords"
              @close="onKeywordRemove(keyword)"
              closable>
        {{keyword}}
      </el-tag>
    </el-row>
  </div>
</template>
<script>
  export default {
    name: 'TagsOfText',
    props: ['textData', 'symbol'],
    computed: {
      keywords: function () {
        return this.textData.split(this.symbol);
      }
    },
    methods: {
      onKeywordRemove (keywrod) {
        console.log(keywrod);
        this.$emit('remove', keywrod);
      },
      onKeywordAdd () {
        if (this.keywordInput !== '' && this.keywordInput.trim() !== '') {
          this.$emit('add', this.keywordInput.trim());
          this.keywordInput = '';
        }
      }
    },
    data () {
      return {
        keywordInput: ''
      }
    }
  };
</script>

<style>
  .tags-of-text  .elTagTextClass{
    color: #0b0e0f;
    /*background-color: #ffd60c;*/
  }
  /*.tags-of-text .el-tag--small{*/
  /*height: 32px;*/
  /*padding: 0 11px;*/
  /*line-height: 31px;*/
  /*}*/
</style>
