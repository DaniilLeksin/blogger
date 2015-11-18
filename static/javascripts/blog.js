(function () {
  'use strict';

  angular
    .module('blog', [
	  'blog.config',
      'blog.routes',
      'blog.authentication',
      'blog.layout',
      'blog.posts',
      'blog.utils',
      'blog.profiles' 
    ]);

  angular
	.module('blog.config', []);

  angular
    .module('blog.routes', ['ngRoute']);

  angular
    .module('blog')
    .run(run);

  run.$inject = ['$http'];

  /**
   * @name run
   * @desc Update xsrf $http headers to align with Django's defaults
   */
  function run($http) {
    $http.defaults.xsrfHeaderName = 'X-CSRFToken';
    $http.defaults.xsrfCookieName = 'csrftoken';
  }
})();
