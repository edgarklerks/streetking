<div class="race-car-box-container corner-box">
	[:when (race.data.length == 2)]{
		<div class="race-car-element-container">
			<div class="float-left float-left-race-car-element race-car-element-box-container">
				<div class="race-car-element-image-container race-car-element-image-container-image" id="labelling-car-[:race.data.0.rd_user.id]" style='background-image:url([:eval IMAGESERVER("[\"user_car\","+race.data.0.rd_car.id+",\"car\"]")])'>
					<!--<a href="#Garage/car?car_instance_id=[:race.data.0.rd_car.id]" module="GARAGE_CAR_INFO"><div class="race-car-element-image-zoom car-image-zoom">&nbsp;</div></a>-->
					<a href="#" class="car_info" oid="0"><div class="race-car-element-image-zoom car-image-zoom">&nbsp;</div></a>
				</div>	
				<div class="speedometer-box-small">
					<img src="images/speedometer_small_pointer.png" id="speedometer-pointer-[:race.data.0.rd_user.id]" class="speedometer_pointer-small">
					<div id="digital-speedometer-[:race.data.0.rd_user.id]" class="digital-speedometer-small">10</div>
				</div>
				<div class="clearfix"></div>
				<div class="race-car-element-infotext-container">
					<div class="race-car-element-infotext-user-box">
						<div class="race-car-element-infotext-user-image-box normal" style="background-image:url([:race.data.0.rd_user.picture_small]);"></div>
						<div class="race-car-element-infotext-user-name-box">
							<div class="race-car-element-infotext-username-label">[:race.data.0.rd_user.nickname]</div>
							<div class="race-car-element-infotext-user-level-label">Level: <span>[:race.data.0.rd_user.level]</span></div>
						</div>
						<div></div>
					</div>
					<div class="race-car-element-infotext-manufacture-box">
						<div class="race-car-element-infotext-manufacture-logo-box normal" style="background-image:url(images/manufacturers/[:eval REPLACESPACE(race.data.0.rd_car.manufacturer_name)]_logo.png);"></div>
						<div class="race-car-element-infotext-manufacture-name-box">
							<div class="race-car-element-infotext-manufacture-name">[:race.data.0.rd_car.manufacturer_name]</div>
							<div class="race-car-element-infotext-model-name">[:race.data.0.rd_car.name]</div>
							<div>Year:&nbsp;<span>[:race.data.0.rd_car.year]</span></div>
							<div>Level:&nbsp;<span>[:race.data.0.rd_car.level]</span></div>
						</div>
					</div>
				</div>
			</div>
			<div class="float-left race-car-element-center">
				<div class="race-car-element-border"></div>
				<div class="race-car-element-vs">VS</div>
				<div class="race-car-element-border-bottom"></div>
			</div>
			<div class="float-right float-right-race-car-element race-car-element-box-container">
				<div class="race-car-element-image-container race-car-element-image-container-image" id="labelling-car-[:race.data.1.rd_user.id]" style='background-image:url([:eval IMAGESERVER("[\"user_car\","+race.data.1.rd_car.id+",\"car\"]")])'>
					<!--<a href="#Garage/car?car_instance_id=[:race.data.1.rd_car.id]" module="GARAGE_CAR_INFO"><div class="race-car-element-image-zoom car-image-zoom">&nbsp;</div></a>-->
					<a href="#" class="car_info" oid="1"><div class="race-car-element-image-zoom car-image-zoom">&nbsp;</div></a>
				</div>	
				<div class="speedometer-box-small">
					<img src="images/speedometer_small_pointer.png" id="speedometer-pointer-[:race.data.1.rd_user.id]" class="speedometer_pointer-small">
					<div id="digital-speedometer-[:race.data.1.rd_user.id]" class="digital-speedometer-small">10</div>
				</div>
<!--				<div>[:race.data.1.rd_user.nickname]</div>-->
				<div class="clearfix"></div>
				<div class="race-car-element-infotext-container">
					<div class="race-car-element-infotext-user-box">
						<div class="race-car-element-infotext-user-image-box normal" style="background-image:url([:race.data.1.rd_user.picture_small]);"></div>
						<div class="race-car-element-infotext-user-name-box">
							<div class="race-car-element-infotext-username-label">[:race.data.1.rd_user.nickname]</div>
							<div class="race-car-element-infotext-user-level-label">Level: <span>[:race.data.1.rd_user.level]</span></div>
						</div>
						<div></div>
					</div>
					<div class="race-car-element-infotext-manufacture-box">
						<div class="race-car-element-infotext-manufacture-logo-box normal" style="background-image:url(images/manufacturers/[:eval REPLACESPACE(race.data.1.rd_car.manufacturer_name)]_logo.png);"></div>
						<div class="race-car-element-infotext-manufacture-name-box">
							<div class="race-car-element-infotext-manufacture-name">[:race.data.1.rd_car.manufacturer_name]</div>
							<div class="race-car-element-infotext-model-name">[:race.data.1.rd_car.name]</div>
							<div>Year:&nbsp;<span>[:race.data.1.rd_car.year]</span></div>
							<div>Level:&nbsp;<span>[:race.data.1.rd_car.level]</span></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="clearfix"></div>
	}
	[:when (race.data.length == 1)]{
		<div class="race-car-element-container">
			<div class="float-left">
				<div class="race-car-element-image-container race-car-element-image-container-image" id="labelling-car-[:race.data.0.rd_user.id]" style='background-image:url([:eval IMAGESERVER("[\"user_car\","+race.data.0.rd_car.id+",\"car\"]")])'>
					<!--<a href="#Garage/car?car_instance_id=[:race.data.0.rd_car.id]" module="GARAGE_CAR_INFO"><div class="race-car-element-image-zoom car-image-zoom">&nbsp;</div></a>-->
					<a href="#" class="car_info" oid="0"><div class="race-car-element-image-zoom car-image-zoom">&nbsp;</div></a>
				</div>	
				<div class="speedometer-box">
					<img src="images/speedometer_pointer.png" id="speedometer-pointer-[:race.data.0.rd_user.id]" class="speedometer_pointer">
					<div id="digital-speedometer-[:race.data.0.rd_user.id]" class="digital-speedometer">10</div>
				</div>
			</div>
			<div class="float-left race-car-element-vertical-line"></div>
			<div class="float-right">
				<div class="race-car-element-infotext-container">
					<div class="race-car-element-infotext-user-box">
						<div class="race-car-element-infotext-user-image-box normal" style="background-image:url([:race.data.0.rd_user.picture_small]);"></div>
						<div class="race-car-element-infotext-user-name-box">
							<div class="race-car-element-infotext-username-label">[:race.data.0.rd_user.nickname]</div>
							<div class="race-car-element-infotext-user-level-label">Level: <span>[:race.data.0.rd_user.level]</span></div>
						</div>
						<div></div>
					</div>
					<div class="race-car-element-infotext-manufacture-box">
						<div class="race-car-element-infotext-manufacture-logo-box normal" style="background-image:url(images/manufacturers/[:eval REPLACESPACE(race.data.0.rd_car.manufacturer_name)]_logo.png);"></div>
						<div class="race-car-element-infotext-manufacture-name-box">
							<div class="race-car-element-infotext-manufacture-name">[:race.data.0.rd_car.manufacturer_name]</div>
							<div class="race-car-element-infotext-model-name">[:race.data.0.rd_car.name]</div>
							<div>Year:&nbsp;<span>[:race.data.0.rd_car.year]</span></div>
							<div>Level:&nbsp;<span>[:race.data.0.rd_car.level]</span></div>
						</div>
					</div>
				</div>
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
			</div>
		</div>
		<div class="clearfix"></div>
	}
</div>