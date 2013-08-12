<div class="profile-view-container" mtitle="{{=sk.user.nickname}} profile information">
	<div class="profile-view-info-container">
		<div class="profile-view-info-user-container backgound-darkgray">
			<div class="profile-view-info-user-image-container" style="background-image:url({{=sk.user.picture_small}})">&nbsp;</div>
			<div class="profile-view-info-user-infotext-container">
				<div>Driver: <span>{{=sk.user.nickname}}</span></div>
				<div>Level: <span>{{=sk.user.level}}</span></div>
				<div>Location: <span>{{=sk.user.continent_name}}, {{=sk.user.city_name}}</span></div>
			</div>
		</div>
		<div class="profile-view-info-car-container backgound-darkgray">
			<div class="profile-view-info-car-image-container profile-view-info-car-image-container-image" style="background-image:url({{= Config.imageUrl('user_car',sk.car.id,'car')}})">&nbsp;</div>
			<div class="profile-view-info-car-data-container">
				<div class="profile-view-info-car-info-container">
					<div class="profile-view-info-car-infotext-container">
						<div>Manufacturer:&nbsp;<span>{{=sk.car.manufacturer_name}}</span></div>
						<div>Model:&nbsp;<span>{{=sk.car.name}}</span></div>
						<div>Year:&nbsp;<span>{{=sk.car.year}}</span></div>
						<div>Level:&nbsp;<span>{{=sk.car.level}}</span></div>
					</div>
					<div class="profile-view-info-car-vertical-line"></div>
					<div class="profile-view-info-car-infobar-container">
						<div class="profile-view-info-car-info-data-box">
							<div class="profile-view-info-car-info-data-name">Top speed <span>{{=sk.car.top_speed_values.text}}</span> km/h</div>
							<div class="profile-view-info-car-progress-bar-box ui-corner-all-1px">
								<div class="profile-view-info-car-progress-bar ui-corner-all-1px" style="width:{{=sk.car.top_speed_values.bar}}%"></div>
							</div>
						</div>
						<div class="profile-view-info-car-info-data-box">
							<div class="profile-view-info-car-info-data-name">Acceleration <span>{{=sk.car.acceleration_values.text}}</span> s</div>
							<div class="profile-view-info-car-progress-bar-box ui-corner-all-1px">
								<div class="profile-view-info-car-progress-bar ui-corner-all-1px" style="width:{{=sk.car.acceleration_values.bar}}%"></div>
							</div>
						</div>
						<div class="profile-view-info-car-info-data-box">
							<div class="profile-view-info-car-info-data-name">Braking <span>{{=sk.car.stopping_values.text}}</span></div>
							<div class="profile-view-info-car-progress-bar-box ui-corner-all-1px">
								<div class="profile-view-info-car-progress-bar ui-corner-all-1px" style="width:{{=sk.car.stopping_values.bar}}%"></div>
							</div>
						</div>
						<div class="profile-view-info-car-info-data-box">
							<div class="profile-view-info-car-info-data-name">Handling <span>{{=sk.car.cornering_values.text}}</span></div>
							<div class="profile-view-info-car-progress-bar-box ui-corner-all-1px">
								<div class="profile-view-info-car-progress-bar ui-corner-all-1px" style="width:{{=sk.car.cornering_values.bar}}%"></div>
							</div>
						</div>
						<div class="profile-view-info-car-info-data-box">
							<div class="profile-view-info-car-info-data-name">Weight <span>{{=sk.car.weight_values.text}}</span> kg</div>
							<div class="profile-view-info-car-progress-bar-box ui-corner-all-1px">
								<div class="profile-view-info-car-progress-bar ui-corner-all-1px" style="width:{{=sk.car.weight_values.bar}}%"></div>
							</div>
						</div>
					</div>
					<div class="clearfix"></div>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="profile-view-achievements-container">
		<div class="profile-view-achievements-title">Player achievements</div>
		<div class="profile-view-achievements-content inner-scroll-box" id="profile-view-achievements">
			<div class="profile-view-achievements-element">Currently not available information.</div>
		</div>
	</div>
</div>