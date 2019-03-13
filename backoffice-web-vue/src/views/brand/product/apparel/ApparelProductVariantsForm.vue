<template>
  <div class="animated fadeIn">
    <ul class="list-group">
      <li class="list-group-item">
        <h6>颜色：</h6>
        <el-checkbox-group v-model="slotData.colors">
          <el-checkbox v-for="item in colors" :value="item.code" :label="item.code">{{item.name}}</el-checkbox>
        </el-checkbox-group>
      </li>
      <li class="list-group-item">
        <h6>尺码：</h6>
        <el-checkbox-group v-model="slotData.sizes">
          <el-checkbox v-for="item in sizes" :value="item.code" :label="item.code">{{item.name}}</el-checkbox>
        </el-checkbox-group>
      </li>
    </ul>
  </div>
</template>

<script>
  export default {
    name: 'ApparelProductVariantsForm',
    props: ['slotData', 'readOnly', 'isNewlyCreated'],
    methods: {
      async getAllColors() {
        this.colors = await this.$http.get('/djwebservices/colors/all');
      },
      async getAllSizes() {
        this.sizes = await this.$http.get('/djwebservices/sizes/all');
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
