<div class="garage-car-element-container backgound-darkgray">
	<div class="garage-car-element-image-container garage-car-element-image-container-image" style="background-image:url(test_store/car_[:id].jpg?t=[:eval TIMESTAMP(id)])">&nbsp;</div>
	<div class="garage-car-element-data-container">
		<div class="garage-car-element-info-container">
			<div class="garage-car-element-infotext-container">
				<div>Manufacturer:&nbsp;<span>[:manufacturer_name]</span></div>
				<div>Model:&nbsp;<span>[:name]</span></div>
				<div>Year:&nbsp;<span>[:year]</span></div>
				<div>Level:&nbsp;<span>[:level]</span></div>
				<div class="part-element-info-data-box-absolute">
					<a href="#Garage/car?car_instance_id=[:id]" class="button car-info-button" module="GARAGE_CAR_INFO">info</a>
				</div>
			</div>
			<div class="garage-car-element-vertical-line"></div>
			<div class="garage-car-element-infobar-container">
				<div class="garage-car-element-info-data-box">
					<div class="garage-car-element-info-data-name">Top speed <span>[:eval floor((top_speed/10000))]</span> km/h</div>
					<div class="garage-car-element-progress-bar-box ui-corner-all-1px">
						<div class="garage-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((top_speed/10000)*100)]%"></div>
					</div>
				</div>
				<div class="garage-car-element-info-data-box">
					<div class="garage-car-element-info-data-name">Acceleration <span>[:eval floor((acceleration/10000))]</span> s</div>
					<div class="garage-car-element-progress-bar-box ui-corner-all-1px">
						<div class="garage-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((acceleration/10000)*100)]%"></div>
					</div>
				</div>
				<div class="garage-car-element-info-data-box">
					<div class="garage-car-element-info-data-name">Braking <span>[:eval floor((braking/10000))]</span></div>
					<div class="garage-car-element-progress-bar-box ui-corner-all-1px">
						<div class="garage-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((braking/10000)*100)]%"></div>
					</div>
				</div>
				<div class="garage-car-element-info-data-box">
					<div class="garage-car-element-info-data-name">Handling <span>[:eval floor((handling/10000))]</span></div>
					<div class="garage-car-element-progress-bar-box ui-corner-all-1px">
						<div class="garage-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((handling/10000)*100)]%"></div>
					</div>
				</div>
				<div class="garage-car-element-info-data-box">
					<div class="garage-car-element-info-data-name">Weight <span>[:eval floor((weight/10000))]</span> kg</div>
					<div class="garage-car-element-progress-bar-box ui-corner-all-1px">
						<div class="garage-car-element-progress-bar ui-corner-all-1px" style="width:[:eval ((weight/10000)*100)]%"></div>
					</div>
				</div>
				<div class="garage-car-element-info-data-box">
					<div class="garage-car-element-info-data-box-name">Used <span>[:eval floor(wear/1000)]</span> %</div>
					<div class="garage-car-element-progress-bar-box ui-corner-all-1px">
						<div class="garage-car-element-progress-bar garage-car-element-progress-used ui-corner-all-1px" style="width:[:eval floor(wear/1000)]%"></div>
					</div>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
	</div>
	<div class="clearfix"></div>
	<div class="garage-car-element-buttons-container button-box-wider">
		[:when (active == false)]{
			[:when (ready == true)]{<a href="#Car/activate?id=[:id]" class="button car-button" module="GARAGE_CAR_SET_ACTIVE">set active<div>&nbsp;</div></a>}
			[:when (ready == false)]{<a href="#Garage/carReady?id=[:id]" class="button car-button" module="GARAGE_CAR_SET_ACTIVE_FAIL">set active<div>&nbsp;</div></a>}
		}
		<a href="#Garage/car?car_instance_id=[:id]&car_id=[:car_id]" class="button car-button" module="GARAGE_CAR_SETUP">set up<div>&nbsp;</div></a>
		[:when (wear > 0 )]{<a href="#Garage/car?car_instance_id=[:id]" class="button car-button cmd-repair" module="GARAGE_TASK">repair<div>&nbsp;</div></a>}
		[:when (active == false)]{<a href="#Garage/car?car_instance_id=[:id]" class="button car-button" module="GARAGE_CAR_SELL">sell<div>&nbsp;</div></a>}
	</div>
	<div class="clearfix"></div>
</div>
<!--
<div class="small-element-container ui-corner-all">
	<div class="small-element-image-container small-element-image-container183 [:when ((improvement > 0 & unique == false) | (improvement_change > 0 & unique == false))]{small-element-image-container-improved}[:when (unique)]{small-element-image-container-unique}">
		<div class="small-element-image-box sk-icons-100x180-white-tr-75 sk-icons-100x180-[:when (part_type != null)]{[:part_type]}[:when (part_type == null)]{body}">&nbsp;</div>
	</div>
	<div class="small-element-info-container small-element-info-container183">
		<div class="small-element-info-title">
			[:when (task == "repair_part")]{Part repaired}
			[:when (task == "improve_part")]{Part improved}
		</div>
		<div class="small-element-info-box small-element-info-box115">
			<div class="small-element-info-about">
				<div>Manufacturer:&nbsp;<b>[:when (car_manufacturer_name != null)]{[:car_manufacturer_name]}[:when (manufacturer_name != null)]{[:manufacturer_name]}[:when (car_manufacturer_name == null & manufacturer_name == null)]{For all}</b></div>
				<div>Model:&nbsp;<b>[:when (car_name != null)]{[:car_name]}[:when (car_model != null)]{[:car_model]}[:when (car_name == null & car_model == null)]{For all}</b></div>
				[:when (part_modifier != null)]{<div>Type:&nbsp;[:part_modifier]</div>}
				[:when (car_year != null)]{<div>Year:&nbsp;[:car_year]</div>}
				<div>Level:&nbsp;[:when (level != null)]{[:level]}[:when (car_level != null)]{[:car_level]}</div>
			</div>
			<div class="small-element-info-data">
				<div class="small-element-info-data-box-container">
					[:when (car_top_speed)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">Top speed: <span>[:car_top_speed]</span> km/h</div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (car_top_speed/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (car_acceleration)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">Acceleration: <span>[:car_acceleration]</span> s</div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (car_acceleration/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (car_braking)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">Braking: <span>[:car_braking]</span></div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (car_braking/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (car_handling)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">Handling: <span>[:car_handling]</span></div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (car_handling/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (parameter1_name)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">[:parameter1_name]: <span>+[:parameter1]</span> [:when (parameter1_unit != null)]{[:parameter1_unit]}</div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (parameter1/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (parameter2_name)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">[:parameter2_name]: <span>+[:parameter2]</span> [:when (parameter2_unit != null)]{[:parameter2_unit]}</div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (parameter2/100)*100]%"></div>
							</div>
						</div>
					}

					<div class="small-element-info-data-box">
						<div class="small-element-info-data-name">Weight <span>[:when (weight)]{[:weight]}[:when (car_weight)]{[:car_weight]}</span> kg</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:when (weight)]{[:eval ((weight/100)*100)]}[:when (car_weight)]{[:eval ((car_weight/100)*100)]}%"></div>
						</div>
					</div>
					[:when (unique == false)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">Improve <span>[:eval floor(improvement/1000)]</span> [:when (task == "improve_part")]{<b class="green">(+[:eval floor(improvement_change/1000)])</b>} %</div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								[:when (task == "improve_part")]{<div class="progress-bar-small-progress ui-corner-all-2px" style="width:[:eval floor((improvement+improvement_change)/1000)]%"></div>}
								<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval floor(improvement/1000)]%"></div>
							</div>
						</div>
					}
					<div class="small-element-info-data-box">
						<div class="small-element-info-data-name">Used <span>[:eval floor(wear/1000)]</span> [:when (task == "repair_part")]{<b class="green">([:eval floor(wear_change/1000)])</b>} %</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							[:when (task == "repair_part")]{<div class="progress-bar-small-progress progress-bar-small-userd-progress ui-corner-all-2px" style="width:[:eval floor(wear/1000)]%"></div>}
							<div class="progress-bar-small progress-bar-small-used ui-corner-all-2px" style="width:[:eval floor((wear+wear_change)/1000)]%"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="small-element-info-data"></div>
		</div>
		<div class="small-element-info-additional-box">
			<div class="small-element-info-additional-left-box">
			</div>
			<div class="small-element-info-additional-right-box">
			</div>
		</div>
		<div class="small-element-additional-info-box">
			<div>Time:&nbsp;<b class="timestamp">[:time]</b></div>
		</div>
	</div>
	<div class="crearfix"></div>
</div>
-->