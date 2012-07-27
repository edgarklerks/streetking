<div class="race-money-opponent-element-container backgound-darkgray">
	<div class="race-money-opponent-element-car-image-container race-money-opponent-element-car-image" style="background-image:url(test_store/car_[:car_instance_id].jpg?t=1343309601111)">&nbsp;</div>
	<div class="race-money-opponent-element-user-info-container">
		<div class="race-money-opponent-element-user-container">
			<div class="race-money-opponent-element-user-image-container backgound-blue">
				<div class="race-money-opponent-element-user-image" style="background-image:url([:eval RETURNUSERIMAGE(user_photo)])">&nbsp;</div>
			</div>
			<div class="race-money-opponent-element-user-info">
				<div>Race by:</div>
				<div><a href="#User/data?id=[:profile.id]" module="PROFILE_VIEW">[:eval RETURNINFO(profile.nickname)]</a></div>
			</div>
			<div class="clearfix"></div>
		</div>
		<div>Manufacturer:&nbsp;<span>[:eval RETURNINFO(car.manufacturer_name)]</span></div>
		<div>Model:&nbsp;<span>[:eval RETURNINFO(car.name)]</span></div>
		<div>Year:&nbsp;<span>[:eval RETURNINFO(car.year)]</span></div>
		<div>Level:&nbsp;<span>[:eval RETURNINFO(car.level)]</span></div>
	</div>
	<div class="race-money-opponent-element-vertical-line"></div>
	<div class="race-money-opponent-element-track-image-container backgound-blue">
		<div class="race-money-opponent-element-track-image" style="background-image:url(images/tracks/track_[:track_id].png?t=[:eval TIMESTAMP(id)])">&nbsp;</div>
	</div>
	<div class="race-money-opponent-element-track-info-container">
		<div>Track:&nbsp;<span>[:eval RETURNINFO(track_name)]</span></div>
		<div>Track level:&nbsp;<span>[:eval RETURNINFO(track_level)]</span></div>
		<div>Track length:&nbsp;<span>[:eval RETURNINFO((length/1000))]</span> km.</div>
		<div>Track record:&nbsp;<span>[:eval SECONDSTOTIME(top_time)]</span></div>
		<div>Record owner:&nbsp;<span><a href="#User/data?id=[:top_time_id]" module="PROFILE_VIEW">[:eval RETURNINFO(top_time_name)]</a></span></div>
		<div>Personal record:&nbsp;<span>[:eval SECONDSTOTIME(0)]</span></div>
	</div>
	<div class="race-money-opponent-element-race-info">
		<div class="race-money-opponent-element-label">race winning amount:</div>
		<div class="race-money-opponent-element-amount">SK$ 000</div>
		<div class="race-money-opponent-element-buttons-container">
			<a href="#Race/challengeAccept?challenge_id=[:challenge_id]" class="button car-info-button" module="RACE_MONEY_ACCPET">race</a>
		</div>
	</div>
	<div class="clearfix"></div>
</div>