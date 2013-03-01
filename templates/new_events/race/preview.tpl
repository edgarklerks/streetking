<div>
	<!-- left -->
	<div style="float: left; background: green;">
		<!-- race-timer klase reikalinga!!!! -->
		<div class="race-timer">00:01:39</div>
		<div style="position:relative">
			<div class="cars-small"></div>
			<div class="track-info-track-image">
				<img src='{{= Config.imageUrl("track",sk.track_data.track_id,"track") }}' alt="" border="0" width="330" height="330">
			</div>
		</div>
		<div>
			<div>Track:&nbsp;<span>{{=sk.track_data.track_name}}</span></div>
			<div>Track length:&nbsp;<span>{{= Math.floor(sk.track_data.length)/1000 }}</span> km.</div>
			<div>Track record:&nbsp;<span>{{= timeLeft(sk.track_data.top_time, true) }}</span></div>
			<div>Record owner:&nbsp;
				{{? sk.track_data.top_time_exists == true }}
					<a href="#User/data?id={{=sk.track_data.top_time_account_id}}" module="PROFILE_VIEW">{{=sk.track_data.top_time_name}}</a>
				{{??}}
					not set
				{{?}}
			</div>
			<div>Personal record:&nbsp;<span>{{= timeLeft(0) }}</span></div>
			<div id="track-info-refresh-race"></div>
		</div>
	</div>
	
	<!-- right -->
	<div style="float: left; background:red;">
		<div>
			opponents...
		</div>
		<div id="practice-data-box"> sections info</div>
	</div>
	
	<div class="clearfix"></div>

</div>