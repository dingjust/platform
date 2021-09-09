import XLSX from 'xlsx';

export function s2ab (s) {
  var buf;
  if (typeof ArrayBuffer !== 'undefined') {
    buf = new ArrayBuffer(s.length);
    var view = new Uint8Array(buf);
    for (var i = 0; i !== s.length; ++i) view[i] = s.charCodeAt(i) & 0xff;
    return buf;
  } else {
    buf = new Array(s.length);
    for (var j = 0; j !== s.length; ++j) buf[j] = s.charCodeAt(j) & 0xff;
    return buf;
  }
}

export function saveAs (obj, fileName) {
  // 当然可以自定义简单的下载文件实现方式
  var tmpa = document.createElement('a');
  tmpa.download = fileName || '下载';
  tmpa.href = URL.createObjectURL(obj); // 绑定a标签
  tmpa.click(); // 模拟点击实现下载
  setTimeout(function () {
    // 延时释放
    URL.revokeObjectURL(obj); // 用URL.revokeObjectURL()来释放这个object URL
  }, 100);
}

export function exportTable (data, fileName, customWopts) {
  // 这里的数据是用来定义导出的格式类型
  const wopts = customWopts || { bookType: 'xlsx', bookSST: false, type: 'binary' };

  const wb = { SheetNames: ['Sheet1'], Sheets: {}, Props: {} };
  // 通过json_to_sheet转成单页(Sheet)数据
  wb.Sheets['Sheet1'] = XLSX.utils.json_to_sheet(data);
  saveAs(
    new Blob([s2ab(XLSX.write(wb, wopts))], {
      type: 'application/octet-stream'
    }),
    (fileName + '.' + (wopts.bookType === 'biff2' ? 'xls' : wopts.bookType))
  );
}
