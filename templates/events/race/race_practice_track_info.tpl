<div class="practice-track-data-container ui-corner-all">
	<div class="practice-track-data-container-left race-timer">00:00:000 s</div>
	<div class="practice-track-data-container-right">
		<a href="#Race/finish?" class="button ui-state-gray buy-button" module="GARAGE_USE_DAIMONDS" icon="ui-icon-diamond">end immediately</a>
	</div>
</div>
<div class="practice-track-container ui-corner-all">
	<img src="images/tracks/track_[:track_data.track_id].png" alt="" border="0" width="360" height="360" class="ui-corner-all" />
</div>
<div class="big-element-container big-element-containerw100p ui-corner-all">
	<div class="big-element-info-container big-element-info-container80">
		<div class="big-element-info-box big-element-info-box70">
			<div class="big-element-info-aboutf">
				<div>Track:&nbsp;<b>[:track_data.track_name]</b></div>
				<div>Track length:&nbsp;<b>[:eval track_data.length/1000] km.</b></div>
				<div>Track record:&nbsp;<b>[:eval SECONDSTOTIME(track_data.top_time)]</b> by:  <a href="#User/data?id=[:track_data.top_time_id]" module="PROFILE_VIEW"><b>[:track_data.top_time_name]</b></a></div>
				<div>Personal record:&nbsp;<b>[:eval SECONDSTOTIME(0)]</b></div>
			</div>
		</div>
	</div>
	<div class="crearfix"></div>
</div>
