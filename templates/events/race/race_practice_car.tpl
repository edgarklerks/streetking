[:when (race.data.length == 2)]{
	<div class="car-element-container backgound-darkgray">
		<div class="car-element-image-container car-element-image-container-image" style="background-image:url(test_store/car_[:race.data.0.rd_car.id].jpg?t=[:eval TIMESTAMP(id)])">&nbsp;</div>
		<div class="car-element-data-container">
			<div class="car-element-vertical-line"></div>
		</div>
		<div class="car-element-image-container car-element-image-container-image" style="background-image:url(test_store/car_[:race.data.1.rd_car.id].jpg?t=[:eval TIMESTAMP(id)])">&nbsp;</div>
	</div>
	<div class="clearfix"></div>
}
[:when (race.data.length == 1)]{
	<div class="car-element-container backgound-darkgray">
		<div class="car-element-image-container car-element-image-container-image" style="background-image:url(test_store/car_[:race.data.0.rd_car.id].jpg?t=[:eval TIMESTAMP(id)])">&nbsp;</div>
		<div class="car-element-data-container">
			<div class="car-element-info-container">
				<div class="car-element-infotext-container">
					<div>Manufacturer:&nbsp;<span>[:race.data.0.rd_car.manufacturer_name]</span></div>
					<div>Model:&nbsp;<span>[:race.data.0.rd_car.name]</span></div>
					<div>Year:&nbsp;<span>[:race.data.0.rd_car.year]</span></div>
					<div>Level:&nbsp;<span>[:race.data.0.rd_car.level]</span></div>
				</div>
				<div class="car-element-vertical-line"></div>
				<div class="car-element-infobar-container">
					<div class="car-element-info-data-box">
						<div class="car-element-info-data-name">Top speed <span>[:race.data.0.rd_car.top_speed]</span> km/h</div>
						<div class="car-element-progress-bar-box ui-corner-all-1px">
							<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.top_speed/100)*100)]%"></div>
						</div>
					</div>
					<div class="car-element-info-data-box">
						<div class="car-element-info-data-name">Acceleration <span>[:race.data.0.rd_car.acceleration]</span> s</div>
						<div class="car-element-progress-bar-box ui-corner-all-1px">
							<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.acceleration/100)*100)]%"></div>
						</div>
					</div>
					<div class="car-element-info-data-box">
						<div class="car-element-info-data-name">Braking <span>[:race.data.0.rd_car.braking]</span></div>
						<div class="car-element-progress-bar-box ui-corner-all-1px">
							<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.braking/100)*100)]%"></div>
						</div>
					</div>
					<div class="car-element-info-data-box">
						<div class="car-element-info-data-name">Handling <span>[:race.data.0.rd_car.handling]</span></div>
						<div class="car-element-progress-bar-box ui-corner-all-1px">
							<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.handling/100)*100)]%"></div>
						</div>
					</div>
					<div class="car-element-info-data-box">
						<div class="car-element-info-data-name">Weight <span>[:race.data.0.rd_car.weight]</span> kg</div>
						<div class="car-element-progress-bar-box ui-corner-all-1px">
							<div class="car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.weight/100)*100)]%"></div>
						</div>
					</div>
				</div>
				<div class="clearfix"></div>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="clearfix"></div>
}

<!--
	<div class="vertical-element-container ui-corner-all">
	<div class="vertical-element-image-container">
		<img src="test_store/car_[:race.data.0.rd_car.id].jpg?t=[:eval TIMESTAMP(0.id)]" alt="" border="0" width="450" height="244" class="vertical-element-car-image ui-corner-top" />
	</div>
	<div class="vertical-element-info-about">
		<div>Manufacturer:&nbsp;<b>[:race.data.0.rd_car.manufacturer_name]</b></div>
		<div>Model:&nbsp;<b>[:race.data.0.rd_car.name]</b></div>
		<div>Year:&nbsp;<b>[:race.data.0.rd_car.year]</b></div>
		<div>Level:&nbsp;<b>[:race.data.0.rd_car.level]</b></div>
	</div>
	<div class="vertical-element-info-data-box-container">
		<div class="vertical-element-info-data-box">
			<div class="vertical-element-info-data-name">Top speed <span>[:race.data.0.rd_car.top_speed]</span> km/h</div>
			<div class="progress-bar-box-small ui-corner-all-2px">
				<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((0.top_speed/100)*100)]%"></div>
			</div>
		</div>
		<div class="vertical-element-info-data-box">
			<div class="vertical-element-info-data-name">Acceleration <span>[:race.data.0.rd_car.acceleration]</span> s</div>
			<div class="progress-bar-box-small ui-corner-all-2px">
				<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((0.acceleration/100)*100)]%"></div>
			</div>
		</div>
		<div class="vertical-element-info-data-box">
			<div class="vertical-element-info-data-name">Braking <span>[:race.data.0.rd_car.braking]</span></div>
			<div class="progress-bar-box-small ui-corner-all-2px">
				<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((0.braking/100)*100)]%"></div>
			</div>
		</div>
		<div class="vertical-element-info-data-box">
			<div class="vertical-element-info-data-name">Handling <span>[:race.data.0.rd_car.handling]</span></div>
			<div class="progress-bar-box-small ui-corner-all-2px">
				<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((0.handling/100)*100)]%"></div>
			</div>
		</div>
		<div class="vertical-element-info-data-box">
			<div class="vertical-element-info-data-name">Weight <span>[:race.data.0.rd_car.weight]</span> kg</div>
			<div class="progress-bar-box-small ui-corner-all-2px">
				<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((0.weight/100)*100)]%"></div>
			</div>
		</div>
		<div class="small-element-info-data-box">
			<div class="small-element-info-data-name">Used <span>[:eval floor(0.wear/1000)]</span> %</div>
			<div class="progress-bar-box-small ui-corner-all-2px">
				<div class="progress-bar-small progress-bar-info-used240 ui-corner-all-2px" style="width:[:eval floor(0.wear/1000)]%"></div>
			</div>
		</div>
	</div>
	<div class="crearfix"></div>
</div>
-->