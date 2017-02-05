gulp = require 'gulp'
coffee  = require 'gulp-coffee'
concat  = require 'gulp-concat'
gutil   = require 'gulp-util'

gulp.task 'default', ['coffee', 'views'], ->

gulp.task 'coffee', ->
  gulp.src 'src/scripts/**/*.coffee'
  .pipe coffee bare: true
  .pipe gulp.dest '_public/js'
  .on 'error', gutil.log

gulp.task 'views', ->
    gulp.src 'src/views/**/*.html'
    .pipe gulp.dest '_public'
    .on 'error', gutil.log