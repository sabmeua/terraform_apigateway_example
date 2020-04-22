'use strict';

exports.handler = async (event) => {
    const response = {
        statusCode: 200,
        body: JSON.stringify('こんにちは 世界. ver.1!'),
        headers: {
            'Access-Control-Allow-Origin': 'example.com',
        },
    }

    return response
}
