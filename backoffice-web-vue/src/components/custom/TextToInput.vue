<template>
  <div>
    <span v-if="!showInput"
          @mouseenter="mouseEvent"
          @mouseleave="mouseEvent"
          @dblclick="dblclick"
          :class="ondblclickShow ? 'active_tree_node' : ''">
      {{value}}
    </span>
    <el-input
              ref="input" type='text' id="numberText"
              v-model="modifyText"
              v-if="showInput && this.inputType == 'number'"
              @blur="blur"
              onkeydown="if(event.keyCode==13){blur()}"
              onkeyup="value=value.replace(/^(0+)|[^\d]+/g, '') > 20 ? 20 : value.replace(/^(0+)|[^\d]+/g, '')"
              @change="validateNumber"/>
    <el-input
              ref="input" id="stringText"
              v-model="modifyText"
              v-if="showInput && this.inputType == 'string'"
              @blur="blur"
              onkeydown="if(event.keyCode==13){blur()}"/>
  </div>
</template>

<script>
  export default {
    name: 'TextToInput',
    props: {
      // 默认显示文本
      value: {
        required: true
      },
      // 是否显示输入框
      showInput: {
        type: Boolean,
        default: false
      },
      // 是否可以双击文本打开输入框
      ondblclick: {
        type: Boolean,
        default: false
      },
      // 输入框类型，number/string
      inputType: {
        type: String,
        default: 'string'
      },
      // type为number是才生效,限制value的最大值
      maxNumber: {
        type: Number
      }
    },
    computed: {
      ondblclickShow: function () {
        return this.ondblclick && this.active;
      }
    },
    methods: {
      blur () {
        this.active = false;
        this.$emit('blur', this.modifyText);
        this.modifyText = this.value;
      },
      mouseEvent () {
        this.active = !this.active;
      },
      dblclick () {
        if (!this.ondblclick) {
          return;
        }
        this.$emit('dblclick');
      },
      validateNumber () {
        this.modifyText.replace(/^(0+)|[^\d]+/g, '');
        if (Number(this.modifyText) > this.maxNumber) {
          this.modifyText = this.maxNumber;
        }
      }
    },
    data () {
      return {
        modifyText: this.value,
        active: false
      }
    },
    watch: {
      showInput: function (n, o) {
        if (n) {
          this.$nextTick(() => {
            this.$refs.input.focus();
            let text = this.inputType == 'string' ? document.getElementById('stringText') : document.getElementById('numberText');
            // 选中框中的所有文本;
            text.select();
          });
        }
      }
    }
  }
</script>

<style scoped>
  /deep/ .el-input__inner {
    width: 50px;
    height: 20px;
    line-height: 32px;
    border-radius: 2px;
    padding: 0px;
  }

  .active_tree_node {
    color: #409EFF;
    text-decoration: underline
  }
</style>
