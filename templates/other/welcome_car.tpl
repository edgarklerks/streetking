<div class="welcome-car-element-container">
	<div class="welcome-car-element-title">[:manufacturer_name] [:name]</div>
	<div class="welcome-car-element-box">
		<div class="welcome-car-element-image-container welcome-car-element-image" style='background-image:url([:eval IMAGESERVER("[\"car\","+car_id+",\"car\"]")])'>&nbsp;</div>
		<div class="welcome-car-element-info-box">
			<div class="welcome-car-element-info-data-box">
				<div class="welcome-car-element-info-data-name">Top speed <span>[:top_speed_values.text]</span> km/h</div>
				<div class="welcome-car-element-progress-bar-box ui-corner-all-1px">
					<div class="welcome-car-element-progress-bar ui-corner-all-1px" style='width:[:top_speed_values.bar]%'></div>
				</div>
			</div>
			<div class="welcome-car-element-info-data-box">
				<div class="welcome-car-element-info-data-name">Acceleration <span>[:acceleration_values.text]</span> s</div>
				<div class="welcome-car-element-progress-bar-box ui-corner-all-1px">
					<div class="welcome-car-element-progress-bar ui-corner-all-1px" style='width:[:acceleration_values.bar]%'></div>
				</div>
			</div>
			<div class="welcome-car-element-info-data-box">
				<div class="welcome-car-element-info-data-name">Braking <span>[:stopping_values.text]</span> m</div>
				<div class="welcome-car-element-progress-bar-box ui-corner-all-1px">
					<div class="welcome-car-element-progress-bar ui-corner-all-1px" style='width:[:stopping_values.bar]%'></div>
				</div>
			</div>
			<div class="welcome-car-element-info-data-box">
				<div class="welcome-car-element-info-data-name">Handling <span>[:cornering_values.text]</span> g</div>
				<div class="welcome-car-element-progress-bar-box ui-corner-all-1px">
					<div class="welcome-car-element-progress-bar ui-corner-all-1px" style='width:[:cornering_values.bar]%'></div>
				</div>
			</div>
			<div class="welcome-car-element-info-data-box">
				<div class="welcome-car-element-info-data-name">Weight <span>[:eval floor(wear/100)]</span> kg</div>
			</div>
		</div>
		<div class="welcome-car-element-buttons-box">
			<a href="#User/claimFreeCar?id=[:id]" class="button" module="CHOOSE_THIS_CAR">choose this car</a>
		</div>
	</div>
</div>