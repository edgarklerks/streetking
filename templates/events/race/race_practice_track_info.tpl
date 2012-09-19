<div class="track-info-box-container corner-box">
	<div id="track-info-box" class="ui-dialog-content track-info-box-content">
		<div class="track-info-time-container">
			<div class="track-info-time-container-left track-info-time-race-timer">00:00:000</div>
			<div class="track-info-time-container-right">
			<a href="#Race/finish?" class="button ui-state-gray buy-button" module="GARAGE_USE_DAIMONDS" icon="ui-icon-diamond">end immediately</a>
			</div>
			<div class="clearfix"></div>
		</div>
		<div class="track-info-track-image"><img src="images/tracks/track_[:track_data.track_id].png?t=[:eval TIMESTAMP(id)]" alt="" border="0" width="330" height="330" /></div>
		<div class="track-info-track-data">
			<div>Track:&nbsp;<span>[:track_data.track_name]</span></div>
			<div>Track length:&nbsp;<span>[:eval track_data.length/1000]</span> km.</div>
			<div>Track record:&nbsp;<span>[:eval SECONDSTOTIME(track_data.top_time)]</span> by:  <a href="#User/data?id=[:track_data.top_time_id]" module="PROFILE_VIEW"><span>[:track_data.top_time_name]</span></a></div>
			<div>Personal record:&nbsp;<span>[:eval SECONDSTOTIME(0)]</span></div>
			<div id="track-info-refresh-race"></div>
		</div>
	</div>
	<div class="dialog-corner dialog-corner-tl dialog-corner-h"></div>
	<div class="dialog-corner dialog-corner-tl dialog-corner-v"></div>
	<div class="dialog-corner dialog-corner-tr dialog-corner-h"></div>
	<div class="dialog-corner dialog-corner-tr dialog-corner-v"></div>
	<div class="dialog-corner dialog-corner-bl dialog-corner-h"></div>
	<div class="dialog-corner dialog-corner-bl dialog-corner-v"></div>
	<div class="dialog-corner dialog-corner-br dialog-corner-h"></div>
	<div class="dialog-corner dialog-corner-br dialog-corner-v"></div>
</div>