var animateApp = angular.module('animateApp', ['ngRoute', 'ngAnimate']);

animateApp.config(function($routeProvider) {
    $routeProvider
        .when('/', {
    		templateUrl: 'home.html',
            controller: 'mainController'
    	})
    	.when('/home', {
    		templateUrl: 'home.html',
            controller: 'mainController'
    	})
    	.when('/about', {
    		templateUrl: 'about.html',
            controller: 'aboutController'
    	})
    	.when('/contact', {
    		templateUrl: 'contact.html',
            controller: 'contactController'
    	});

});

animateApp.controller('mainController', function($scope) {
    $scope.pageClass = 'home';
});

animateApp.controller('aboutController', function($scope) {
    $scope.pageClass = 'about';
});

animateApp.controller('contactController', function($scope) {
    $scope.pageClass = 'contact';
});