<template>
  <div class="animated fadeIn tags-of-text">
   <el-row type="flex" style="margin-bottom: 10px">
     <el-input :placeholder="placeholder"  v-model="keywordInput" size="mini" style="width: 300px">
       <el-button slot="append" @click="onKeywordAdd">添加{{label}}</el-button>
     </el-input>
   </el-row>
    <el-row v-if="textData != null && textData != ''">
      <el-tag class="elTagTextClass"
              style="margin-right: 10px"
              v-for="keyword of keywords"
              :key="keyword"
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
    props: {
      textData: {
        type: String,
        default: ''
      },
      symbol: {
        type: String,
        default: '，'
      },
      label: {
        type: String,
        default: ''
      }
    },
    computed: {
      keywords: function () {
        return this.textData.split(this.symbol);
      },
      placeholder: function () {
        return '请输入' + this.label;
      }
    },
    methods: {
      onKeywordRemove (keywrod) {
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
