var app = angular.module('BackyardApp', [
  "ngResource"
]);

app.config(['$httpProvider', function($httpProvider) {
    var authToken = angular.element("meta[name=\"csrf-token\"]").attr("content");
    var defaults = $httpProvider.defaults.headers;
    
    defaults.common["X-CSRF-TOKEN"] = authToken;
    defaults.patch = defaults.patch || {};
    defaults.patch['Content-Type'] = 'application/json';
    defaults.common['Accept'] = 'application/json';
}]);

app.factory('Citytimezone', ['$resource', function($resource) {
  return $resource('/citytimezones',
     {},
     {update: { method: 'PATCH'}});
}]);