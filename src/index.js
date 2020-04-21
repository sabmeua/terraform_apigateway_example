'use strict';

exports.handler = async (event) => {
    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello world.'),
        headers: {
            'Access-Control-Allow-Origin': '*',
        },
    }

    return response
}
