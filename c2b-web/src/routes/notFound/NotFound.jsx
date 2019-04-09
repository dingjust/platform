import React from 'react';
import styles from './NotFound.less';

function NotFound({ location }) {
  return (
    <div className={styles.normal}>
      <h1 className={styles.title}>抱歉！<code>{location.pathname}</code>页面无法访问……</h1>
      <div className={styles.welcome} />
    </div>
  );
}

export default NotFound;
