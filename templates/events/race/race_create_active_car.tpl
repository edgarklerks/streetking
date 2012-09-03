<div class="declare-your-own-race-car-element-image-container declare-your-own-race-car-element-image-container-image" style="background-image:url(test_store/car_[:0.id].jpg?t=[:eval TIMESTAMP(id)])">&nbsp;</div>
<div class="declare-your-own-race-car-element-data-container">
	<div class="declare-your-own-race-car-element-info-container">
		<div class="declare-your-own-race-car-element-infotext-container">
			<div>Manufacturer:&nbsp;<span>[:0.manufacturer_name]</span></div>
			<div>Model:&nbsp;<span>[:0.name]</span></div>
			<div>Year:&nbsp;<span>[:0.year]</span></div>
			<div>Level:&nbsp;<span>[:0.level]</span></div>
		</div>
		<div class="declare-your-own-race-car-element-vertical-line"></div>
		<div class="declare-your-own-race-car-element-infobar-container">
			<div class="declare-your-own-race-car-element-info-data-box">
				<div class="declare-your-own-race-car-element-info-data-name">Top speed <span>[:eval floor((0.top_speed/10000))]</span> km/h</div>
				<div class="declare-your-own-race-car-element-progress-bar-box ui-corner-all-1px">
					<div class="declare-your-own-race-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.top_speed/10000)*100)]%"></div>
				</div>
			</div>
			<div class="declare-your-own-race-car-element-info-data-box">
				<div class="declare-your-own-race-car-element-info-data-name">Acceleration <span>[:eval floor((0.acceleration/10000))]</span> s</div>
				<div class="declare-your-own-race-car-element-progress-bar-box ui-corner-all-1px">
					<div class="declare-your-own-race-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.acceleration/10000)*100)]%"></div>
				</div>
			</div>
			<div class="declare-your-own-race-car-element-info-data-box">
				<div class="declare-your-own-race-car-element-info-data-name">Braking <span>[:eval floor((0.braking/10000))]</span></div>
				<div class="declare-your-own-race-car-element-progress-bar-box ui-corner-all-1px">
					<div class="declare-your-own-race-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.braking/10000)*100)]%"></div>
				</div>
			</div>
			<div class="declare-your-own-race-car-element-info-data-box">
				<div class="declare-your-own-race-car-element-info-data-name">Handling <span>[:eval floor((0.handling/10000))]</span></div>
				<div class="declare-your-own-race-car-element-progress-bar-box ui-corner-all-1px">
					<div class="declare-your-own-race-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.handling/10000)*100)]%"></div>
				</div>
			</div>
			<div class="declare-your-own-race-car-element-info-data-box">
				<div class="declare-your-own-race-car-element-info-data-name">Weight <span>[:eval floor((0.weight/10000))]</span> kg</div>
				<div class="declare-your-own-race-car-element-progress-bar-box ui-corner-all-1px">
					<div class="declare-your-own-race-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.weight/10000)*100)]%"></div>
				</div>
			</div>
			<div class="declare-your-own-race-car-element-info-data-box">
				<div class="declare-your-own-race-car-element-info-data-name">Used <span>[:eval floor((0.wear/1000))]</span> %</div>
				<div class="declare-your-own-race-car-element-progress-bar-box ui-corner-all-1px">
					<div class="declare-your-own-race-car-element-progress-bar ui-corner-all-1px" style="width:[:eval floor(0.wear/1000)]%"></div>
				</div>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
</div>
<div class="clearfix"></div>