/**
 * @providesModule RNSimpleShare
 */
'use strict';

var React = require('react-native');
var {
  NativeModules
} = React;


var SimpleShare = NativeModules.RNSimpleShare;

/**
 * High-level docs for the RNSimpleShare iOS API can be written here.
 */

var RNSimpleShare = {
  show: SimpleShare.show
};

module.exports = RNSimpleShare;
