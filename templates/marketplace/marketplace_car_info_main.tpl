<div class="car-info-box-container" mtitle="[:0.manufacturer_name] [:0.model] [:0.year] at level [:0.level]">
	<!--<div class="car-info-image-container" style="background-image:url(test_store/car_[:0.car_instance_id].jpg?t=[:eval TIMESTAMP(0.car_instance_id)])">-->
	<div class="car-info-image-container" style='background-image:url([:eval IMAGESERVER("user_car")][:0.car_instance_id].jpeg)'>
		<div class="car-info-container backgound-transparent">
			<div class="car-info-data-container">
				<div>Manufacturer:&nbsp;<span>[:0.manufacturer_name]</span></div>
				<div>Model:&nbsp;<span>[:0.model]</span></div>
				<div>Year:&nbsp;<span>[:0.year]</span></div>
				<div>Level:&nbsp;<span>[:0.level]</span></div>
			</div>
			<div class="car-info-parameters-container-right">
				<div class="car-info-data-element-data-box">
					<div class="car-info-data-element-data-name">Top speed <span>[:0.top_speed]</span> km/h</div>
					<div class="car-info-data-element-progress-bar-box ui-corner-all-1px">
						<div class="car-info-data-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.top_speed/100)*100)]%"></div>
					</div>
				</div>
				<div class="car-info-data-element-data-box">
					<div class="car-info-data-element-data-name">Braking <span>[:0.braking]</span></div>
					<div class="car-info-data-element-progress-bar-box ui-corner-all-1px">
						<div class="car-info-data-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.braking/100)*100)]%"></div>
					</div>
				</div>
				<div class="car-info-data-element-data-box">
					<div class="car-info-data-element-data-name">Weight <span>[:0.weight]</span> kg</div>
					<div class="car-info-data-element-progress-bar-box ui-corner-all-1px">
						<div class="car-info-data-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.weight/100)*100)]%"></div>
					</div>
				</div>
			</div>
			<div class="car-info-parameters-container-left">
				<div class="car-info-data-element-data-box">
					<div class="car-info-data-element-data-name">Acceleration <span>[:0.acceleration]</span> s</div>
					<div class="car-info-data-element-progress-bar-box ui-corner-all-1px">
						<div class="car-info-data-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.acceleration/100)*100)]%"></div>
					</div>
				</div>
				<div class="car-info-data-element-data-box">
					<div class="car-info-data-element-data-name">Handling <span>[:0.handling]</span></div>
					<div class="car-info-data-element-progress-bar-box ui-corner-all-1px">
						<div class="car-info-data-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.handling/100)*100)]%"></div>
					</div>
				</div>
				<div class="car-info-data-element-data-box">
					<div class="car-info-data-element-data-name">Used <span>[:eval floor(0.wear/1000)]</span> %</div>
					<div class="car-info-data-element-progress-bar-box ui-corner-all-1px">
						<div class="car-info-data-element-progress-bar car-element-progress-used ui-corner-all-1px" style="width:[:eval floor(0.wear/1000)]%"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="car-info-parts-list-container" class="car-info-parts-list-container"></div>
	<div class="clearfix"></div>
	<div class="buttons-panel">
		<input type="button" value="ok" id="ok">
	</div>
</div>