<div class="create-car-element-image-container create-car-element-image-container-image" style="background-image:url(test_store/car_[:0.id].jpg?t=[:eval TIMESTAMP(id)])">&nbsp;</div>
<div class="create-car-element-data-container">
	<div class="create-car-element-info-container">
		<div class="create-car-element-infotext-container">
			<div>Manufacturer:&nbsp;<span>[:0.manufacturer_name]</span></div>
			<div>Model:&nbsp;<span>[:0.name]</span></div>
			<div>Year:&nbsp;<span>[:0.year]</span></div>
			<div>Level:&nbsp;<span>[:0.level]</span></div>
		</div>
		<div class="create-car-element-vertical-line"></div>
		<div class="create-car-element-infobar-container">
			<div class="create-car-element-info-data-box">
				<div class="create-car-element-info-data-name">Top speed <span>[:0.top_speed]</span> km/h</div>
				<div class="create-car-element-progress-bar-box ui-corner-all-1px">
					<div class="create-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.top_speed/100)*100)]%"></div>
				</div>
			</div>
			<div class="create-car-element-info-data-box">
				<div class="create-car-element-info-data-name">Acceleration <span>[:0.acceleration]</span> s</div>
				<div class="create-car-element-progress-bar-box ui-corner-all-1px">
					<div class="create-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.acceleration/100)*100)]%"></div>
				</div>
			</div>
			<div class="create-car-element-info-data-box">
				<div class="create-car-element-info-data-name">Braking <span>[:0.braking]</span></div>
				<div class="create-car-element-progress-bar-box ui-corner-all-1px">
					<div class="create-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.braking/100)*100)]%"></div>
				</div>
			</div>
			<div class="create-car-element-info-data-box">
				<div class="create-car-element-info-data-name">Handling <span>[:0.handling]</span></div>
				<div class="create-car-element-progress-bar-box ui-corner-all-1px">
					<div class="create-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.handling/100)*100)]%"></div>
				</div>
			</div>
			<div class="create-car-element-info-data-box">
				<div class="create-car-element-info-data-name">Weight <span>[:0.weight]</span> kg</div>
				<div class="create-car-element-progress-bar-box ui-corner-all-1px">
					<div class="create-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((0.weight/100)*100)]%"></div>
				</div>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
</div>
<div class="clearfix"></div>