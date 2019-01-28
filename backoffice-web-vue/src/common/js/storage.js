/**
 * localStorage enhance
 */
export default class Storage {

  parseTime (time, s) {
    let day = 0, hour = 0, mins = 0, dhm, hm, shm
    let timestamp = new Date().getTime()
    const ONE_MINUTE = 1000 * 60
    const ONE_HOUR = ONE_MINUTE * 60
    time = String(time)
    if (!isNaN(time) && s)  {
      timestamp += Number(time)
    } else if ((!isNaN(time) && time) || typeof time === 'string') {
      hm = time
      if (time && !isNaN(time)) {
        day = Number(time)
      } else if (/\-/g.test(time)) {
        dhm = time.split('-')
        day = Number(dhm[0] || 0)
        hm = dhm[1]
      }
      if (hm && /^\d+\:\d+$/g.test(hm)) {
        shm = hm.split(':')
        hour = Number(shm[0] || 0)
        mins = Number(shm[1] || 0)
      }
      timestamp += ONE_HOUR * day + ONE_HOUR * hour + ONE_MINUTE * mins
    } else {
      timestamp = 0
    }
    return timestamp
  }
  remove (name) {
    localStorage.removeItem(name)
  }
  /**
   * @param value 需要设置的值
   * @param outtime 过期时间, 格式：天-时:分
   */
  set (name, value, outtime, s) {
    if (localStorage && typeof name === 'string' && typeof value !== 'undefined') {
      localStorage.setItem(name, JSON.stringify({ time: this.parseTime(outtime, s), value: value }))
    }
  }
  /**
   * 获取已存储的字段内容
   */
  get (name) {
    let valout, value, nowtime = new Date().getTime()
    if (localStorage && typeof name === 'string') {
      value = localStorage.getItem(name)
      if (value) {
        try {
          valout = JSON.parse(value)
          if (valout.time > 0 && nowtime > valout.time) {
            valout = null
            localStorage.removeItem(name)
          } else {
            valout = valout.value
          }
        } catch (e) {
          valout = value
        }
      }
    }
    return valout
  }
}
