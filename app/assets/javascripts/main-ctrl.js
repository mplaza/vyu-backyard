app.controller('Main-Ctrl', [ '$rootScope', '$scope', '$timeout', '$http', 'Citytimezone', 'Profile', 'Tool',
  function($rootScope, $scope, $timeout, $http, Citytimezone, Profile, Tool){

  	Citytimezone.query(function(citytimezones) {
      $scope.citytimezones = citytimezones;
      getTimes();
      tick();
    });

    Profile.query(function(profiles) {
      $scope.profiles = profiles;
    });

    $scope.getId = function(profile){
    	return profile._id.$oid;
    }

    Tool.query(function(tools) {
      $scope.tools = tools;
    });

  	$scope.tickInterval = 60000;

  	$scope.weekdays = ['Sun', 'Mon', 'Tues', 'Wed', 'Thur', 'Fri', 'Sat']

  	var getTimes = function(){
  		console.log('timin')
  		$scope.dubai_now = $scope.citytimezones[0].time.split("T")[1].split("+")[0];
  		$scope.amman_now = $scope.citytimezones[1].time.split("T")[1].split("+")[0];
  		$scope.london_now = $scope.citytimezones[2].time.split("T")[1].split("+")[0];
  		$scope.la_now = $scope.citytimezones[3].time.split("T")[1].split("+")[0];
  		$scope.cairo_now = $scope.citytimezones[4].time.split("T")[1].split("+")[0];

  		$scope.min = parseInt($scope.dubai_now.split(":")[1]);
  		$scope.dubai_hrs = parseInt($scope.dubai_now.split(":")[0]);
  		$scope.amman_hrs = parseInt($scope.amman_now.split(":")[0]);
  		$scope.london_hrs = parseInt($scope.london_now.split(":")[0]);
  		$scope.la_hrs = parseInt($scope.la_now.split(":")[0]);
  		$scope.cairo_hrs = parseInt($scope.cairo_now.split(":")[0]);

  		// var dubai_unformatted = $scope.citytimezones[0].time.split(" ")[0].split("-");
  		// dubai_unformatted.shift();
  		// var amman_unformatted = $scope.citytimezones[1].time.split(" ")[0].split("-");
  		// amman_unformatted.shift();
  		// var london_unformatted = $scope.citytimezones[2].time.split(" ")[0].split("-");
  		// london_unformatted.shift();
  		// var la_unformatted = $scope.citytimezones[3].time.split(" ")[0].split("-");
  		// la_unformatted.shift();

  		// $scope.dubai_date = dubai_unformatted.join('/');
  		// $scope.amman_date = amman_unformatted.join('/');
  		// $scope.london_date = london_unformatted.join('/');
  		// $scope.la_date = la_unformatted.join('/');

  		dubai_date = new Date($scope.citytimezones[0].time);
  		$scope.dubai_day = $scope.weekdays[dubai_date.getDay()];
  		amman_date = new Date($scope.citytimezones[1].time);
  		$scope.amman_day = $scope.weekdays[amman_date.getDay()];
  		london_date = new Date($scope.citytimezones[2].time);
  		$scope.london_day = $scope.weekdays[london_date.getDay()];
  		la_date = new Date($scope.citytimezones[3].time);
  		$scope.la_day = $scope.weekdays[la_date.getDay()];
  		cairo_date = new Date($scope.citytimezones[4].time);
  		$scope.cairo_day = $scope.weekdays[cairo_date.getDay()];


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
	    if($scope.min < 10){
			$scope.disp_min = '0' + $scope.min
			}
		else{
			$scope.disp_min = $scope.min
			};
	    
	    var dubai_am = 'AM';
	    var amman_am = 'AM';
	    var london_am = 'AM';
	    var la_am = 'AM';
	    if ($scope.dubai_hrs == 0){
	    	$scope.dubai_hrs = 12;
	    	dubai_am = 'AM'
	    }
	    if ($scope.amman_hrs == 0){
	    	$scope.amman_hrs = 12;
	    	amman_am = 'AM'
	    }
	    if ($scope.london_hrs == 0){
	    	$scope.london_hrs = 12;
	    	london_am = 'AM'
	    }
	    if ($scope.la_hrs == 0){
	    	$scope.la_hrs = 12;
	    	la_am = 'AM'
	    }
	    if ($scope.cairo_hrs == 0){
	    	$scope.cairo_hrs = 12;
	    	cairo_am = 'AM'
	    }
	    	
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
	    if ($scope.cairo_hrs > 12){
	    	$scope.cairo_hrs = $scope.cairo_hrs % 12;
	    	cairo_am = 'PM'
	    }
	    else{cairo_am = 'AM'};
	    var dubai_hours = $scope.dubai_hrs.toString();
	   	var amman_hours = $scope.amman_hrs.toString();
	    var london_hours = $scope.london_hrs.toString();
	    var la_hours = $scope.la_hrs.toString();
	    var cairo_hours = $scope.cairo_hrs.toString();

	    var minutes = $scope.disp_min.toString();
	    $scope.dubai_time = dubai_hours + ":" + minutes + dubai_am;
	    $scope.amman_time = amman_hours + ":" + minutes + amman_am;
	    $scope.london_time = london_hours + ":" + minutes + london_am;
	    $scope.la_time = la_hours + ":" + minutes + la_am;
	    $scope.cairo_time = cairo_hours + ":" + minutes + cairo_am;

	    $timeout(tick, $scope.tickInterval);
  	}



  	


}]);