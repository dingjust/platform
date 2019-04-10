import React, { PropTypes } from 'react';
import classNames from 'classnames';
import styles from './Icon.less';

const convertUnicode = input =>
  input.replace(/\\u(\w\w\w\w)/g, (a, b) =>
    String.fromCharCode(parseInt(b, 16))
  );
const Icon = (props) => {
  return (
    <i className={classNames(styles.icon)+` iconfont ${props.name} ${props.newClass}`}></i>
  );
};

export default Icon;
