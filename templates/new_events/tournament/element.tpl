<div>
	<div>
		<div style='background-image:url({{= Config.imageUrl("tournament",sk.id,"tournament")}})'>&nbsp;</div>
	</div>
	<div></div>
	<div>
		<div>
			<div>Tournament:&nbsp;<span>{{=sk.name}}</span></div>
			<div>Location:&nbsp;<span>{{=sk.track_id}}</span></div>
			<div>Time:&nbsp;<span>{{=timeLeft(sk.start_time)}}</span> in (<span id="tournament_time_left_{{=sk.id}}">{{= timeAgo(sk.start_time)}}</span>)</div>
			<div>Amount of money (fee):&nbsp;<span>SK$&nbsp;{{=sk.costs}}</span></div>
			<div>Level:&nbsp;<span>{{=sk.minlevel}} - {{=sk.maxlevel}}</span></div>
			<div>Registered players:&nbsp;<span id="tournament_{{=sk.id}}">{{=sk.current_players}}</span> out of <span>{{=sk.players}}</span></div>
		</div>
		<div>
			{{? sk.running == false }}
				{{? sk.done == false }}
					<a href="#Reward/find?id={{=sk.id}}&type=tournament" class="button" module="EVENTS_TOURNAMENT_INFO">info</a>
					{{? sk.current_players < sk.players }}
						{{? sk.joined == false }}
							<a href="#Tournament/join?tournament_id={{=sk.id}}" class="button" module="EVENTS_TOURNAMENT_SELECT_CAR">select car and join</a>
						{{??}}
							<a href="#Tournament/cancel?tournament_id={{=sk.id}}" class="button red-text" module="EVENTS_TOURNAMENT_CANCEL">cancel</a>
						{{?}}
					{{?}}
				{{??}}
					<a href="#Tournament/idk?tournament_id={{=sk.id}}" class="button green-text" module="EVENTS_TOURNAMENT_{{= sk.tournament_type+''.replace('-','').toUpperCase() }}_RESULT">result</a>
				{{?}}
			{{??}}
				<a href="#Tournament/idk?tournament_id={{=sk.id}}" class="button green-text" module="EVENTS_TOURNAMENT_{{= sk.tournament_type+''.replace('-','').toUpperCase() }}_RESULT">running</a>
			{{?}}
		</div>
	</div>
</div>