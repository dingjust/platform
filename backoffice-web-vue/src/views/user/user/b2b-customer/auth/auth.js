import store from '@/store';

// const currentAuth

// export { currentAuth };

export function getCurrentAuthority () {
  //   return currentAuth;
  return store.getters['PermissionModule/permissions'];
}

export function check (authority) {
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
