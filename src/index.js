'use strict';

exports.handler = async (event) => {
    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello world. ver.1!'),
        headers: {
            'Access-Control-Allow-Origin': '*',
        },
    }

    return response
}
