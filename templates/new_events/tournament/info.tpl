<div>
	<div>
		<div>
			<div style='background-image:url([:eval IMAGESERVER("[\"tournament\",\""+requestParams.tournament_id+"\",\"tournament\"]")])'>&nbsp;</div>
		</div>
		<div>
			<div>Tournament awards</div>
			<div>
				{{ for (var i = 0; i < sk.positions.length; i++) { }}
					<div>
						<div><b><span>{{=sk.positions[i].position}} position</span></b></div>
						<div>{{=sk.positions[i].exp_min}}-{{=sk.positions[i].exp_max}}</div>
						<div>{{=sk.positions[i].money_min}}-{{=sk.positions[i].money_max}}</div>
					</div>
					<div class="clearfix"></div>
				{{}}}
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div>
		<div>Registered players in the tournament</div>
		<div id="tournament_players"></div>
	</div>
</div>