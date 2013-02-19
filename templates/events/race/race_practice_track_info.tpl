<div class="track-info-box-container">
	<div id="track-info-box" class="track-info-box-content">
		<div class="track-info-time-container">
			<div class="track-info-time-container-left track-info-time-race-timer race-timer">00:00:000</div>
			<div class="track-info-time-container-right">
				<a href="#Race/finish?" class="button ui-state-gray buy-button" module="GARAGE_USE_DAIMONDS" icon="ui-icon-diamond" id="finis_immediately">end immediately</a>
			</div>
			<div class="clearfix"></div>
		</div>
		<div class="track-info-track-image-box">
			<div class="cars-small"></div>
			<div class="track-info-track-image">
				<img src='[:eval IMAGESERVER("[\"track\",\""+track_data.track_id+"\",\"track\"]")]' alt="" border="0" width="330" height="330" />
			</div>
		</div>
		<div class="track-info-track-data">
			<div>Track:&nbsp;<span>[:track_data.track_name]</span></div>
			<div>Track length:&nbsp;<span>[:eval floor(track_data.length)/1000]</span> km.</div>
			<div>Track record:&nbsp;<span>[:eval SECONDSTOTIME(track_data.top_time)]</span> by:  <a href="#User/data?id=[:track_data.top_time_account_id]" module="PROFILE_VIEW"><span>[:track_data.top_time_name]</span></a></div>
			<div>Personal record:&nbsp;<span>[:eval SECONDSTOTIME(0)]</span></div>
			<div id="track-info-refresh-race" class="track-info-track-data-button"></div>
		</div>
	</div>
</div>