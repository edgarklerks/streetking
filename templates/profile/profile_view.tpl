<div mtitle="[:user.nickname] profile information">
	<div>
		<div id="user-photo" style="background-image:url([:user.picture_small])" class="ui-corner-all-4px"></div>
		<div>nickname: <span>[:user.nickname]</span></div>
		<div>level: <span>[:user.level]</span></div>
		<div>now in: <span>[:user.continent_name], [:user.city_name]</span></div>
	</div>
	<div class="clearfix"></div>
	<div class="car-element-container backgound-darkgray">
		<div class="car-element-image-container car-element-image-container-image" style="background-image:url(test_store/car_[:car.id].jpg?t=[:eval TIMESTAMP(id)])">&nbsp;</div>
		<div class="car-element-data-container">
			<div class="car-element-info-container">
				<div class="car-element-infotext-container">
					<div>Manufacturer:&nbsp;<span>[:car.manufacturer_name]</span></div>
					<div>Model:&nbsp;<span>[:car.name]</span></div>
					<div>Year:&nbsp;<span>[:car.year]</span></div>
					<div>Level:&nbsp;<span>[:car.level]</span></div>
				</div>
				<div class="car-element-vertical-line"></div>
				<div class="car-element-infobar-container">
					<div class="car-element-info-data-box">
						<div class="car-element-info-data-name">Top speed <span>[:car.top_speed]</span> km/h</div>
						<div class="car-element-progress-bar-box ui-corner-all-1px">
							<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((car.top_speed/100)*100)]%"></div>
						</div>
					</div>
					<div class="car-element-info-data-box">
						<div class="car-element-info-data-name">Acceleration <span>[:car.acceleration]</span> s</div>
						<div class="car-element-progress-bar-box ui-corner-all-1px">
							<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((car.acceleration/100)*100)]%"></div>
						</div>
					</div>
					<div class="car-element-info-data-box">
						<div class="car-element-info-data-name">Braking <span>[:car.braking]</span></div>
						<div class="car-element-progress-bar-box ui-corner-all-1px">
							<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((car.braking/100)*100)]%"></div>
						</div>
					</div>
					<div class="car-element-info-data-box">
						<div class="car-element-info-data-name">Handling <span>[:car.handling]</span></div>
						<div class="car-element-progress-bar-box ui-corner-all-1px">
							<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((car.handling/100)*100)]%"></div>
						</div>
					</div>
					<div class="car-element-info-data-box">
						<div class="car-element-info-data-name">Weight <span>[:car.weight]</span> kg</div>
						<div class="car-element-progress-bar-box ui-corner-all-1px">
							<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((car.weight/100)*100)]%"></div>
						</div>
					</div>
				</div>
				<div class="clearfix"></div>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
</div>