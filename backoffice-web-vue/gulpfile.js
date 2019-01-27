'use strict';

let gulp = require('gulp');
let concat = require('gulp-concat');
let sass = require('gulp-sass');

gulp.task('sass', function () {
  return gulp.src('./src/assets/scss/style.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(concat('style.css'))
    .pipe(gulp.dest('./src/assets/css'))
    .pipe(sass({outputStyle: 'compressed'}))
    .pipe(concat('style.min.css'))
    .pipe(gulp.dest('./src/assets/css'));
});

// Watching SCSS files
gulp.task('sass:watch', function () {
  gulp.watch('./src/assets/scss/**/*.scss', ['sass']);
});

gulp.task('default', ['sass:watch']);
