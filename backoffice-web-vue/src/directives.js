// directives.js

import Vue from 'vue'


//支持小数保留位最大位数限制指令
export function onInput(el, ele, binding, vnode) {

  function handle() {
    console.log('==============');
    console.log(JSON.stringify(binding.value));

    let val = ele.value
    // modifiers为修饰符对象，传入了float，则其float属性为true
    if (binding.modifiers.float) {
      // 清除"数字"和"."以及"-"以外的字符
      val = val.replace(/[^\-\d.]/g, '')
      // 只保留第一个'-'号
      val = val.replace(/\.{2,}/g, '.').replace(/\-{2,}/g, '-')
      // 将 '-.' 替换成 '-0.'
      val = val.replace(/^\./g, '0.').replace(/^\-\./, '-0.')
      if (typeof binding.value !== 'undefined') {
        // 期望保留的最大小数位数
        let pointKeep = 0
        if (typeof binding.value === 'string' ||
          typeof binding.value === 'number') {
          pointKeep = parseInt(binding.value)
        } else if (typeof binding.value === 'object') {
          // 支持新的小数点保留位配置
          pointKeep = binding.value.decimal
        }
        if (!isNaN(pointKeep)) {
          if (!Number.isInteger(pointKeep) ||
            pointKeep < 0) {
            pointKeep = 0
          }
          // 增加'-'号的支持
          const str = '^(\\-)*(\\d+)\\.(\\d\{' + pointKeep + '}).*$'
          const reg = new RegExp(str)
          if (pointKeep === 0) {
            // 不需要小数点
            val = val.replace(reg, '$1$2')
          } else {
            // 通过正则保留小数点后指定的位数
            val = val.replace(reg, '$1$2.$3')
          }
        }
      } else {
        val = ele.value.replace(/[^\d]/g, '')
      }
    }

    if (val !== '' && typeof binding.value === 'object') {
      let {
        min,
        max
      } = binding.value
      min = parseFloat(min)
      max = parseFloat(max)
      if (!isNaN(min)) {
        if (min >= 0) {
          // 不能是负数
          val = val.replace('-', '')
        }
        if (parseFloat(val) < min) {
          val = min
        }
      }
      if (!isNaN(max)) {
        if (parseFloat(val) > max) {
          val = max
        }
      }
    }


    ele.value = val;

    //手动触发数据的双向绑定
    if (vnode.componentInstance) {
      vnode.componentInstance.$emit('input', ele.value)
    } else {
      vnode.elm.dispatchEvent(new CustomEvent('input', ele.value))
    }
  }

  return handle;

}

//支持小数保留位最大位数限制指令
export const numberInput = {
  bind(el, binding, vnode) {
    const ele = el.tagName === 'INPUT' ? el : el.querySelector('input')
    ele.addEventListener('input', onInput(el, ele, binding, vnode), false)
  },
}


Vue.directive('selectLoadMore', {
  bind: function (el, binding) {
    // 获取element-ui定义好的scroll盒子
    const SELECTWRAP_DOM = el.querySelector('.el-select-dropdown .el-select-dropdown__wrap');
    SELECTWRAP_DOM.addEventListener('scroll', function () {
      const CONDITION = this.scrollHeight - this.scrollTop <= this.clientHeight;
      if (CONDITION) {
        binding.value()
      }
    })
  }
})
