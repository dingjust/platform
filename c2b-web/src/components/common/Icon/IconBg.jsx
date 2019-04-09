import React, { PropTypes } from 'react';
import classNames from 'classnames';
import styles from './Icon.less';
import Icon from "./Icon"

const IconBg = (props) => {
  return (
    <div className={`${styles.iconBg} ${props.newClass}`}>
      <Icon name={props.name}/>
    </div>
  );
};
export default IconBg;
