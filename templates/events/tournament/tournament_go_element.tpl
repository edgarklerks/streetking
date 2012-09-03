<div>
	<div>car_id: [:car_id]</div>
	<div>cost: [:costs]</div>
	<div>name: [:name]</div>
	<div>level from: [:minlevel]</div>
	<div>level to: [:maxlevel]</div>
	<div>players: [:current_players]/[:players]</div>
	<div>time left: <span class="tournament_timer_[:id]"></span></div>
<!--	<div><a href="#Tournament/join?tournament_id=[:id]" class="button" module="TOURNAMENT_GO_SELECT_CAR">select car and join</a></div> -->
	[:when (done == false)]{
		[:when (joined == false)]{<div><a href="#Tournament/join?tournament_id=[:id]" class="button" module="TOURNAMENT_GO_SELECT_CAR">select car and join</a></div>}
		[:when (joined == true)]{<div><a href="#Tournament/cancel?tournament_id=[:id]" class="button" module="TOURNAMENT_GO_CANCEL">cancel</a></div>}
	}
	[:when (done == true)]{
		<div><a href="#Tournament/result?tournament_id=[:id]" class="button" module="TOURNAMENT_GO_RESULT">result</a></div>
	}
</div>