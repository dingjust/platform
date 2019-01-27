<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData">
      <table class="table table-bordered">
        <thead>
        <tr class="table-secondary text-center">
          <th colspan="2">颜色/尺码</th>
          <th v-for="size of sizes">{{size.name}}</th>
        </tr>
        </thead>
        <tbody>
        <template v-for="color in existedColors">
          <tr>
            <th rowspan="2">{{color.name}}</th>
            <td class="table-secondary font-weight-bold">实际库存</td>
            <td v-for="size in sizes">
              <input class="form-control" type="number" min="0" v-model="inventories[color.code][size.code].number"/>
            </td>
          </tr>
          <tr>
            <td class="table-secondary font-weight-bold">虚拟库存</td>
            <td v-for="size in sizes">
              <input class="form-control" type="number" min="0"
                     v-model="inventories[color.code][size.code].maxPreOrder"/>
            </td>
          </tr>
        </template>
        </tbody>
        <tfoot>
        <tr>
          <td :colspan="colspan">
            <el-select placeholder="请选择颜色" v-model="color">
              <el-option v-for="color in colors" :key="color.code" :label="color.name" :value="color.code">
              </el-option>
            </el-select>
            <el-button type="primary" icon="el-icon-plus" @click="onAdd(color)" size="mini">添加</el-button>
          </td>
        </tr>
        </tfoot>
      </table>
    </el-form>
  </div>
</template>

<script>
  import axios from "axios";

  export default {
    name: "ProductSpecificationForm",
    props: ["slotData", "isNewlyCreated"],
    methods: {
      onAdd(color) {
        if (!color) {
          return;
        }

        // 已经存在
        if (this.inventories[color]) {
          return;
        }

        this.existedColors.push(
          this.colors.filter(item => {
            return item.code === color;
          })[0]
        );

        this.inventories[color] = {};

        this.sizes.forEach(size => {
          this.inventories[color][size.code] = {
            color: color,
            size: size.code,
            number: 0,
            maxPreOrder: 0
          };
        });
      },
      getExistedColors() {
        let results = [];
        this.variants.forEach(stock => {
          const found = results.filter(item => {
            return stock.color.code === item.code;
          });

          if (!found) {
            results.push(stock.color);
          }
        });

        return results;
      },
      getInventories() {
        let results = {};
        this.existedColors.forEach(color => {
          results[color.code] = {};
          this.sizes.forEach(size => {
            results[color.code][size.code] = {
              color: color.code,
              size: size.code,
              number: 0
            };

            const found = this.variants.find(item => {
              return (
                item.color.code === color.code && item.size.code === size.code
              );
            });

            if (found && found.length > 0) {
              results[color.code][size.code] = found[0]["available"];
            }
          });
        });

        return results;
      },
      refreshInventories() {
        axios
          .get("/djbrand/product/inventories/" + this.slotData.code)
          .then(response => {
            this.stockLevels = response.data;
            this.existedColors = this.getExistedColors(this.variants);
          });
      },
      getValue() {
        let results = [];
        for (const colorKey in this.inventories) {
          for (const sizeKey in this.inventories[colorKey]) {
            const item = this.inventories[colorKey][sizeKey];
            // if (item.number > 0) {
            results.push(item);
            // }
          }
        }

        return results;
      }
    },
    computed: {
      colspan: function () {
        return this.sizes.length + 2;
      }
    },
    data() {
      return {
        color: "",
        existedColors: [],
        sizes: [],
        colors: [],
        inventories: [],
        variants: []
      };
    },
    created() {
      axios
        .all([
          axios
            .get("/djbackoffice/product/color/all")
            .then(response => {
              this.colors = response.data;
            }),

          axios
            .get("/djbackoffice/product/size/all")
            .then(response => {
              this.sizes = response.data;
            }),
          !this.isNewlyCreated
            ? axios
              .get("/djbrand/product/inventories/" + this.slotData.code)
              .then(response => {
                this.stockLevels = response.data;
                this.existedColors = this.getExistedColors(this.variants);
              })
            : () => {
              this.stockLevels = [];
            }
        ])
        .then(() => {
          this.getInventories();
        })
        .catch(error => {
          this.$message.error(error.response.data);
        });
    }
  };
</script>
