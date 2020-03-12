import store from '@/store';


// const currentAuth

// export { currentAuth };

export function getCurrentAuthority() {
  //   return currentAuth;
  return store.getters['PermissionModule/permissions'];
}

//检查是否拥有权限
export function hasPermission(authority) {
  if (authority!=null && authority instanceof Array && authority.length>0) {
    const permissions = JSON.parse(sessionStorage.getItem('permissions'));
    const flag = authority.every(val => permissions.indexOf(val)>-1);
    if (flag != null && flag) {
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
}


export function check(authority) {
  if (authority && authority instanceof Array && authority.length) {
    const roles = getCurrentAuthority();
    const permissionRoles = authority;

    const hasPermission = roles.some(role => {
      return permissionRoles.includes(role);
    })

    if (!hasPermission) {
      return false;
    }
    return true;
  } else {
    this.$message.error('没有操作权限');
    return false;
  }

  // return current.indexOf(authority) > -1;
  // return current.some(item => authority.includes(item));
}

// export function isLogin () {
//   const current = getCurrentAuthority();
//   return current && current[0] !== 'guest';
// }
