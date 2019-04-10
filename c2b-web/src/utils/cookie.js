(function (root, deps, exportName, factory) {
    if (typeof deps === 'string') {
        factory = exportName;
        exportName = deps;
        deps = [];
    }

    if (typeof module === 'object' && module.exports) {
        module.exports = factory();
    } else if (typeof define === 'function' && define.amd) {
        define(deps, factory);
    } else {
        root[exportName] = factory();
  }
}(this, 'Cookie', function() {
    return {
        /**
         * 添加cookie
         *
         * @instance
         * @param name  { String } cookie键
         * @param value { String } cookie值
         * @param hours { Nunber } cookie有效期，单位小时
         * @param domain { String } cookie的domain
         * @param path { String } cookie的path，默认为'/'
         */
        set: function(name, value, hours, domain, path) {
            var date = new Date();
            date.setTime(date.getTime() + (hours || 24) * 3600 * 1000);
            var cookieStr = name + '=' + escape(value) + ';expires=' + date.toGMTString() + ';path=' + (path || '/');
            if (domain) {
                cookieStr += ';domain=' + domain;
            }
            document.cookie = cookieStr;
            return this;
        },
        /**
         * 获取cookie
         *
         * @instance
         * @param name  { String } cookie键
         */
        get: function(name) {
            var c = document.cookie,
                hasName = c.match(new RegExp('^\\s*' + name + '(?==)|;\\s*' + name + '(?==)')),
                value = hasName && new RegExp(name + '=([^;]*)(?:(?=;)|$)').exec(c);

            return hasName ? value[1] || value[2] : null;

        },
        /**
         * 删除cookie
         *
         * @instance
         * @param name  { String } cookie键
         * @param domain { String } cookie的domain
         * @param path { String } cookie的path，默认为'/'
         */
        remove: function(name, domain, path) {
            this.set(name, '', -1, domain, path);
            return this;
        }
    };
}));