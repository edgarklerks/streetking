<div class="garage-part-element-container backgound-darkgray">
	<!--<div class="garage-part-element-image-container [:when (improvement > 0 & unique == false)]{garage-part-element-image-container-improved}[:when (unique)]{garage-part-element-image-container-unique} black-icons-100 [:when (name == "engine")]{garage-part-element-[:name]-black}[:when (name != "engine")]{garage-part-element-image-container-image}" [:when (name != "engine")]{style="background-image:url(test_store/[:name]/[:name]_[:d3d_model_id].jpg?t=[:eval TIMESTAMP(id)])"}>[:when (name != "engine")]{<div class="garage-part-element-image-zoom element-image-zoom">&nbsp;</div>}</div>-->
	<div class="garage-part-element-image-container {{? sk.improvement > 0 && sk.unique == false }}	garage-part-element-image-container-improved {{?}} {{? sk.unique }} garage-part-element-image-container-unique {{?}} black-icons-100 garage-part-element-image-container-image" 	style='background-image:url({{= Config.imageUrl("part",sk.id,sk.name) }})'><div class="garage-part-element-image-zoom element-image-zoom">&nbsp;</div></div>
	<div class="garage-part-element-data-container">
		<div class="garage-part-element-info-container">
			<div class="garage-part-element-infotext-container">
				<div>Manufacturer:&nbsp;
					<span>
						{{? sk.manufacturer_name != null }}
							{{= sk.manufacturer_name }}
						{{?? }}
							For all
						{{?}}
					</span>
				</div>
				<div>Model:&nbsp;
					<span>
						{{? sk.manufacturer_name != null }}
							{{= sk.car_model }}
						{{?? }}
							For all
						{{?}}
					</span>
				</div>
				<div>Type:&nbsp;<span>{{= sk.part_modifier }}</span></div>
				<div>Level:&nbsp;<span>{{= sk.level }}</span></div>
				{{? sk.unique == false }}
					<div class="garage-part-element-info-data-box-absolute">
						<div class="garage-part-element-info-data-box-name">Improve <span>{{= Math.floor(sk.improvement/100) }}</span> %</div>
						<div class="garage-part-element-progress-bar-box ui-corner-all-2px">
							<div class="garage-part-element-progress-bar garage-part-element-progress-improve ui-corner-all-1px" style="width:{{= Math.floor(sk.improvement/100) }}%"></div>
						</div>
					</div>
				{{?}}
			</div>
			<div class="garage-part-element-vertical-line"></div>
			<div class="garage-part-element-infobar-container">
			
				<div class="garage-part-element-info-data-box">
					<div class="garage-part-element-info-data-box-name">{{= sk.parameter1_name }}: <span>{{= sk.parameter1_values.text }}</span> {{? sk.parameter1_unit != null }} {{= sk.parameter1_unit }} {{?}}</div>
					<div class="garage-part-element-progress-bar-box ui-corner-all-1px">
						<div class="garage-part-element-progress-bar ui-corner-all-1px" style="width:{{= sk.parameter1_values.bar }}%"></div>
					</div>
				</div>
				{{? sk.parameter2_name != null }}
					<div class="garage-part-element-info-data-box">
						<div class="garage-part-element-info-data-box-name">{{= sk.parameter2_name }}: <span>{{= sk.parameter2_values.text }}</span> {{? sk.parameter2_unit != null }} {{= sk.parameter2_unit }} {{?}}</div>
						<div class="garage-part-element-progress-bar-box ui-corner-all-1px">
							<div class="garage-part-element-progress-bar ui-corner-all-1px" style="width:{{= sk.parameter2_values.bar }}%"></div>
						</div>
					</div>
				{{?}}
				{{? sk.parameter3_name != null }}
					<div class="garage-part-element-info-data-box">
						<div class="garage-part-element-info-data-box-name">{{= sk.parameter3_name }}: <span>{{= sk.parameter3_values.text }}</span> {{? sk.parameter2_unit != null }} {{= sk.parameter3_unit }} {{?}}</div>
						<div class="garage-part-element-progress-bar-box ui-corner-all-1px">
							<div class="garage-part-element-progress-bar ui-corner-all-1px" style="width:{{= sk.parameter3_values.bar }}%"></div>
						</div>
					</div>
				{{?}}
				<div class="garage-part-element-info-data-box">
					<div class="garage-part-element-info-data-box-name">Weight <span>{{= sk.weight_values.text }}</span> kg</div>
					<div class="garage-part-element-progress-bar-box ui-corner-all-1px">
						<div class="garage-part-element-progress-bar ui-corner-all-1px" style="width:{{= sk.weight_values.bar }}%"></div>
					</div>
				</div>
				<div class="garage-part-element-info-data-box-absolute">
					<div class="garage-part-element-info-data-box-name">Used <span>{{= Math.floor(sk.wear/100) }}</span> %</div>
					<div class="garage-part-element-progress-bar-box ui-corner-all-2px">
						<div class="garage-part-element-progress-bar garage-part-element-progress-used ui-corner-all-1px" style="width:{{= Math.floor(sk.wear/100) }}%"></div>
					</div>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
		<div class="garage-part-element-buttons-container button-box-wider">
			<a href="#Market/sell?part_instance_id={{=sk.part_instance_id}}" class="button" module="GARAGE_PART_SELL">sell<div>&nbsp;</div></a>
			{{? sk.unique == false && Math.floor(sk.improvement/100) <100 }}
			<a href="#Personnel/task?subject_id={{=sk.part_instance_id}}&task=improve_part" class="button cmd-improve" module="GARAGE_TASK">improve<div>&nbsp;</div></a>
			{{?}}
			{{? sk.wear > 0 }} 
				<a href="#Personnel/task?subject_id={{=sk.part_instance_id}}&task=repair_part" class="button cmd-repair" module="GARAGE_TASK">repair<div>&nbsp;</div></a>
			{{?}}
		</div>
	</div>
	<div class="clearfix"></div>
</div>