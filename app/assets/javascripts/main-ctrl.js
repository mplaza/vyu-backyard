app.controller('Main-Ctrl', [ '$rootScope', '$scope', '$timeout', '$http', 'Citytimezone',
  function($rootScope, $scope, $timeout, $http, Citytimezone){

  	Citytimezone.query(function(citytimezones) {
      $scope.citytimezones = citytimezones;
      getTimes();
      tick();
    });

  	$scope.tickInterval = 60000;

  	var getTimes = function(){
  		$scope.dubai_now = $scope.citytimezones[0].time.split(" ")[1];
  		$scope.amman_now = $scope.citytimezones[1].time.split(" ")[1];
  		$scope.london_now = $scope.citytimezones[2].time.split(" ")[1];
  		$scope.la_now = $scope.citytimezones[3].time.split(" ")[1];

  		$scope.min = parseInt($scope.dubai_now.split(":")[1]);
  		$scope.dubai_hrs = parseInt($scope.dubai_now.split(":")[0]);
  		$scope.amman_hrs = parseInt($scope.amman_now.split(":")[0]);
  		$scope.london_hrs = parseInt($scope.london_now.split(":")[0]);
  		$scope.la_hrs = parseInt($scope.la_now.split(":")[0]);

  		var dubai_unformatted = $scope.citytimezones[0].time.split(" ")[0].split("-");
  		dubai_unformatted.shift();
  		var amman_unformatted = $scope.citytimezones[1].time.split(" ")[0].split("-");
  		amman_unformatted.shift();
  		var london_unformatted = $scope.citytimezones[2].time.split(" ")[0].split("-");
  		london_unformatted.shift();
  		var la_unformatted = $scope.citytimezones[3].time.split(" ")[0].split("-");
  		la_unformatted.shift();

  		$scope.dubai_date = dubai_unformatted.join('/');
  		$scope.amman_date = amman_unformatted.join('/');
  		$scope.london_date = london_unformatted.join('/');
  		$scope.la_date = la_unformatted.join('/');

  	};

	var tick = function(){
	    $scope.min +=1;
	    if($scope.min > 59){
			$scope.min = $scope.min % 60
	    	$scope.dubai_hrs +=1
	    	$scope.amman_hrs +=1
	    	$scope.london_hrs +=1
	    	$scope.la_hrs +=1
	    }
	    var dubai_am = 'AM';
	    var amman_am = 'AM';
	    var london_am = 'AM';
	    var la_am = 'AM';
	    if ($scope.dubai_hrs > 12){
	    	$scope.dubai_hrs = $scope.dubai_hrs % 12;
	    	dubai_am = 'PM'
	    }
	    	else{dubai_am = 'AM'};
	   	if ($scope.amman_hrs > 12){
	    	$scope.amman_hrs = $scope.amman_hrs % 12;
	    	amman_am = 'PM'
	    }
	    	else{amman_am = 'AM'};
	   	if ($scope.london_hrs > 12){
	    	$scope.london_hrs = $scope.london_hrs % 12;
	    	london_am = 'PM'
	    }
	    	else{london_am = 'AM'};
	   	if ($scope.la_hrs > 12){
	    	$scope.la_hrs = $scope.la_hrs % 12;
	    	la_am = 'PM'
	    }
	    else{la_am = 'AM'};
	    var dubai_hours = $scope.dubai_hrs.toString();
	   	var amman_hours = $scope.amman_hrs.toString();
	    var london_hours = $scope.london_hrs.toString();
	    var la_hours = $scope.la_hrs.toString();

	    var minutes = $scope.min.toString();
	    $scope.dubai_time = dubai_hours + ":" + minutes + dubai_am;
	    $scope.amman_time = amman_hours + ":" + minutes + amman_am;
	    $scope.london_time = london_hours + ":" + minutes + london_am;
	    $scope.la_time = la_hours + ":" + minutes + la_am;

	    $timeout(tick, $scope.tickInterval);
  	}



  	


}]);