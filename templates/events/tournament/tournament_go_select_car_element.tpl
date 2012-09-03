<div class="tournament-car-element-container backgound-darkgray">
	<div class="tournament-car-element-image-container tournament-car-element-image-container-image" style="background-image:url(test_store/car_[:id].jpg?t=[:eval TIMESTAMP(id)])">&nbsp;</div>
	<div class="tournament-car-element-data-container">
		<div class="tournament-car-element-info-container">
			<div class="tournament-car-element-infotext-container">
				<div>Manufacturer:&nbsp;<span>[:manufacturer_name]</span></div>
				<div>Model:&nbsp;<span>[:name]</span></div>
				<div>Year:&nbsp;<span>[:year]</span></div>
				<div>Level:&nbsp;<span>[:level]</span></div>
				<div class="part-element-info-data-box-absolute">
					<a href="#Tournament/join?tournament_id=[:requestParams.tid]&car_instance_id=[:id]" class="button car-info-button" module="TOURNAMENT_GO_JOIN">join</a>
				</div>
			</div>
			<div class="tournament-car-element-vertical-line"></div>
			<div class="tournament-car-element-infobar-container">
				<div class="tournament-car-element-info-data-box">
					<div class="tournament-car-element-info-data-name">Top speed <span>[:eval floor((top_speed/10000))]</span> km/h</div>
					<div class="tournament-car-element-progress-bar-box ui-corner-all-1px">
						<div class="tournament-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((top_speed/10000)*100)]%"></div>
					</div>
				</div>
				<div class="tournament-car-element-info-data-box">
					<div class="tournament-car-element-info-data-name">Acceleration <span>[:eval floor((acceleration/10000))]</span> s</div>
					<div class="tournament-car-element-progress-bar-box ui-corner-all-1px">
						<div class="tournament-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((acceleration/10000)*100)]%"></div>
					</div>
				</div>
				<div class="tournament-car-element-info-data-box">
					<div class="tournament-car-element-info-data-name">Braking <span>[:eval floor((braking/10000))]</span></div>
					<div class="tournament-car-element-progress-bar-box ui-corner-all-1px">
						<div class="tournament-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((braking/10000)*100)]%"></div>
					</div>
				</div>
				<div class="tournament-car-element-info-data-box">
					<div class="tournament-car-element-info-data-name">Handling <span>[:eval floor((handling/10000))]</span></div>
					<div class="tournament-car-element-progress-bar-box ui-corner-all-1px">
						<div class="tournament-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((handling/10000)*100)]%"></div>
					</div>
				</div>
				<div class="tournament-car-element-info-data-box">
					<div class="tournament-car-element-info-data-name">Weight <span>[:eval floor((weight/10000))]</span> kg</div>
					<div class="tournament-car-element-progress-bar-box ui-corner-all-1px">
						<div class="tournament-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((weight/10000)*100)]%"></div>
					</div>
				</div>
				<div class="tournament-car-element-info-data-box">
					<div class="tournament-car-element-info-data-box-name">Used <span>[:eval floor(wear/1000)]</span> %</div>
					<div class="tournament-car-element-progress-bar-box ui-corner-all-1px">
						<div class="tournament-car-element-progress-bar tournament-car-element-progress-used ui-corner-all-1px" style="width:[:eval floor(wear/1000)]%"></div>
					</div>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>
	<div class="clearfix"></div>
</div>