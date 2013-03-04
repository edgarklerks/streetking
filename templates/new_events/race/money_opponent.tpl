<div class="race-money-opponent-element-container backgound-darkgray">
	<div class="race-money-opponent-element-car-image-container race-money-opponent-element-car-image" style='background-image:url({{=Config.imageUrl("user_car",sk.car.id,"car")}})'>&nbsp;</div>
	<div class="race-money-opponent-element-user-info-container">
		<div class="race-money-opponent-element-user-container">
			<div class="race-money-opponent-element-user-image-container backgound-blue">
				<div class="race-money-opponent-element-user-image" style="background-image:url({{= sk.picture_small}})">&nbsp;</div>
			</div>
			<div class="race-money-opponent-element-user-info">
				<div>Race by:</div>
				<div><a href="#User/data?id={{=sk.profile.id}}" module="PROFILE_VIEW">{{= sk.profile.nickname }}</a></div>
				<div>Level: {{=sk.profile.level}}</div>
			</div>
			<div class="clearfix"></div>
		</div>
		<div>Manufacturer:&nbsp;<span>{{=sk.car.manufacturer_name}}</span></div>
		<div>Model:&nbsp;<span>{{=sk.car.name}}</span></div>
		<div>Year:&nbsp;<span>{{=sk.car.year}}</span></div>
		<div>Level:&nbsp;<span>{{=sk.car.level}}</span></div>
	</div>
	<div class="race-money-opponent-element-vertical-line"></div>
	<div class="race-money-opponent-element-track-image-container backgound-blue">
		<div class="race-money-opponent-element-track-image" style='background-image:url({{= Config.imageUrl("track",sk.track_id,"track") }})'>&nbsp;</div>
	</div>
	<div class="race-money-opponent-element-track-info-container">
		<div>Track:&nbsp;<span>{{=sk.track_name}}</span></div>
		<div>Track level:&nbsp;<span>{{=sk.track_level}}</span></div>
		<div>Track length:&nbsp;<span>{{= Math.floor(sk.track_length)/1000}}</span> km.</div>
		<div>Track record:&nbsp;<span>{{= timeLeft(sk.top_time) }}</span></div>
		<div>Record owner:&nbsp;
			{{? sk.top_time_exists == true }}
				<span><a href="#User/data?id={{=sk.top_time_account_id}}" module="PROFILE_VIEW">{{=sk.top_time_name}}</a></span>
			{{??}}
				not set
			{{?}}
		</div>
		<div>Personal record:&nbsp;<span>{{= timeLeft(0) }}</span></div>
	</div>
	<div class="race-money-opponent-element-race-info">
		<div class="race-money-opponent-element-label">race winning amount:</div>
		<div class="race-money-opponent-element-amount">SK$ [:amount]</div>
		<div class="race-money-opponent-element-buttons-container">
			{{? skUser.getKey('id') == sk.profile.id }}
				<a href="#Race/challengeWithdraw?challenge_id={{=sk.challenge_id}}" class="button car-info-button red-text" module="EVENTS_RACES_MONEY_CANCEL">cancel</a>
			{{??}}
				<a href="#Race/challengeAccept?challenge_id={{=sk.challenge_id}}" class="button car-info-button" module="EVENTS_RACES_MONEY_ACCEPT">accept</a>
			{{?}}
		</div>
	</div>
	<div class="clearfix"></div>
</div>