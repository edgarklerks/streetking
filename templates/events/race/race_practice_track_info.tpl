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


<!--
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
-->