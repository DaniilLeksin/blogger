(function () {
  'use strict';

  angular
    .module('blog.authentication', [
      'blog.authentication.controllers',
      'blog.authentication.services'
    ]);

  angular
    .module('blog.authentication.controllers', []);

  angular
    .module('blog.authentication.services', ['ngCookies']);
})();

