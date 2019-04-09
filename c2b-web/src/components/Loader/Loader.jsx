import React, { PropTypes } from 'react';
import classNames from 'classnames';
import styles from './Loader.less';

const Loader = ({ spinning }) => {
  return (<div className={classNames(styles.loader, { [styles.hidden]: !spinning })}>
    <div className={styles.warpper}>
      <div className={styles.inner} />
      <div className={styles.text} >加载中...</div>
    </div>
  </div>
  );
};

Loader.propTypes = {
  spinning: PropTypes.bool,
};
Loader.defaultProps = {
  spinning: true,
};

export default Loader;
