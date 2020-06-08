// import EXIF from 'exif-js'

export default {
  // getOrientation: (file) => {
  //   return new Promise((resolve) => {
  //     EXIF.getData(file, function () {
  //       const orient = EXIF.getTag(this, 'Orientation')
  //       resolve(orient)
  //     })
  //   })
  // },

  dataURLtoFile: (dataurl, filename) => {
    const arr = dataurl.split(',')
    const mime = arr[0].match(/:(.*?);/)[1]
    const bstr = atob(arr[1])
    let n = bstr.length
    let u8arr = new Uint8Array(n);
    while (n--) {
      u8arr[n] = bstr.charCodeAt(n);
    }
    return new File([u8arr], filename, {
      type: mime
    });
  },

  rotateImage: (image, width, height) => {
    let canvas = document.createElement('canvas');
    let ctx = canvas.getContext('2d');
    ctx.save();
    canvas.width = height;
    canvas.height = width;
    ctx.rotate(90 * Math.PI / 180);
    ctx.drawImage(image, 0, -height);
    ctx.restore();
    return canvas.toDataURL("image/jpeg");
  },

  //压缩图片
  compressImage: (image, width, height,quality) => {
    let canvas = document.createElement('canvas');
    let ctx = canvas.getContext('2d');    
    canvas.width = width;
    canvas.height = height;
    ctx.drawImage(image, 0, 0, canvas.width, canvas.height)
    return canvas.toDataURL("image/jpeg", quality);
  },
}
