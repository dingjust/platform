<template>
  <div class="animated fadeIn">
    <el-tabs v-model="activeName">
      <el-tab-pane v-for="group in groups" :key="group.name" :label="getGroupName(group.name)">
        <div v-if="group.name === 'contracts'">
          <ul>
            <li v-for="item in slotData.contracts"><a :href="item.url" target="_blank">{{item.name}}</a></li>
          </ul>
        </div>
        <div v-else>
          <!--<media-file-list :file="slotData.contracts" @onDelete="onDelete"></media-file-list>-->
        </div>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  export default {
    name: 'ConsignmentContractsForm',
    props: ['slotData'],
    methods: {
      onDelete(item) {
        this.$confirm('此操作将永久删除该图片, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => this._delete(item));
      },
      async _delete(item) {
        const result = await this.$http.delete('/djbrand/product/media/' + item.id, {
          code: this.slotData.code
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.refresh();
        this.$message.success('图片删除成功');
      },
      isPicture(group) {
        return !(group.name === 'contracts');
      },
      getGroupName(group) {
        let result = '';
        switch (group) {
          case 'contracts':
            result = '合同';
            break;
          case 'bom':
            result = 'BOM文件';
            break;
          default:
            break;
        }

        return result;
      }
    },
    computed: {},
    data() {
      return {
        activeName: '0',
        groups: [
          {
            'name': 'contracts'
          },
          {
            'name': 'bom'
          }
        ]
      };
    }
  };
</script>
