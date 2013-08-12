<div>
	{{? skUser.getKey('level') < sk.track_level}}
		locked
	{{?}}
	<div>
		<div style='background-image:url({{= Config.imageUrl("track",sk.track_id,"track") }} )'>&nbsp;</div>
	</div>
	<div>
		<div>
			<div>Track:&nbsp;<span>{{=sk.track_name}}</span></div>
			<div>Track level:&nbsp;<span>{{=sk.track_level}}</span></div>
			<div>Track length:&nbsp;<span>{{= Math.floor(sk.length)/1000 }}</span> km.</div>
			<div>Track record:&nbsp;<span>{{= timeLeft(sk.top_time, true) }}</span></div>
			<div>Record owner:&nbsp;
				{{? sk.top_time_exists == true }}
					<a href="#User/data?id={{=sk.top_time_account_id}}" module="PROFILE_VIEW">{{=sk.top_time_name}}</a>
				{{??}}
					not set
				{{?}}
			</div>
			<div>Personal record:&nbsp;<span>{{= timeLeft(0) }}</span></div>
		</div>
	</div>
	<div>
		<a href="#Race/training?track_id={{=sk.track_id}}" class="button" module="EVENTS_RACES_PRACTICE_DO">Practice</a>
	</div>
	<div class="clearfix"></div>
</div>