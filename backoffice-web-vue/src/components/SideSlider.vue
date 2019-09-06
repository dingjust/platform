<style lang="scss">
  .loading {
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    z-index: 1111;
    background: rgba(0, 0, 0, 0.43137254901960786);
  }

  /* 设置持续时间和动画函数 */
  .slide-fade-enter-active {
    transition: all .3s ease;
  }

  .slide-fade-leave-active {
    transition: all .3s cubic-bezier(1.0, 0.5, 0.3, 1.0);;
  }

  .slide-fade-enter, .slide-fade-leave-to {
    transform: translateX(10px);
    opacity: 0;
  }

  .side-slider {
    position: absolute;
    top: 10%;
    bottom: 10px;
    right: 5%;
    /*left: 220px;*/
    left: 10%;
    background-color: #f5f5f5;
    z-index: 1121;
    overflow: hidden;
    border-radius: 6px;
    box-sizing: border-box;

    .side-slider-center {
      position: absolute;
      top: 54px;
      bottom: 5px;
      overflow: auto;
      right: 10px;
      left: 10px;
    }

    .header {
      .el-card__body {
        padding: 10px;
      }

      .clear {
        width: 30px;
        height: 100%;
        cursor: pointer;
        /*float: right;*/
      }

      .title {
        text-align: center;
      }
    }
  }
</style>
<template>
  <div>
    <div class="loading" v-show="open" @click="open = false"></div>
    <transition name="slide-fade">
      <div v-if="open" class="side-slider">
        <el-card class="">
          <div style="width:100%;height: 20px;">
          <!--<el-row :gutter="20">-->
            <!--<el-col :span="16">-->
              <!--<div class="title" v-text="title"></div>-->
            <!--</el-col>-->
            <!--<el-col :span="20">-->
              <div class="" style="float:right;cursor: pointer;margin-right: 10px;height: 100%; width: 30px;">
                <i class="el-icon-close" style="width: 10px;height: 10px;" @click="closeSlider()"></i>
              </div>
            <!--</el-col>-->
          <!--</el-row>-->
          </div>
          <div class="side-slider-center">
            <component class="side-slider-item"
                       :is="contentSlot"
                       :slotData="contentData">
            </component>
          </div>
        </el-card>
      </div>
    </transition>
  </div>
</template>
<script>
  export default {
    name: 'SideSlider',
    data() {
      return {
        contentSlot: '',
        contentData: {},
        title: '',
        open: false
      }
    },
    computed: {},
    methods: {
      openSlider(title, slot, data) {
        this.contentSlot = slot;
        this.contentData = data;
        this.title = title;
        this.open = true;
        this.$store.dispatch('sideSliderState_set', true);
      },
      closeSlider(refresh) {
        this.open = false;
        this.$store.dispatch('sideSliderState_set', false);
      }
    },
    created() {
      this.fn.openSlider = this.openSlider; // 打开
      this.fn.closeSlider = this.closeSlider // 关闭
    },
    watch: {
      '$route'(to, from) {
        this.open = false;
      }
    }
  }
</script>
