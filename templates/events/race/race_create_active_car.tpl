<div class="declare-your-own-race-car-element-image-container declare-your-own-race-car-element-image-container-image" style='background-image:url([:eval IMAGESERVER("[\"user_car\","+0.id+",\"car\"]")])'>&nbsp;</div>
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
				<div class="declare-your-own-race-car-element-info-data-name">Top speed <span>[:0.top_speed_values.text]</span> km/h</div>
				<div class="declare-your-own-race-car-element-progress-bar-box ui-corner-all-1px">
					<div class="declare-your-own-race-car-element-progress-bar ui-corner-all-1px" style="width:[:0.top_speed_values.bar]%"></div>
				</div>
			</div>
			<div class="declare-your-own-race-car-element-info-data-box">
				<div class="declare-your-own-race-car-element-info-data-name">Acceleration <span>[:0.acceleration_values.text]</span> s</div>
				<div class="declare-your-own-race-car-element-progress-bar-box ui-corner-all-1px">
					<div class="declare-your-own-race-car-element-progress-bar ui-corner-all-1px" style="width:[:0.acceleration_values.bar]%"></div>
				</div>
			</div>
			<div class="declare-your-own-race-car-element-info-data-box">
				<div class="declare-your-own-race-car-element-info-data-name">Braking <span>[:0.stopping_values.text]</span> m</div>
				<div class="declare-your-own-race-car-element-progress-bar-box ui-corner-all-1px">
					<div class="declare-your-own-race-car-element-progress-bar ui-corner-all-1px" style="width:[:0.stopping_values.bar]%"></div>
				</div>
			</div>
			<div class="declare-your-own-race-car-element-info-data-box">
				<div class="declare-your-own-race-car-element-info-data-name">Handling <span>[:0.cornering_values.text]</span> g</div>
				<div class="declare-your-own-race-car-element-progress-bar-box ui-corner-all-1px">
					<div class="declare-your-own-race-car-element-progress-bar ui-corner-all-1px" style="width:[:0.cornering_values.bar]%"></div>
				</div>
			</div>
			<div class="declare-your-own-race-car-element-info-data-box">
				<div class="declare-your-own-race-car-element-info-data-name">Weight <span>[:0.weight_values.text]</span> kg</div>
				<div class="declare-your-own-race-car-element-progress-bar-box ui-corner-all-1px">
					<div class="declare-your-own-race-car-element-progress-bar ui-corner-all-1px" style="width:[:0.weight_values.bar]%"></div>
				</div>
			</div>
			<div class="declare-your-own-race-car-element-info-data-box">
				<div class="declare-your-own-race-car-element-info-data-name">Used <span>[:eval floor((0.wear/100))]</span> %</div>
				<div class="declare-your-own-race-car-element-progress-bar-box ui-corner-all-1px">
					<div class="declare-your-own-race-car-element-progress-bar declare-your-own-race-car-element-progress-used ui-corner-all-1px" style="width:[:eval floor(0.wear/100)]%"></div>
				</div>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
</div>
<div class="clearfix"></div>