<div class="tournament-go-and-race-element-container backgound-darkgray">
	<div class="tournament-go-and-race-element-image-container backgound-blue"><div class="tournament-go-and-race-element-image-container-image " style="background-image:url(images/no_tournament_image.png)">&nbsp;</div></div>
	<div class="tournament-go-and-race-element-vertical-line"></div>
	<div class="tournament-go-and-race-element-data-container">
		<div class="tournament-go-and-race-element-info-container">
			<div>Tournament:&nbsp;<span>[:name]</span></div>
			<div>Location:&nbsp;<span>[:track_id]</span></div>
			<div>Time:&nbsp;<span>[:eval TIMESTAMPTODATE(start_time)]</span></div>
			<div>Amount of money (fee):&nbsp;<span>SK$&nbsp;[:costs]</span></div>
			<div>Level:&nbsp;<span>[:minlevel] - [:maxlevel]</span></div>
			<div>Registered players:&nbsp;<span id="tournament_[:id]">[:current_players]</span> out of <span>[:players]</span></div>
		</div>
		<div class="tournament-go-and-race-element-buttons-container">
			[:when (running == false)]{
				[:when (done == false)]{
					<a href="#Tournament/info?tournament_id=[:id]" class="button" module="TOURNAMENT_GO_INFO">info</a>
					[:when (joined == false)]{<a href="#Tournament/join?tournament_id=[:id]" class="button" module="TOURNAMENT_GO_SELECT_CAR">select car and join</a>}
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


