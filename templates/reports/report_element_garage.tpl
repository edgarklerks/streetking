<div class="report-element-container backgound-darkgray">
	<div class="report-element-container-title">
		[:when (task == "repair_part")]{Part repaired}
		[:when (task == "improve_part")]{Part improved}
	</div>
	<div class="report-element-container-inner">
		<div class="report-element-image-container [:when (improvement > 0 & unique == false)]{report-element-image-container-improved}[:when (unique)]{report-element-image-container-unique} black-icons-100 [:when (part_type == "engine")]{report-element-[:part_type]-black}[:when (part_type != "engine")]{report-element-image-container-image}" [:when (part_type != "engine")]{style="background-image:url(test_store/[:part_type]/[:part_type]_[:d3d_model_id].jpg?t=[:eval TIMESTAMP(id)])"}>[:when (part_type != "engine")]{<div class="report-element-image-zoom element-image-zoom">&nbsp;</div>}</div>
		<div class="report-element-data-container">
			<div class="report-element-info-container">
				<div class="report-element-infotext-container">
					<div>Manufacturer:&nbsp;<span>[:when (car_manufacturer_name != null)]{[:car_manufacturer_name]}[:when (manufacturer_name != null)]{[:manufacturer_name]}[:when (car_manufacturer_name == null & manufacturer_name == null)]{For all}</span></div>
					<div>Model:&nbsp;<span>[:when (car_name != null)]{[:car_name]}[:when (car_model != null)]{[:car_model]}[:when (car_name == null & car_model == null)]{For all}</span></div>
					[:when (part_modifier != null)]{<div>Type:&nbsp;<span>[:part_modifier]</span></div>}
					[:when (car_year != null)]{<div>Year:&nbsp;<span>[:car_year]</span></div>}
					<div>Level:&nbsp;<span>[:when (level != null)]{[:level]}[:when (car_level != null)]{[:car_level]}</span></div>
				</div>
				<div class="report-element-vertical-line"></div>
				<div class="report-element-infobar-container">
				
					[:when (car_top_speed)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Top speed: <span>[:car_top_speed]</span> km/h</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (car_top_speed/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (car_acceleration)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Acceleration: <span>[:car_acceleration]</span> s</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (car_acceleration/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (car_braking)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Braking: <span>[:car_braking]</span></div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (car_braking/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (car_handling)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Handling: <span>[:car_handling]</span></div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (car_handling/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (parameter1_name)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">[:parameter1_name]: <span>+[:parameter1]</span> [:when (parameter1_unit != null)]{[:parameter1_unit]}</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (parameter1/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (parameter2_name)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">[:parameter2_name]: <span>+[:parameter2]</span> [:when (parameter2_unit != null)]{[:parameter2_unit]}</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (parameter2/100)*100]%"></div>
							</div>
						</div>
					}

					<div class="report-element-info-data-box">
						<div class="report-element-info-data-name">Weight <span>[:when (weight)]{[:weight]}[:when (car_weight)]{[:car_weight]}</span> kg</div>
						<div class="report-element-progress-bar-box ui-corner-all-1px">
							<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:when (weight)]{[:eval ((weight/100)*100)]}[:when (car_weight)]{[:eval ((car_weight/100)*100)]}%"></div>
						</div>
					</div>
					[:when (unique == false)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Improve <span>[:eval floor(improvement/1000)]</span> [:when (task == "improve_part")]{<span class="green">(+[:eval floor(improvement_change/1000)])</span>} %</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								[:when (task == "improve_part")]{<div class="garage-part-element-progress-bar garage-part-element-progress-improve ui-corner-all-1px" style="width:[:eval floor((improvement+improvement_change)/1000)]%"></div>}
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval floor(improvement/1000)]%"></div>
							</div>
						</div>
					}
					<div class="report-element-info-data-box">
						<div class="report-element-info-data-name">Used <span>[:eval floor(wear/1000)]</span> [:when (task == "repair_part")]{<span class="green">([:eval floor(wear_change/1000)])</span>} %</div>
						<div class="report-element-progress-bar-box ui-corner-all-1px">
							[:when (task == "repair_part")]{<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval floor(wear/1000)]%"></div>}
							<div class="report-element-progress-bar report-element-progress-used ui-corner-all-1px" style="width:[:eval floor((wear+wear_change)/1000)]%"></div>
						</div>
					</div>
				</div>
				<div class="clearfix"></div>
			</div>
			<div class="report-element-additional-info-box">
				<div>Time:&nbsp;<span>[:eval TIMESTAMP(time)]</span></div>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
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
			</div>
			<div class="small-element-info-data">
				<div class="report-element-info-data-box-container">
					[:when (car_top_speed)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Top speed: <span>[:car_top_speed]</span> km/h</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (car_top_speed/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (car_acceleration)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Acceleration: <span>[:car_acceleration]</span> s</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (car_acceleration/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (car_braking)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Braking: <span>[:car_braking]</span></div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (car_braking/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (car_handling)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Handling: <span>[:car_handling]</span></div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (car_handling/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (parameter1_name)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">[:parameter1_name]: <span>+[:parameter1]</span> [:when (parameter1_unit != null)]{[:parameter1_unit]}</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (parameter1/100)*100]%"></div>
							</div>
						</div>
					}
					[:when (parameter2_name)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">[:parameter2_name]: <span>+[:parameter2]</span> [:when (parameter2_unit != null)]{[:parameter2_unit]}</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval (parameter2/100)*100]%"></div>
							</div>
						</div>
					}

					<div class="report-element-info-data-box">
						<div class="report-element-info-data-name">Weight <span>[:when (weight)]{[:weight]}[:when (car_weight)]{[:car_weight]}</span> kg</div>
						<div class="report-element-progress-bar-box ui-corner-all-1px">
							<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:when (weight)]{[:eval ((weight/100)*100)]}[:when (car_weight)]{[:eval ((car_weight/100)*100)]}%"></div>
						</div>
					</div>
					[:when (unique == false)]{
						<div class="report-element-info-data-box">
							<div class="report-element-info-data-name">Improve <span>[:eval floor(improvement/1000)]</span> [:when (task == "improve_part")]{<span class="green">(+[:eval floor(improvement_change/1000)])</span>} %</div>
							<div class="report-element-progress-bar-box ui-corner-all-1px">
								[:when (task == "improve_part")]{<div class="progress-bar-small-progress ui-corner-all-2px" style="width:[:eval floor((improvement+improvement_change)/1000)]%"></div>}
								<div class="report-element-progress-bar ui-corner-all-1px" style="width:[:eval floor(improvement/1000)]%"></div>
							</div>
						</div>
					}
					<div class="report-element-info-data-box">
						<div class="report-element-info-data-name">Used <span>[:eval floor(wear/1000)]</span> [:when (task == "repair_part")]{<span class="green">([:eval floor(wear_change/1000)])</span>} %</div>
						<div class="report-element-progress-bar-box ui-corner-all-1px">
							[:when (task == "repair_part")]{<div class="progress-bar-small-progress progress-bar-small-userd-progress ui-corner-all-2px" style="width:[:eval floor(wear/1000)]%"></div>}
							<div class="report-element-progress-bar report-element-progress-used ui-corner-all-1px" style="width:[:eval floor((wear+wear_change)/1000)]%"></div>
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
			<div>Time:&nbsp;<b class="timestamp">[:time]</span></div>
		</div>
	</div>
	<div class="crearfix"></div>
</div>
-->