var MyHomeApp = angular.module('Site', []);

MyHomeApp.config(['$routeProvider',
                function($routeProvider) {
                  $routeProvider.
                    when('/contact', {
                      templateUrl: 'contact.html'
                    }).
                    when('/p-broadway', {
                      templateUrl: 'projPages/p-broadway.html'
                      }).
                    when('/p-marbles', {
                      templateUrl: 'projPages/p-marbles.html'
                    }).
                    when('/resume', {
                      templateUrl: 'resume.html'
                    }).
                    when('/about', {
                      templateUrl: 'about.html'
                    }).
                    when('/home', {
                        templateUrl: 'home.html',
                        controller: 'WGHomeLanCtrl'
                      }).
                    otherwise({
                      templateUrl: 'home.html',
                      controller: 'WGHomeLanCtrl'
                    });
                }]);   
                
MyHomeApp.controller( 'WGHomeLanCtrl', function ( $scope ) {
});