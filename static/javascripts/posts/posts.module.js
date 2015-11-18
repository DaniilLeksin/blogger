(function () {
  'use strict';

  angular
    .module('blog.posts', [
      'blog.posts.controllers',
      'blog.posts.directives',
      'blog.posts.services'
    ]);

  angular
    .module('blog.posts.controllers', []);

  angular
    .module('blog.posts.directives', ['ngDialog']);

  angular
    .module('blog.posts.services', []);
})();