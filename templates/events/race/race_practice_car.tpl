<div class="race-car-box-container corner-box">
	[:when (race.data.length == 2)]{
		<div class="race-car-element-container">
			<div class="race-car-element-left">
<!--				<div class="race-car-element-image-container race-car-element-image-container-image" style="background-image:url(test_store/car_[:race.data.0.rd_car.id].jpg?t=[:eval TIMESTAMP(id)])"> -->
				<div class="race-car-element-image-container race-car-element-image-container-image" style='background-image:url([:eval IMAGESERVER("[\"user_car\","+race.data.0.rd_car.id+",\"car\"]")])'>
					<a href="#Garage/car?car_instance_id=[:race.data.0.rd_car.id]" module="GARAGE_CAR_INFO"><div class="race-car-element-image-zoom car-image-zoom">&nbsp;</div></a>
				</div>	
			</div>
			<div class="race-car-element-center">
				<div class="race-car-element-border"></div>
				<div class="race-car-element-vs">VS</div>
				<div class="race-car-element-border"></div>
			</div>
			<div class="race-car-element-right">
<!--				<div class="race-car-element-image-container race-car-element-image-container-image" style="background-image:url(test_store/car_[:race.data.1.rd_car.id].jpg?t=[:eval TIMESTAMP(id)])">-->
				<div class="race-car-element-image-container race-car-element-image-container-image" style='background-image:url([:eval IMAGESERVER("[\"user_car\","+race.data.1.rd_car.id+",\"car\"]")])'>
					<a href="#Garage/car?car_instance_id=[:race.data.1.rd_car.id]" module="GARAGE_CAR_INFO"><div class="race-car-element-image-zoom car-image-zoom">&nbsp;</div></a>
				</div>	
			</div>
			<div class="clearfix"></div>
		</div>
		<div class="clearfix"></div>
	}
	[:when (race.data.length == 1)]{
		<div class="race-car-element-container">
<!--			<div class="race-car-element-image-container race-car-element-image-container-image" style="background-image:url(test_store/car_[:race.data.0.rd_car.id].jpg?t=[:eval TIMESTAMP(id)])">-->
			<div class="race-car-element-image-container race-car-element-image-container-image" style='background-image:url([:eval IMAGESERVER("[\"user_car\","+race.data.0.rd_car.id+",\"car\"]")])'>
				<a href="#Garage/car?car_instance_id=[:race.data.0.rd_car.id]" module="GARAGE_CAR_INFO"><div class="race-car-element-image-zoom car-image-zoom">&nbsp;</div></a>
			</div>	
			<div class="race-car-element-data-container">
				<div class="race-car-element-info-container">
					<div class="race-car-element-infotext-container">
						<div>Manufacturer:&nbsp;<span>[:race.data.0.rd_car.manufacturer_name]</span></div>
						<div>Model:&nbsp;<span>[:race.data.0.rd_car.name]</span></div>
						<div>Year:&nbsp;<span>[:race.data.0.rd_car.year]</span></div>
						<div>Level:&nbsp;<span>[:race.data.0.rd_car.level]</span></div>
					</div>
					<div class="race-car-element-vertical-line"></div>
					<div class="race-car-element-infobar-container">
						<div class="race-car-element-info-data-box">
							<div class="race-car-element-info-data-name">Top speed <span>[:eval round(race.data.0.rd_car.top_speed/10000)]</span> km/h</div>
							<div class="race-car-element-progress-bar-box ui-corner-all-1px">
								<div class="race-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.top_speed/100)*100)]%"></div>
							</div>
						</div>
						<div class="race-car-element-info-data-box">
							<div class="race-car-element-info-data-name">Acceleration <span>[:eval round(race.data.0.rd_car.acceleration/1000)/10]</span> s</div>
							<div class="race-car-element-progress-bar-box ui-corner-all-1px">
								<div class="race-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.acceleration/100)*100)]%"></div>
							</div>
						</div>
						<div class="race-car-element-info-data-box">
							<div class="race-car-element-info-data-name">Braking <span>[:race.data.0.rd_car.braking]</span></div>
							<div class="race-car-element-progress-bar-box ui-corner-all-1px">
								<div class="race-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.braking/100)*100)]%"></div>
							</div>
						</div>
						<div class="race-car-element-info-data-box">
							<div class="race-car-element-info-data-name">Handling <span>[:race.data.0.rd_car.handling]</span></div>
							<div class="race-car-element-progress-bar-box ui-corner-all-1px">
								<div class="race-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.handling/100)*100)]%"></div>
							</div>
						</div>
						<div class="race-car-element-info-data-box">
							<div class="race-car-element-info-data-name">Weight <span>[:race.data.0.rd_car.weight]</span> kg</div>
							<div class="race-car-element-progress-bar-box ui-corner-all-1px">
								<div class="race-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.weight/100)*100)]%"></div>
							</div>
						</div>
					</div>
					<div class="clearfix"></div>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
		<div class="clearfix"></div>
	}
	<div class="clearfix"></div>
	<div class="race-speedometer-element-container">
		<div class="speedometer-left">
			<img src="images/speedometer_pointer.png" id="speedometer-pointer-left" class="speedometer_pointer">
			<div id="digital-speedometer-left" class="digital-speedometer">0</div>
		</div>
		<div class="speedometer-right">
			<img src="images/speedometer_pointer.png" id="speedometer-pointer-right" class="speedometer_pointer">
			<div id="digital-speedometer-right" class="digital-speedometer">0</div>
		</div>
	<div>
</div>
