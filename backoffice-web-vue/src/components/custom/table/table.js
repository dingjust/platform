import store from '@/store';

  //获取尺码序号
  export function getSizeSequence(code) {
    if (store.getters["GlobalSizesModule/sizes"]) {
      let index = store.getters["GlobalSizesModule/sizes"].findIndex((size) => size.code == code);
      if (index != -1) {
        return store.getters["GlobalSizesModule/sizes"][index].sequence;
      } else {
        return 999;
      }
    } else {
      return null;
    }
  }
