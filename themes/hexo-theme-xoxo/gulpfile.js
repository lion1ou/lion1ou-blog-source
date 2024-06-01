'use strict';

var gulp = require('gulp');
var less = require('gulp-less');
var uglify = require('gulp-uglify');
var concat = require('gulp-concat');
var LessAutoprefix = require('less-plugin-autoprefix');

var autoprefix = new LessAutoprefix({ browsers: ['last 2 versions'] });

function watch() {
  gulp.watch('./source/_less/*.less', css);
  gulp.watch('./source/_js/*.js', js);
}

function css(cb) {
  return gulp
    .src('./source/_less/main.less')
    .pipe(less({ plugins: [autoprefix] }))
    .pipe(gulp.dest('./source/css/', { overwrite: true }));
}

function js(cb) {
  return gulp
    .src('./source/_js/*.js')
    .pipe(concat('main.js'))
    .pipe(uglify())
    .pipe(gulp.dest('./source/js/', { overwrite: true }));
}

exports.default = gulp.series(css, js, watch);
exports.build = gulp.series(css, js);
