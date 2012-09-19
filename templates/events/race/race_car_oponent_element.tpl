<div class="race-car-opponent-element-container backgound-darkgray">
	<div class="race-car-opponent-element-car-image-container race-car-opponent-element-car-image" style='background-image:url([:eval IMAGESERVER("[\"user_car\","+car_instance_id+",\"car\"]")])'>&nbsp;</div>
	<div class="race-car-opponent-element-user-info-container">
		<div class="race-car-opponent-element-user-container">
			<div class="race-car-opponent-element-user-image-container backgound-blue">
				<div class="race-car-opponent-element-user-image" style="background-image:url([:eval RETURNUSERIMAGE(user_photo)])">&nbsp;</div>
			</div>
			<div class="race-car-opponent-element-user-info">
				<div>Race by:</div>
				<div><a href="#User/data?id=[:top_time_id]" module="PROFILE_VIEW">[:eval RETURNINFO(top_time_name)]</a></div>
			</div>
			<div class="clearfix"></div>
		</div>
		<div>Manufacturer:&nbsp;<span>[:eval RETURNINFO(manufacturer_name)]</span></div>
		<div>Model:&nbsp;<span>[:eval RETURNINFO(car_model)]</span></div>
		<div>Year:&nbsp;<span>[:eval RETURNINFO(year)]</span></div>
		<div>Level:&nbsp;<span>[:eval RETURNINFO(level)]</span></div>
	</div>
	<div class="race-car-opponent-element-vertical-line"></div>
	<div class="race-car-opponent-element-track-image-container backgound-blue">
		<div class="race-car-opponent-element-track-image" style="background-image:url(images/tracks/track_[:track_id].png?t=[:eval TIMESTAMP(id)])">&nbsp;</div>
	</div>
	<div class="race-car-opponent-element-track-info-container">
		<div>Track:&nbsp;<span>[:eval RETURNINFO(track_name)]</span></div>
		<div>Track level:&nbsp;<span>[:eval RETURNINFO(track_level)]</span></div>
		<div>Track length:&nbsp;<span>[:eval RETURNINFO((length/1000))]</span> km.</div>
		<div>Track record:&nbsp;<span>[:eval SECONDSTOTIME(top_time)]</span></div>
		<div>Record owner:&nbsp;
			[:when (top_time_exists == true)]{
					<span><a href="#User/data?id=[:top_time_account_id]" module="PROFILE_VIEW">[:top_time_name]</a></span>
			}
			[:when (top_time_exists == false)]{
				not set
			}
		</div>
		<div>Personal record:&nbsp;<span>[:eval SECONDSTOTIME(0)]</span></div>
	</div>
	<div class="race-car-opponent-element-race-info">
		<div class="race-car-opponent-element-label">race winning amount:</div>
		<div class="race-car-opponent-element-amount">
			<div class="race-car-opponent-element-amount-manufacturer">[:eval RETURNINFO(manufacturer_name)]</div>
			<div class="race-car-opponent-element-amount-model">[:eval RETURNINFO(car_model)]</div>
		</div>
		<div class="race-car-opponent-element-buttons-container">
			<a href="#Race/challengeAccept?challenge_id=[:challenge_id]" class="button car-info-button" module="RACE_MONEY_ACCPET">race</a>
		</div>
	</div>
	<div class="clearfix"></div>
</div>