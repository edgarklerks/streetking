<div class="vertical-element-container ui-corner-all">
	<div class="vertical-element-image-container">
		<img src="test_store/car_[:0.id].jpg?t=[:eval TIMESTAMP(0.id)]" alt="" border="0" width="450" height="244" class="vertical-element-car-image ui-corner-top" />
	</div>
	<div class="vertical-element-info-about">
		<div>Manufacturer:&nbsp;<b>[:0.manufacturer_name]</b></div>
		<div>Model:&nbsp;<b>[:0.name]</b></div>
		<div>Year:&nbsp;<b>[:0.year]</b></div>
		<div>Level:&nbsp;<b>[:0.level]</b></div>
	</div>
	<div class="vertical-element-info-data-box-container">
		<div class="vertical-element-info-data-box">
			<div class="vertical-element-info-data-name">Top speed <span>[:0.top_speed]</span> km/h</div>
			<div class="progress-bar-box-small ui-corner-all-2px">
				<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((0.top_speed/100)*100)]%"></div>
			</div>
		</div>
		<div class="vertical-element-info-data-box">
			<div class="vertical-element-info-data-name">Acceleration <span>[:0.acceleration]</span> s</div>
			<div class="progress-bar-box-small ui-corner-all-2px">
				<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((0.acceleration/100)*100)]%"></div>
			</div>
		</div>
		<div class="vertical-element-info-data-box">
			<div class="vertical-element-info-data-name">Braking <span>[:0.braking]</span></div>
			<div class="progress-bar-box-small ui-corner-all-2px">
				<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((0.braking/100)*100)]%"></div>
			</div>
		</div>
		<div class="vertical-element-info-data-box">
			<div class="vertical-element-info-data-name">Handling <span>[:0.handling]</span></div>
			<div class="progress-bar-box-small ui-corner-all-2px">
				<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((0.handling/100)*100)]%"></div>
			</div>
		</div>
		<div class="vertical-element-info-data-box">
			<div class="vertical-element-info-data-name">Weight <span>[:0.weight]</span> kg</div>
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