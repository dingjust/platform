import React from 'react';
import { connect } from 'dva';
import Loader from '../Loader/Loader';

function Detail({ location, loading, data }) {
  if (loading) {
    const spinning = true;
    return (
      <Loader spinning={spinning} />
    );
  } 
  function createMarkup() { return {__html: data.content}; };
  return (
    <div dangerouslySetInnerHTML={createMarkup()} />
  );
}

function mapStateToProps(state) {
  const { data } = state.detail;
  return {
    loading: state.loading.models.detail,
    data,
  };
}

export default connect(mapStateToProps)(Detail);
