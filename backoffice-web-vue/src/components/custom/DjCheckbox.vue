<template>
  <label class="el-checkbox" :style="{width:width+'px'}" :class="[
      border && checkboxSize ? 'el-checkbox--' + checkboxSize : '',
      { 'is-disabled': isDisabled },
      { 'is-bordered': border },
      { 'is-checked': isChecked }
    ]" :id="id">
    <span v-show="false" class="el-checkbox__input" :class="{
        'is-disabled': isDisabled,
        'is-checked': isChecked,
        'is-indeterminate': indeterminate,
        'is-focus': focus
      }" :tabindex="indeterminate ? 0 : false" :role="indeterminate ? 'checkbox' : false"
      :aria-checked="indeterminate ? 'mixed' : false">
      <span class="el-checkbox__inner"></span>
      <input v-if="trueLabel || falseLabel" class="el-checkbox__original" type="checkbox"
        :aria-hidden="indeterminate ? 'true' : 'false'" :name="name" :disabled="isDisabled" :true-value="trueLabel"
        :false-value="falseLabel" v-model="model" @change="handleChange" @focus="focus = true" @blur="focus = false">
      <input v-else class="el-checkbox__original" type="checkbox" :aria-hidden="indeterminate ? 'true' : 'false'"
        :disabled="isDisabled" :value="label" :name="name" v-model="model" @change="handleChange" @focus="focus = true"
        @blur="focus = false">
    </span>
    <el-row type="flex" justify="center">
      <div :class="isChecked?'color-body_active':'color-body'"
        :style="isChecked?{    borderColor: colorCode=='#FFFFFF'?'#FFD60C':colorCode}:{}">
        <div v-if="colorCode!=null" :class="isChecked?'color-inbody_active':'color-inbody'"
          :style="{backgroundColor:colorCode}" />
        <div v-if="colorCode==null" :class="isChecked?'color-gradbody_active':'color-gradbody'" />
      </div>
    </el-row>
    <el-row type="flex" justify="center">
      <span class="el-checkbox__label color-check-text" :style="{fontWeight:isChecked?'bold':'500'}" v-if="$slots.default || label">
        <slot></slot>
        <template v-if="!$slots.default">{{label}}</template>
      </span>
    </el-row>
  </label>
</template>
<script>
  import Emitter from 'element-ui/src/mixins/emitter';
  export default {
    name: 'DjCheckbox',
    mixins: [Emitter],
    inject: {
      elForm: {
        default: ''
      },
      elFormItem: {
        default: ''
      }
    },
    componentName: 'DjCheckbox',
    data() {
      return {
        selfModel: false,
        focus: false,
        isLimitExceeded: false
      };
    },
    computed: {
      model: {
        get() {
          return this.isGroup ?
            this.store : this.value !== undefined ?
            this.value : this.selfModel;
        },
        set(val) {
          if (this.isGroup) {
            this.isLimitExceeded = false;
            (this._checkboxGroup.min !== undefined &&
              val.length < this._checkboxGroup.min &&
              (this.isLimitExceeded = true));
            (this._checkboxGroup.max !== undefined &&
              val.length > this._checkboxGroup.max &&
              (this.isLimitExceeded = true));
            this.isLimitExceeded === false &&
              this.dispatch('ElCheckboxGroup', 'input', [val]);
          } else {
            this.$emit('input', val);
            this.selfModel = val;
          }
        }
      },
      isChecked() {
        if ({}.toString.call(this.model) === '[object Boolean]') {
          return this.model;
        } else if (Array.isArray(this.model)) {
          return this.model.indexOf(this.label) > -1;
        } else if (this.model !== null && this.model !== undefined) {
          return this.model === this.trueLabel;
        }
      },
      isGroup() {
        let parent = this.$parent;
        while (parent) {
          if (parent.$options.componentName !== 'ElCheckboxGroup') {
            parent = parent.$parent;
          } else {
            this._checkboxGroup = parent;
            return true;
          }
        }
        return false;
      },
      store() {
        return this._checkboxGroup ? this._checkboxGroup.value : this.value;
      },
      /* used to make the isDisabled judgment under max/min props */
      isLimitDisabled() {
        const {
          max,
          min
        } = this._checkboxGroup;
        return !!(max || min) &&
          (this.model.length >= max && !this.isChecked) ||
          (this.model.length <= min && this.isChecked);
      },
      isDisabled() {
        return this.isGroup ?
          this._checkboxGroup.disabled || this.disabled || (this.elForm || {}).disabled || this.isLimitDisabled :
          this.disabled || (this.elForm || {}).disabled;
      },
      _elFormItemSize() {
        return (this.elFormItem || {}).elFormItemSize;
      },
      checkboxSize() {
        const temCheckboxSize = this.size || this._elFormItemSize || (this.$ELEMENT || {}).size;
        return this.isGroup ?
          this._checkboxGroup.checkboxGroupSize || temCheckboxSize :
          temCheckboxSize;
      }
    },
    props: {
      value: {},
      label: {},
      indeterminate: Boolean,
      disabled: Boolean,
      checked: Boolean,
      name: String,
      trueLabel: [String, Number],
      falseLabel: [String, Number],
      id: String,
      /* 当indeterminate为真时，为controls提供相关连的checkbox的id，表明元素间的控制关系*/
      controls: String,
      /* 当indeterminate为真时，为controls提供相关连的checkbox的id，表明元素间的控制关系*/
      border: Boolean,
      size: String,
      colorCode: String,
      width:Number,
      isRead: Boolean
    },
    methods: {
      addToStore() {
        if (
          Array.isArray(this.model) &&
          this.model.indexOf(this.label) === -1
        ) {
          this.model.push(this.label);
        } else {
          this.model = this.trueLabel || true;
        }
      },
      handleChange(ev) {
        if (this.isLimitExceeded) return;
        let value;
        if (ev.target.checked) {
          value = this.trueLabel === undefined ? true : this.trueLabel;
        } else {
          value = this.falseLabel === undefined ? false : this.falseLabel;
        }
        this.$emit('change', value, ev);
        this.$nextTick(() => {
          if (this.isGroup) {
            this.dispatch('ElCheckboxGroup', 'change', [this._checkboxGroup.value]);
          }
        });
      }
    },
    created() {
      this.checked && this.addToStore();
    },
    mounted() { // 为indeterminate元素 添加aria-controls 属性
      if (this.indeterminate) {
        this.$el.setAttribute('aria-controls', this.controls);
      }
    },
    watch: {
      value(value) {
        this.dispatch('ElFormItem', 'el.form.change', value);
      }
    }
  };

</script>
<style>
  .color-inbody_active {
    border-radius: 50%;
    width: 18px;
    height: 18px;
    align-content: center;
  }

  .color-inbody {
    border-radius: 50%;
    width: 30px;
    height: 30px;
    align-content: center;
  }

  .color-body_active {
    border-radius: 50%;
    width: 30px;
    height: 30px;
    border: 0.5px solid #FFD60C;
    justify-content: center;
    align-items: center;
    display: flex;
  }

  .color-body {
    border-radius: 50%;
    width: 30px;
    height: 30px;
    /* border: 0.5px solid #ffffff; */
    justify-content: center;
    align-items: center;
    display: flex;
  }

  .color-gradbody_active {
    border-radius: 50%;
    width: 18px;
    height: 18px;
    align-content: center;
    background: -webkit-linear-gradient(left top, grey, #DCDCD9, grey);
    /* Safari 5.1 - 6.0 */
    background: -o-linear-gradient(bottom right, grey, #DCDCD9, grey);
    /* Opera 11.1 - 12.0 */
    background: -moz-linear-gradient(bottom right, grey, #DCDCD9, grey);
    /* Firefox 3.6 - 15 */
    background: linear-gradient(to bottom right, grey, #DCDCD9, grey);
    /* 标准的语法 */
  }

  .color-gradbody {
    border-radius: 50%;
    width: 30px;
    height: 30px;
    align-content: center;
    background: -webkit-linear-gradient(left top, grey, #DCDCD9, grey);
    /* Safari 5.1 - 6.0 */
    background: -o-linear-gradient(bottom right, grey, #DCDCD9, grey);
    /* Opera 11.1 - 12.0 */
    background: -moz-linear-gradient(bottom right, grey, #DCDCD9, grey);
    /* Firefox 3.6 - 15 */
    background: linear-gradient(to bottom right, grey, #DCDCD9, grey);
    /* 标准的语法 */
  }

  .color-check-text {
    text-align: center;
    padding-left: 0px;
    font-size: 12px;
    margin-top: 5px;
  }

</style>
