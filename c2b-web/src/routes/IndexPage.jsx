import React from 'react';
import { connect } from 'dva';
import MainLayout from 'components/MainLayout/MainLayout';

function IndexPage({ location, data }) {
    return ( 
        <MainLayout>
           <div>测试</div>
        </MainLayout>
        )
}

export default connect()(IndexPage);