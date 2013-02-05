<div class="race-money-opponent-element-container backgound-darkgray">
	<div class="race-money-opponent-element-car-image-container race-money-opponent-element-car-image" style='background-image:url([:eval IMAGESERVER("[\"user_car\","+car.id+",\"car\"]")])'>&nbsp;</div>
	<div class="race-money-opponent-element-user-info-container">
		<div class="race-money-opponent-element-user-container">
			<div class="race-money-opponent-element-user-image-container backgound-blue">
				<div class="race-money-opponent-element-user-image" style="background-image:url([:eval RETURNUSERIMAGE(profile.picture_small)])">&nbsp;</div>
			</div>
			<div class="race-money-opponent-element-user-info">
				<div>Race by:</div>
				<div><a href="#User/data?id=[:profile.id]" module="PROFILE_VIEW">[:eval RETURNINFO(profile.nickname)]</a></div>
				<div>Level: [:eval RETURNINFO(profile.level)]</div>
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
		<div class="race-money-opponent-element-track-image" style='background-image:url([:eval IMAGESERVER("[\"track\",\""+track_id+"\",\"track\"]")])'>&nbsp;</div>
	</div>
	<div class="race-money-opponent-element-track-info-container">
		<div>Track:&nbsp;<span>[:eval RETURNINFO(track_name)]</span></div>
		<div>Track level:&nbsp;<span>[:eval RETURNINFO(track_level)]</span></div>
		<div>Track length:&nbsp;<span>[:eval RETURNINFO((track_length/1000))]</span> km.</div>
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
	<div class="race-money-opponent-element-race-info">
		<div class="race-money-opponent-element-label">race winning amount:</div>
		<div class="race-money-opponent-element-amount">SK$ [:amount]</div>
		<div class="race-money-opponent-element-buttons-container">
			[:when (my_challange == true)]{
				<a href="#Race/challengeWithdraw?challenge_id=[:challenge_id]" class="button car-info-button red-text" module="RACE_MONEY_CANCEL">cancel</a>
			}
			[:when (my_challange == false)]{
				<a href="#Race/challengeAccept?challenge_id=[:challenge_id]" class="button car-info-button" module="RACE_MONEY_ACCPET">accept</a>
			}
		</div>
	</div>
	<div class="clearfix"></div>
</div>