var MyHomeApp = angular.module('Site', []);

MyHomeApp.config(['$routeProvider',
                function($routeProvider) {
                  $routeProvider.
                    when('/p-broadway', {
                      templateUrl: 'projPages/p-broadway.html'
                      }).
                    when('/p-marbles', {
                      templateUrl: 'projPages/p-marbles.html'
                    }).
                    when('/p-robotics', {
                      templateUrl: 'projPages/p-robotics.html'
                    }).
                    when('/p-treehouse', {
                      templateUrl: 'projPages/p-treehouse.html'
                    }).
                    when('/p-enscribe', {
                      templateUrl: 'projPages/p-enscribe.html'
                    }).
                    when('/p-macquarium', {
                      templateUrl: 'projPages/p-macquarium.html'
                    }).
                    when('/p-netlogo', {
                      templateUrl: 'projPages/p-netlogo.html'
                    }).
                    when('/p-rocket', {
                      templateUrl: 'projPages/p-rocket.html'
                    }).
                    when('/p-dosemaster', {
                      templateUrl: 'projPages/p-dosemaster.html'
                    }).
                    when('/contact', {
                      templateUrl: 'contact.html'  
                    }).
                    when('/art', {
                      templateUrl: 'art.html'
                    }).
                    when('/portfolio', {
                      templateUrl: 'portfolio.html'
                    }).
                    when('/resume', {
                      templateUrl: 'resume.html'
                    }).
                    when('/about', {
                      templateUrl: 'about.html'
                    }).
                    when('/404', {
                      templateUrl: '404.html'
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