const autoprefixer = require('gulp-autoprefixer');
const browserSync = require('browser-sync').create();
const cleanCss = require('gulp-clean-css');
const gulp = require('gulp');
const rename = require("gulp-rename");
const sass = require('gulp-sass')(require('node-sass'));
const sourcemaps = require('gulp-sourcemaps');

// Define COMMON paths
const paths = {
  src: {
    base: './static/assets',
    css: './static/assets/css',
    scss: './static/assets/scss',
    node_modules: './node_modules/',
    vendor: './vendor'
  }
};

// Compile SCSS
function scss() {
  return gulp.src(paths.src.scss + '/black-dashboard.scss')
    .pipe(sourcemaps.init())
    .pipe(sass().on('error', sass.logError))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest(paths.src.css))
    .pipe(browserSync.stream());
}

// Minify CSS
function minifyCss() {
  return gulp.src(paths.src.css + '/black-dashboard.css')
    .pipe(cleanCss())
    .pipe(rename({ extname: '.min.css' }))
    .pipe(autoprefixer({ overrideBrowserslist: ['last 2 versions'] }))
    .pipe(gulp.dest(paths.src.css))
    .pipe(browserSync.stream());
}

// Default Task: Compile SCSS and minify the result
gulp.task('default', gulp.series(scss, minifyCss));

// Watch Task: Watch for changes and run tasks
gulp.task('watch', function() {
  browserSync.init({
    server: {
      baseDir: paths.src.base
    }
  });

  gulp.watch(paths.src.scss + '/**/*
