import store from '@/store';

// const currentAuth

// export { currentAuth };

//管理员权限标签
const ADMIN_PERMISSION = 'CUSTOMERMANAGERGROUP';

export function getCurrentAuthority() {
  //   return currentAuth;
  const permissionStr = sessionStorage.getItem('permissions');
  if (permissionStr != undefined && permissionStr != null && permissionStr != 'undefined' && permissionStr != 'null' && permissionStr != '') {
    return JSON.parse(permissionStr);
  }
  return [];
}

// 检查是否拥有权限
// export function hasPermission(authority) {
// if (authority != null && authority instanceof Array && authority.length > 0) {
//   const permissions = JSON.parse(sessionStorage.getItem('permissions'));
//   const flag = authority.every(val => permissions.indexOf(val)>-1);
//   if (flag != null && flag) {
//     return true;
//   } else {
//     return false;
//   }
// } else {
// return true;/
// }
// }

export function hasPermission(authority) {
  // const roles = getCurrentAuthority();
  // //先校验是否拥有管理员权限
  // if (roles.includes(ADMIN_PERMISSION)) {
  //   return true;
  // }

  // if (authority && authority instanceof Array && authority.length) {
  //   const permissionRoles = authority;

  //   const hasPermission = roles.some(role => {
  //     return permissionRoles.includes(role);
  //   })

  //   if (!hasPermission) {
  //     return false;
  //   }
  //   return true;
  // } else {
  //   return false;
  // }
  return true;
}

// export function isLogin () {
//   const current = getCurrentAuthority();
//   return current && current[0] !== 'guest';
// }
