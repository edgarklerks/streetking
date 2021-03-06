<div class="report-element-container backgound-darkgray">
	<div class="report-element-container-title">
		Tournament
	</div>
	<div class="report-element-container-inner">
		<div class="report-element-image-container report-element-image-container-image" style='background-image:url([:eval IMAGESERVER("[\"tournament\","+tournament_id+",\"tournament\"]")])'></div>
		<div class="report-element-data-container">
			<div class="report-element-info-container">
				<div class="report-element-infotext-container">
					<div class="race-money-opponent-element-car-image-container race-money-opponent-element-car-image" style=''>&nbsp;</div>
				</div>
				<div class="report-element-vertical-line"></div>

				<div class="report-element-info-data-box">
					<div class="report-element-info-data-name">id: <span>[:tournament.id]</span></div>
				</div>
				<div class="report-element-info-data-box">
					<div class="report-element-info-data-name">Players: <span>[:tournament.players]</span></div>
				</div>
				<div class="report-element-info-data-box">
					<div class="report-element-info-data-name">Level: <span>[:tournament.minlevel] - [:tournament.maxlevel]</span></div>
				</div>
				<div class="report-element-infobar-container">
					<div><input type="button" value="reward" class="button" reward_id="[:tournament_id]" r_type="tournament"></div>
					<div><a href="#Tournament/idk?tournament_id=[:tournament_id]" class="button" module="TOURNAMENT_GO_RESULT">more</a></div>
				</div>
				<div class="clearfix"></div>
			</div>
			<div class="report-element-additional-info-box">
				<div>Time:&nbsp;<span>[:eval TIMESTAMPTODATE(created)]</span></div>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
</div>