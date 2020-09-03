import store from '@/store';

//获取尺码序号
export function getSizeSequence(code) {
  if (store.getters["GlobalSizesModule/sizes"] && store.getters["GlobalSizesModule/sizes"].length != null) {
    let index = store.getters["GlobalSizesModule/sizes"].findIndex((size) => size.code == code);
    if (index != -1) {
      return store.getters["GlobalSizesModule/sizes"][index].sequence;
    } else {
      return 999;
    }
  } else {
    store.dispatch('GlobalSizesModule/getSizesData');
    return null;
  }
}

//根据名称获取尺码编号
export function getSizeCode(name) {
  if (store.getters["GlobalSizesModule/sizes"] && store.getters["GlobalSizesModule/sizes"].length != null) {
    let index = store.getters["GlobalSizesModule/sizes"].findIndex((size) => size.name == name);
    if (index != -1) {
      return store.getters["GlobalSizesModule/sizes"][index].code;
    } else {
      return null;
    }
  } else {
    store.dispatch('GlobalSizesModule/getSizesData');
    return null;
  }
}

//根据名称获取颜色编号
export function getColorCode(name) {
  if (store.getters["GlobalColorsModule/colors"] && store.getters["GlobalColorsModule/colors"].length != null) {
    let index = store.getters["GlobalColorsModule/colors"].findIndex((color) => color.name == name);
    if (index != -1) {
      return store.getters["GlobalColorsModule/colors"][index].code;
    } else {
      return null;
    }
  } else {
    store.dispatch('GlobalColorsModule/getcolorsData');
    return null;
  }
}

//根据父类，子类名称获取编号
export function getCategoryCodeByCascadedName(parentName, childName) {
  if (store.getters["GlobalCategoriesModule/categories"] && store.getters["GlobalCategoriesModule/categories"].length != null) {
    let parentIndex = store.getters["GlobalCategoriesModule/categories"].findIndex((category) => category.name == parentName);
    if (parentIndex != -1) {
      // return store.getters["GlobalCategoriesModule/categories"][index].code;
      let childIndex = store.getters["GlobalCategoriesModule/categories"][parentIndex].children.findIndex((category) => category.name == childName);
      if (childIndex != -1) {
        return store.getters["GlobalCategoriesModule/categories"][parentIndex].children[childIndex].code;
      }
    }
  } else {
    store.dispatch('GlobalCategoriesModule/getCategoriesData');
  }
  return null;
}
