import store from '@/store';

// const currentAuth

// export { currentAuth };

//管理员权限标签
const ADMIN_PERMISSION = 'CUSTOMERMANAGERGROUP';

export function getCurrentUser() {
  const currentUserStr = sessionStorage.getItem('currentUser');
  if (currentUserStr != undefined && currentUserStr != null && currentUserStr != 'undefined' && currentUserStr != 'null' && currentUserStr != '') {
    return JSON.parse(currentUserStr);
  }
  return null;
}

export function getCurrentAuthority() {
  //   return currentAuth;
  const permissionStr = sessionStorage.getItem('permissions');
  if (permissionStr != undefined && permissionStr != null && permissionStr != 'undefined' && permissionStr != 'null' && permissionStr != '') {
    return JSON.parse(permissionStr);
  }
  return [];
}

export function getDataPermission() {
  //   return currentAuth;
  const dataPermissionStr = sessionStorage.getItem('dataPermission');
  if (dataPermissionStr != undefined && dataPermissionStr != null && dataPermissionStr != 'undefined' && dataPermissionStr != 'null' && dataPermissionStr != '') {
    return JSON.parse(dataPermissionStr);
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
  const roles = getCurrentAuthority();
  //先校验是否拥有管理员权限
  if (roles.includes(ADMIN_PERMISSION)) {
    return true;
  }

  if (authority && authority instanceof Array && authority.length) {
    const permissionRoles = authority;

    const hasPermission = roles.some(role => {
      return permissionRoles.includes(role);
    })

    if (!hasPermission) {
      return false;
    }
    return true;
  } else {
    return false;
  }
  // return true;
}

export function getDataPermissionQuery (from) {
  const currentUser = getCurrentUser();
  
  if (currentUser == null) {
    alert('登陆账号数据有误，请重新登陆！');
  }

  let query;
  
  const roles = getCurrentAuthority();

  const dataPer = getDataPermission();

  //先校验是否拥有管理员权限
  if (roles.includes(ADMIN_PERMISSION)) {
    query = {
      depts: [0],
      users: []
    }
    return query;
  }
  
  if (dataPer[from] === 'ALL_DATA') {
    query = {
      depts: [0],
      users: []
    }
  } else if (dataPer[from] === 'BELONG_DEPT_DATA') {
    query = {
      depts: currentUser.dept ? [currentUser.dept.id] : [],
      users: currentUser.dept ? [] : [currentUser.id] 
    }
  } else if (dataPer[from] === 'SELF_DATA') {
    query = {
      depts: [],
      users: [currentUser.id]
    }
  } else {
    query = {
      depts: [],
      users: []
    }
  }

  return query;
} 
