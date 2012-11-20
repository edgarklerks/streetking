<li class="garage-car-showroom-element-container" style="background-image:url([:eval IMAGESERVER("[\"user_car\","+id+",\"car\"]")])">
	<div class="garage-car-showroom-element-info-container corner-box">
		<div class="garage-car-showroom-element-manufacture-box">
			<div class="garage-car-showroom-element-manufacture-logo-box normal" style="background-image:url(images/manufacturers/[:eval REPLACESPACE(manufacturer_name)]_logo.png);"></div>
			<div class="garage-car-showroom-element-manufacture-name-box">
				<div class="garage-car-showroom-element-manufacture-name">[:manufacturer_name]</div>
				<div class="garage-car-showroom-element-model-name">[:name]</div>
			</div>
		</div>
		<div class="garage-car-showroom-element-data-info-box">
			<div class="garage-car-showroom-element-info-data-box">
				<div class="garage-car-showroom-element-info-data-name">Top speed <span>[:top_speed_values.text]</span> <b>km/h</b></div>
				<div class="garage-car-showroom-element-progress-bar-box ui-corner-all-1px">
					<div class="garage-car-showroom-element-progress-bar ui-corner-all-1px" style='width:[:top_speed_values.bar]%'></div>
				</div>
			</div>
			<div class="garage-car-showroom-element-info-data-box">
				<div class="garage-car-showroom-element-info-data-name">Acceleration <span>[:acceleration_values.text]</span> <b>s</b></div>
				<div class="garage-car-showroom-element-progress-bar-box ui-corner-all-1px">
					<div class="garage-car-showroom-element-progress-bar ui-corner-all-1px" style='width:[:acceleration_values.bar]%'></div>
				</div>
			</div>
			<div class="garage-car-showroom-element-info-data-box">
				<div class="garage-car-showroom-element-info-data-name">Braking <span>[:stopping_values.text]</span> <b>m</b></div>
				<div class="garage-car-showroom-element-progress-bar-box ui-corner-all-1px">
					<div class="garage-car-showroom-element-progress-bar ui-corner-all-1px" style='width:[:stopping_values.bar]%'></div>
				</div>
			</div>
			<div class="garage-car-showroom-element-info-data-box">
				<div class="garage-car-showroom-element-info-data-name">Handling <span>[:cornering_values.text]</span> <b>g</b></div>
				<div class="garage-car-showroom-element-progress-bar-box ui-corner-all-1px">
					<div class="garage-car-showroom-element-progress-bar ui-corner-all-1px" style='width:[:cornering_values.bar]%'></div>
				</div>
			</div>
			<div class="garage-car-showroom-element-info-data-box">
				<div class="garage-car-showroom-element-info-data-name">Weight <span>[:weight_values.text]</span> <b>kg</b></div>
				<div class="garage-car-showroom-element-progress-bar-box ui-corner-all-1px">
					<div class="garage-car-showroom-element-progress-bar ui-corner-all-1px" style="width:[:weight_values.bar]%"></div>
				</div>
			</div>

			<div class="garage-car-showroom-element-info-data-box">
				<div class="garage-car-showroom-element-info-data-name">Used <span>[:eval floor(wear/100)]</span> <b>%</b></div>
				<div class="garage-car-showroom-element-progress-bar-box ui-corner-all-1px">
					<div class="garage-car-showroom-element-progress-bar garage-car-showroom-element-progress-bar-used ui-corner-all-1px" style="width:[:eval floor(wear/100)]%"></div>
				</div>
			</div>
		</div>
		<div class="garage-car-showroom-element-buttons-box">
			<div class="garage-car-showroom-element-active-button-container">
				[:when (active == false)]{
					[:when (ready == true)]{<a href="#Car/activate?id=[:id]" class="button width-100p" module="GARAGE_CAR_SET_ACTIVE">set active</a>}
					[:when (ready == false)]{<a href="#Garage/carReady?id=[:id]" class="button width-100p" module="GARAGE_CAR_SET_ACTIVE_FAIL">set active</a>}
				}
			</div>
			<div class="garage-car-showroom-element-action-button-container garage-part-element-buttons-container button-box-wider">
				[:when ((wear > 0 ) & (active == false))]{
					[:when (wear > 0 )]{<a href="#Personnel/task?subject_id=[:id]&task=repair_car" class="button float-left cmd-repair width-47p" module="GARAGE_TASK">repair<div>&nbsp;</div></a>}
					[:when (active == false)]{<a href="#Garage/car?car_instance_id=[:id]" class="button float-right width-47p" module="GARAGE_CAR_SELL">sell<div>&nbsp;</div></a>}
				}
				[:when ((wear > 0 ) & (active == true))]{
					<a href="#Personnel/task?subject_id=[:id]&task=repair_car" class="button cmd-repair width-100p no-icon" module="GARAGE_TASK">repair<div>&nbsp;</div></a>
				}
				[:when ((wear < 1 ) & (active == false))]{
					<a href="#Garage/car?car_instance_id=[:id]" class="button width-100p" module="GARAGE_CAR_SELL">sell<div>&nbsp;</div></a>
				}
			</div>
			<div class="garage-car-showroom-element-info-button-container">
				<a href="#Garage/car?car_instance_id=[:id]&car_id=[:car_id]" class="button width-47p" module="GARAGE_CAR_SETUP">set up</a>
				<a href="#Garage/car?car_instance_id=[:id]" class="button float-right width-47p" module="GARAGE_CAR_INFO">info</a>
			</div>
		</div>
		<div class="dialog-corner dialog-corner-tl dialog-corner-h"></div>
		<div class="dialog-corner dialog-corner-tl dialog-corner-v"></div>
		<div class="dialog-corner dialog-corner-tr dialog-corner-h"></div>
		<div class="dialog-corner dialog-corner-tr dialog-corner-v"></div>
		<div class="dialog-corner dialog-corner-bl dialog-corner-h"></div>
		<div class="dialog-corner dialog-corner-bl dialog-corner-v"></div>
		<div class="dialog-corner dialog-corner-br dialog-corner-h"></div>
		<div class="dialog-corner dialog-corner-br dialog-corner-v"></div>
	</div>
</li>