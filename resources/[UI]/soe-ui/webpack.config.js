const webpack = require('webpack');
const path = require('path');
const glob = require("glob");

module.exports = {
    mode: 'production',
    entry: glob.sync('./src/*/*.ts'),
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                loader: 'ts-loader',
                exclude: /node_modules/,
            },
        ],
    },
    resolve: {
        extensions: [".tsx", ".ts", ".js"],
        fallback: {
            "fs": false,
            "tls": false,
            "net": false,
            "path": false,
            "zlib": false,
            "http": false,
            "https": false,
            "stream": false,
            "crypto": false,
        },
    },
    output: {
        filename: 'main.js',
        path: path.join(__dirname, '/html/js')
    },
};
