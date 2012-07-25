<div class="big-element-container ui-corner-all">
	<div class="big-element-image-container big-element-image-container135 big-element-image-containerw135 ui-corner-left">
		<img src="images/tracks/track_[:track_id].png" alt="" border="0" width="100" height="100" class="big-element-image1515 ui-corner-left" />
	</div>
	<div class="big-element-info-container big-element-info-containerw694 big-element-info-container135">
		<div class="big-element-info-title">[:track_name]</div>
		<div class="big-element-info-box big-element-info-box100">
			<div class="big-element-info-about">
				<div>Track length:&nbsp;<b>[:eval length/1000] km.</b></div>
				<div>Track record:&nbsp;<b>[:eval SECONDSTOTIME(top_time)]</b> by:&nbsp;<a href="#User/data?id=[:top_time_id]" module="PROFILE_VIEW"><b>[:top_time_name]</b></a></div>
				<div>Personal record:&nbsp;<b>[:eval SECONDSTOTIME(0)]</b></div>
			</div>
		</div>
		<div class="big-element-button-box">
			<a href="#Race/training?track_id=[:track_id]" class="button" module="RACE_PRACTICE_SHOW">Practice</a>
		</div>
	</div>
	<div class="crearfix"></div>
</div>