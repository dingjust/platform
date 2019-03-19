<template>
  <div class="animated fadeIn">
    <ul class="list-group">
      <li class="list-group-item">
        <h6>颜色：</h6>
        <el-checkbox-group v-model="slotData.colors" @change="onColorChanged">
          <el-checkbox v-for="item in colors"
                       :label="item.code"
                       :key="item.code">
            {{item.name}}
          </el-checkbox>
        </el-checkbox-group>
      </li>
      <li class="list-group-item">
        <h6>尺码：</h6>
        <el-checkbox-group v-model="slotData.sizes" @change="onSizeChanged">
          <el-checkbox v-for="item in sizes"
                       :label="item.code"
                       :key="item.code">
            {{item.name}}
          </el-checkbox>
        </el-checkbox-group>
      </li>
    </ul>
  </div>
</template>

<script>
  export default {
    name: 'ApparelProductVariantsForm',
    props: ['slotData', 'readOnly'],
    methods: {
      onColorChanged(value) {
        // console.log(JSON.stringify(value));
        this._updateColorsAndSizes();
      },
      onSizeChanged(value) {
        // console.log(JSON.stringify(value));
        this._updateColorsAndSizes();
      },
      async getAllColors() {
        const url = this.apis().getAllColors();
        this.colors = await this.$http.get(url);
      },
      async getAllSizes() {
        const url = this.apis().getAllSizes();
        this.sizes = await this.$http.get(url);
      },
      _updateColorsAndSizes() {
        let variants = [];

        for (let color of this.slotData.colors) {
          for (let size of this.slotData.sizes) {
            variants.push({
              color: {
                code: color
              },
              size: {
                code: size
              }
            });
          }
        }

        this.$set(this.slotData, 'variants', variants);
      }
    },
    computed: {},
    data() {
      return {
        colors: [],
        sizes: [],
      };
    },
    created() {
      this.getAllColors();
      this.getAllSizes();
    }
  };
</script>
