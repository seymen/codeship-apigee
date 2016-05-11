/* jshint node:true */
'use strict';

var apickli = require('apickli');

module.exports = function() {
    this.Before(function(scenario, callback) {
        this.apickli = new apickli.Apickli('http', 'httpbin.org');
        callback();
    });
};


