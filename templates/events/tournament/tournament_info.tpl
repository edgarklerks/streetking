<div class="tournament-info-container" mtitle="Tournament information">
	<div class="tournament-info-container-box">
		<div class="tournament-info-image-container backgound-blue">
			<div class="tournament-info-image-container-image" style='background-image:url([:eval IMAGESERVER("[\"tournament\",\""+requestParams.tournament_id+"\",\"tournament\"]")])'>&nbsp;</div>
		</div>
		<div class="tournament-info-awards-container">
			<div class="tournament-info-awards-title">Tournament awards</div>
			<div class="tournament-info-awards-content">
				[:repeat data:positions as:pos] {
					<div class="tournament-info-awards-element">
						<div><b><span>[:pos.position] position</span></b></div>
						<div class="header-icons header-icons-respect tournament-info-awards-respect">[:pos.exp_min]-[:pos.exp_max]</div>
						<div class="header-icons header-icons-money tournament-info-awards-money">[:pos.money_min]-[:pos.money_max]</div>
					</div>
					<div class="clearfix"></div>
				}
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="tournament-info-container-players">
		<div class="tournament-info-players-title">Registered players in the tournament</div>
		<div class="tournament-info-players-content inner-scroll-box" id="tournament_players">
			
		</div>
	</div>
</div>