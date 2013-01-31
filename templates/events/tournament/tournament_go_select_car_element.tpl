<div class="tournament-car-element-container backgound-darkgray">
	<!--<div class="tournament-car-element-image-container tournament-car-element-image-container-image" style="background-image:url(test_store/car_[:id].jpg?t=[:eval TIMESTAMP(id)])">&nbsp;</div>-->
	<div class="tournament-car-element-image-container tournament-car-element-image-container-image"  style='background-image:url([:eval IMAGESERVER("[\"user_car\","+id+",\"car\"]")])'>&nbsp;</div>
	<div class="tournament-car-element-data-container">
		<div class="tournament-car-element-info-container">
			<div class="tournament-car-element-infotext-container">
				<div>Manufacturer:&nbsp;<span>[:manufacturer_name]</span></div>
				<div>Model:&nbsp;<span>[:name]</span></div>
				<div>Year:&nbsp;<span>[:year]</span></div>
				<div>Level:&nbsp;<span>[:level]</span></div>
				<div class="part-element-info-data-box-absolute">
					<a href="#Tournament/join?tournament_id=[:requestParams.tournament_id]&car_instance_id=[:id]" class="button car-info-button" module="TOURNAMENT_GO_JOIN">join</a>
				</div>
			</div>
			<div class="tournament-car-element-vertical-line"></div>
			<div class="tournament-car-element-infobar-container">
				<div class="tournament-car-element-info-data-box">
					<div class="tournament-car-element-info-data-name">Top speed <span>[:top_speed_values.text]</span> km/h</div>
					<div class="tournament-car-element-progress-bar-box ui-corner-all-1px">
						<div class="tournament-car-element-progress-bar ui-corner-all-1px" style="width:[:top_speed_values.bar]%"></div>
					</div>
				</div>
				<div class="tournament-car-element-info-data-box">
					<div class="tournament-car-element-info-data-name">Acceleration <span>[:acceleration_values.text]</span> s</div>
					<div class="tournament-car-element-progress-bar-box ui-corner-all-1px">
						<div class="tournament-car-element-progress-bar ui-corner-all-1px" style="width:[:acceleration_values.bar]%"></div>
					</div>
				</div>
				<div class="tournament-car-element-info-data-box">
					<div class="tournament-car-element-info-data-name">Braking <span>[:stopping_values.text]</span> m</div>
					<div class="tournament-car-element-progress-bar-box ui-corner-all-1px">
						<div class="tournament-car-element-progress-bar ui-corner-all-1px" style="width:[:stopping_values.bar]%"></div>
					</div>
				</div>
				<div class="tournament-car-element-info-data-box">
					<div class="tournament-car-element-info-data-name">Handling <span>[:cornering_values.text]</span> g</div>
					<div class="tournament-car-element-progress-bar-box ui-corner-all-1px">
						<div class="tournament-car-element-progress-bar ui-corner-all-1px" style="width:[:cornering_values.bar]%"></div>
					</div>
				</div>
				<div class="tournament-car-element-info-data-box">
					<div class="tournament-car-element-info-data-name">Weight <span>[:weight_values.text]</span> kg</div>
					<div class="tournament-car-element-progress-bar-box ui-corner-all-1px">
						<div class="tournament-car-element-progress-bar ui-corner-all-1px" style="width:[:weight_values.bar]%"></div>
					</div>
				</div>
				<div class="tournament-car-element-info-data-box">
					<div class="tournament-car-element-info-data-name">Used <span>[:eval floor(wear/100)]</span> %</div>
					<div class="tournament-car-element-progress-bar-box ui-corner-all-1px">
						<div class="tournament-car-element-progress-bar tournament-car-element-progress-used ui-corner-all-1px" style="width:[:eval floor(wear/100)]%"></div>
					</div>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>
	<div class="clearfix"></div>
</div>