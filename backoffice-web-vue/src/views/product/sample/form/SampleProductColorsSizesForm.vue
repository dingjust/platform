<template>
  <div>
    <el-row class="basic-form-row" type="flex" align="top">
      <el-col :span="2">
        <h6 class="info-input-prepend">商品规格<span style="color: red">*</span></h6>
      </el-col>
      <el-col :span="20">
        <el-form-item prop="colorSizes" :rules="[{
            type: 'object',
            validator: checkColorSizes,
            trigger: 'change'
          }]">
          <div class="border-container">
            <el-row type="flex">
              <h6>颜色</h6>&nbsp;&nbsp;<h6>最多支持30个颜色</h6>
            </el-row>
            <el-checkbox-group v-model="slotData.colors" :disabled="isRead">
              <template v-for="color in colors">
                <el-checkbox class="size-tag" :label="color.name" @change="((val,$event)=>colorHanleClick(val,color))"
                  style="margin-bottom: 20px">
                  <el-row type="flex" style="float: left;margin-bottom: -13px;">
                    <div
                      :style="{width: '13px',height: '13px',backgroundColor: color.colorCode==null?'#': color.colorCode,marginRight: '5px',align:'middle'}">
                    </div>
                    <h6>{{color.name}}</h6>
                  </el-row>
                </el-checkbox>
              </template>
            </el-checkbox-group>
            <el-row type="flex" v-for="(color,index) in customColors" v-if="index%4 == 0">
              <template v-for="(customColor) in customColors.slice(index,index+4)">
                <el-col :span="6">
                  <el-row type="flex" style="margin-bottom: 20px;margin-right: 10px">
                    <el-input v-model="customColor.name" @change="editCustomColor(customColor)"></el-input>
                    <el-button type="text" @click="removeCustomColor(customColor)"> 删除</el-button>
                  </el-row>
                </el-col>
              </template>
              <el-row type="flex" v-if="Math.floor(index/4) == Math.floor(customColors.length/4)">
                <el-button style="margin-right: 11px;margin-bottom: 20px" @click="appendCustomColor">+ 添加自定义颜色
                </el-button>
              </el-row>
            </el-row>
            <el-row type="flex" v-if="customColors.length%4 == 0">
              <el-button style="margin-right: 11px;margin-bottom: 20px" @click="appendCustomColor">+ 添加自定义颜色</el-button>
            </el-row>
            <el-row type="flex" v-for="(color,index) in selectColors" v-if="index%6 == 0">
              <template v-for="(color) in selectColors.slice(index,index+6)">
                <el-col :span="4">
                  <images-upload :limit="1" :slotData="color.previewImg" />
                  <h6 style="width: 100px;text-align: center;">{{color.name}}</h6>
                </el-col>
              </template>
            </el-row>
          </div>
          <div class="border-container" style="margin-top: 10px;margin-bottom: 20px">
            <el-row type="flex">
              <h6>尺码</h6>&nbsp;&nbsp;<h6>最多支持30个尺码</h6>
            </el-row>
            <el-checkbox-group v-model="slotData.sizes" :disabled="isRead">
              <template v-for="size in sizes">
                <el-checkbox class="size-tag" style="margin-bottom: 20px" :label="size.name"
                  @change="sizeHanleClick(size)">
                  {{size.name}}
                </el-checkbox>
              </template>
            </el-checkbox-group>
            <el-row type="flex" v-for="(size,index) in customSizes" v-if="index%4 == 0">
              <template v-for="(customSize) in customSizes.slice(index,index+4)">
                <el-col :span="6">
                  <el-row type="flex" style="margin-bottom: 20px;margin-right: 10px">
                    <el-input v-model="customSize.name" @change="editCustomSize(customSize)"></el-input>
                    <el-button type="text" @click="removeCustomSize(customSize)"> 删除</el-button>
                  </el-row>
                </el-col>
              </template>
              <el-row type="flex" v-if="Math.floor(index/4) == Math.floor(customSizes.length/4)">
                <el-button style="margin-right: 11px;margin-bottom: 20px" @click="appendCustomSize">+ 添加自定义尺码
                </el-button>
              </el-row>
            </el-row>
            <el-row type="flex" v-if="customSizes.length%4 == 0">
              <el-button style="margin-right: 11px;margin-bottom: 20px" @click="appendCustomSize">+ 添加自定义尺码</el-button>
            </el-row>
          </div>
        </el-form-item>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import ImagesUpload from '../../../../components/custom/ImagesUpload';
  export default {
    name: 'SampleProductColorsSizesForm',
    props: ['slotData', 'readOnly', 'isRead'],
    components: {
      ImagesUpload
    },
    computed: {},
    watch: {
      selectColors: function () {
        this.slotData.colorSizes = this.getColorSizes();
      },
      selectSizes: function () {
        this.slotData.colorSizes = this.getColorSizes();
      }
    },
    methods: {
      checkColorSizes(rule, value, callback) {
        if (value == null || value.length <= 0 || value[0].length <= 0) {
          return callback(new Error('请填写商品规格'));
        } else {
          callback();
        }
      },
      async getAllSizes() {
        const url = this.apis().getAllSizes();
        this.sizes = await this.$http.get(url);
      },
      async getAllColors() {
        const url = this.apis().getAllColors();
        this.colors = await this.$http.get(url);
      },
      getColorSizes() {
        var colors = [];
        for (let i = 0; i < this.selectColors.length; i++) {
          var arr = [];
          for (let j = 0; j < this.selectSizes.length; j++) {
            let obj = {
              'colorId': this.selectColors[i].id,
              'colorCode': this.selectColors[i].code,
              'color': this.selectColors[i].name,
              'previewImg': this.selectColors[i].previewImg,
              'size': this.selectSizes[j].name,
              'sizeCode': this.selectSizes[j].code,
              'quality': this.selectSizes[j].quality
            }
            let key = obj.color + obj.size;
            if (this.colorSizeQualityMap[key] != null) {
              obj.quality = this.colorSizeQualityMap[key];
            } else {
              obj.quality = this.selectSizes[j].quality;
            }
            arr.push(obj);
          }
          colors.push(arr);
        }
        return colors;
      },
      colorHanleClick(val, color) {
        var index = this.selectColors.findIndex((v) => v.name === color.name);
        if (index < 0) {
          if (color.previewImg == null) {
            color.previewImg = [];
          }
          console.log(JSON.stringify(color));
          this.selectColors.push(color);
          console.log(JSON.stringify(this.selectColors));
        } else {
          this.selectColors.splice(index, 1);
        }
        // var compare = function (prop) {
        //   return function (obj1, obj2) {
        //     var val1 = obj1[prop];
        //     var val2 = obj2[prop];
        //     if (val1 < val2) {
        //       return -1;
        //     } else if (val1 > val2) {
        //       return 1;
        //     } else {
        //       return 0;
        //     }
        //   }
        // }
        // this.selectColors = this.selectColors.sort(compare('sequence'));
      },
      sizeHanleClick(size) {
        var index = this.selectSizes.findIndex((v) => v.name === size.name);
        if (index < 0) {
          this.selectSizes.push(size);
        } else {
          this.selectSizes.splice(index, 1);
        }
        // 根据尺码sequence排序
        var compare = function (prop) {
          return function (obj1, obj2) {
            var val1 = obj1[prop];
            var val2 = obj2[prop];
            if (val1 < val2) {
              return -1;
            } else if (val1 > val2) {
              return 1;
            } else {
              return 0;
            }
          }
        }
        this.selectSizes = this.selectSizes.sort(compare('sequence'));
      },
      appendCustomColor() {
        this.customColors.push({
          name: null,
          previewImg: []
        });
      },
      removeCustomColor(color) {
        let index = this.customColors.indexOf(color);
        if (index > -1) {
          this.customColors.splice(index, 1);
          let index1 = this.selectColors.indexOf(color);
          if (index1 > -1) {
            this.selectColors.splice(index1, 1);
          }
        }
      },
      editCustomColor(color) {
        if (color.name != null && color.name !== '') {
          let index = this.selectColors.indexOf(color);
          if (index > -1) {
            this.selectColors[index].name = color.name;
            this.selectColors[index].code = null;
            this.slotData.colorSizes = this.getColorSizes();
          } else {
            this.selectColors.push(color);
          }
        }
      },
      appendCustomSize() {
        this.customSizes.push({
          name: null
        });
      },
      removeCustomSize(size) {
        let index = this.customSizes.indexOf(size);
        if (index > -1) {
          this.customSizes.splice(index, 1);
          let index1 = this.selectSizes.indexOf(size);
          if (index1 > -1) {
            this.selectSizes.splice(index1, 1);
          }
        }
      },
      editCustomSize(color) {
        if (color.name != null && color.name !== '') {
          let index = this.selectSizes.indexOf(color);
          if (index > -1) {
            this.selectSizes[index].name = color.name;
            this.selectSizes[index].code = null;
            this.slotData.colorSizes = this.getColorSizes();
          } else {
            this.selectSizes.push(color);
          }
        }
      },
      inputChange(val) {
        let text = val.color + val.size;
        this.colorSizeQualityMap[text] = val.quality;
      }
    },
    data() {
      return {
        sizes: [],
        colors: [],
        selectColors: [],
        selectSizes: [],
        customColors: [],
        customSizes: [],
        colorSizeQualityMap: {}
      };
    },
    created() {
      this.getAllColors();
      this.getAllSizes();
      this.slotData.colorSizes.forEach((color) => {
        let colorObj = {
          'colorId': color.colorId,
          'code': color.colorCode,
          'name': color.colorName,
          'customize': color.customize
        };
        if (color.previewImg == null) {
          colorObj.previewImg = [];
        } else {
          colorObj.previewImg = [color.previewImg];
        }
        this.selectColors.push(colorObj);

        if (this.selectSizes.length <= 0) {
          this.selectSizes = color.sizes;
        }
        color.sizes.forEach((size) => {
          if (size.quality != null) {
            this.inputChange({
              'color': color.colorName,
              'size': size.name,
              'quality': size.quality
            })
          }
        })
      });

      this.selectColors.forEach((color) => {
        if (color.customize) {
          this.customColors.push(color);
        }
      });
      this.selectSizes.forEach((size) => {
        if (size.customize) {
          this.customSizes.push(size);
        }
      });


      this.slotData.colors = this.selectColors.map((color) => color.name);
      this.slotData.sizes = this.selectSizes.map((size) => size.name);
    }
  };

</script>
<style scoped>
  .size-tag {
    width: 80px;
    /*margin-left: 0px;*/
  }

  .basic-form-row {
    padding-left: 30px;
    margin-bottom: 20px;
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    /* margin-top: 5px; */
    width: 60px;
    font-size: 12px;
    font-weight: 500;
  }

  /deep/ .el-checkbox.is-bordered+.el-checkbox.is-bordered {
    margin-left: 0px;
  }

  .border-container {
    border: 1px solid #DCDFE6;
    padding: 10px;
    background-color: #F5F5F5;
  }

  /deep/ .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  /deep/ .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  /deep/ .el-table--enable-row-hover .el-table__body tr:hover>td {
    background-color: #ffffff !important;
  }

  /deep/ .border-none .el-input__inner {
    border: none
  }

</style>
