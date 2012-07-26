<div class="race-traning-element-container backgound-darkgray">
	<div class="race-traning-element-image-container backgound-blue">
		<div class="race-traning-element-image-container-image" style="background-image:url(images/tracks/track_[:track_id].png?t=[:eval TIMESTAMP(id)])">&nbsp;</div>
	</div>
	<div class="race-traning-element-data-container">
		<div class="race-traning-element-info-container">
			<div>Track:&nbsp;<span>[:track_name]</span></div>
			<div>Track level:&nbsp;<span>[:track_level]</span></div>
			<div>Track length:&nbsp;<span>[:eval length/1000] km.</span></div>
			<div>Track record:&nbsp;<span>[:eval SECONDSTOTIME(top_time)]</span></div>
			<div>Record owner:&nbsp;<a href="#User/data?id=[:top_time_id]" module="PROFILE_VIEW">[:top_time_name]</a></div>
			<div>Personal record:&nbsp;<span>[:eval SECONDSTOTIME(0)]</span></div>
		</div>
		<div class="race-traning-element-buttons-container">
			<a href="#Race/training?track_id=[:track_id]" class="button" module="RACE_PRACTICE_SHOW">Practice</a>
		</div>
	</div>
	<div class="clearfix"></div>
</div>