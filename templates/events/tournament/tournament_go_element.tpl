<div class="tournament-go-and-race-element-container backgound-darkgray">
	<div class="tournament-go-and-race-element-image-container backgound-blue"><div class="tournament-go-and-race-element-image-container-image " style='background-image:url([:eval IMAGESERVER("[\"tournament\",\""+id+"\",\"tournament\"]")])'>&nbsp;</div></div>
	<div class="tournament-go-and-race-element-vertical-line"></div>
	<div class="tournament-go-and-race-element-data-container">
		<div class="tournament-go-and-race-element-info-container">
			<div>Tournament:&nbsp;<span>[:name]</span></div>
			<div>Location:&nbsp;<span>[:track_id]</span></div>
			<div>Time:&nbsp;<span>[:eval TIMESTAMPTODATE(start_time)]</span> in (<span id="tournament_time_left_[:id]">[:start_time]</span>)</div>
			<div>Amount of money (fee):&nbsp;<span>SK$&nbsp;[:costs]</span></div>
			<div>Level:&nbsp;<span>[:minlevel] - [:maxlevel]</span></div>
			<div>Registered players:&nbsp;<span id="tournament_[:id]">[:current_players]</span> out of <span>[:players]</span></div>
		</div>
		<div class="tournament-go-and-race-element-buttons-container">
			[:when (running == false)]{
				[:when (done == false)]{
					<a href="#Reward/find?id=[:id]&type=tournament" class="button" module="TOURNAMENT_GO_INFO">info</a>
					[:when (current_players < players)] { [:when (joined == false)]{<a href="#Tournament/join?tournament_id=[:id]" class="button" module="TOURNAMENT_GO_SELECT_CAR">select car and join</a>} }
					[:when (joined == true)]{<a href="#Tournament/cancel?tournament_id=[:id]" class="button red-text" module="TOURNAMENT_GO_CANCEL">cancel</a>}
				}
				[:when (done == true)]{
					<a href="#Tournament/idk?tournament_id=[:id]" class="button green-text" module="TOURNAMENT_GO_RESULT">result</a>
				}
			}
			[:when (running == true)]{
				<a href="#Tournament/idk?tournament_id=[:id]" class="button green-text" module="TOURNAMENT_GO_RESULT">running</a>
			}
		</div>
	</div>
</div>


