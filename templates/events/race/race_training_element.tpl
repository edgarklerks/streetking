<div class="race-traning-element-container backgound-darkgray">
	<div class="race-traning-element-image-container backgound-blue">
		<div class="race-traning-element-image-container-image" style='background-image:url([:eval IMAGESERVER("[\"track\",\""+track_id+"\",\"track\"]")])'>&nbsp;</div>
	</div>
	<div class="race-traning-element-data-container">
		<div class="race-traning-element-info-container">
			<div>Track:&nbsp;<span>[:track_name]</span></div>
			<div>Track level:&nbsp;<span>[:track_level]</span></div>
			<div>Track length:&nbsp;<span>[:eval floor(length)/1000]</span> km.</div>
			<div>Track record:&nbsp;<span>[:eval SECONDSTOTIME(top_time)]</span></div>
			<div>Record owner:&nbsp;
				[:when (top_time_exists == true)]{
					<a href="#User/data?id=[:top_time_account_id]" module="PROFILE_VIEW">[:top_time_name]</a>
				}
				[:when (top_time_exists == false)]{
					not set
				}
			</div>
			<div>Personal record:&nbsp;<span>[:eval SECONDSTOTIME(0)]</span></div>
		</div>
	</div>
	<div class="race-traning-element-buttons-container">
		<a href="#Race/training?track_id=[:track_id]" class="button car-info-button" module="RACE_PRACTICE_SHOW">Practice</a>
	</div>
	<div class="clearfix"></div>
</div>