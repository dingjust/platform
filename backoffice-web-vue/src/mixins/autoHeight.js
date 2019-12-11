
export default {
  data () {
    return {
      autoOffsetTop: 0,
      autoHeightOptions: null,
      isHeightComputed: false,
      autoHeight: null
    }
  },

  methods: {
    getAutoHeight (el, offsetTop) {
      let height = 0

      if (el && !isNaN(el)) {
        offsetTop = el
        el = null
      }

      offsetTop = this.autoOffsetTop > 0 ? this.autoOffsetTop : offsetTop > 0 ? offsetTop : 0

      if (!this.autoHeightOptions && (el || offsetTop)) {
        this.autoHeightOptions = {el: el, offsetTop: offsetTop}
      } else if (!el && !offsetTop && this.autoHeightOptions) {
        el = this.autoHeightOptions.el
        offsetTop = this.autoHeightOptions.offsetTop
      }

      if (el && typeof el === 'object') {
        height = el.getBoundingClientRect().height
      } else {
        height = innerHeight - 208
      }

      this.autoHeight = height > 0 ? height - offsetTop : null
      this.isHeightComputed = true
    }
  },

  mounted () {
    this.$nextTick(() => { this.getAutoHeight(120) })
    window.addEventListener('resize', (e) => { this.isHeightComputed = false; this.getAutoHeight() })
  }
}
