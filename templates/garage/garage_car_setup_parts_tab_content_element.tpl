<li class="garage-car-setup-part-element-container backgound-darkgray">
	<div class="garage-car-setup-part-element-inner-container">
		<div class="garage-car-setup-part-element-image-box">
<!--			<div class="garage-car-setup-part-element-image-container [:when (improvement > 0 & unique == false)]{garage-car-setup-part-element-image-container-improved}[:when (unique)]{garage-car-setup-part-element-image-container-unique} black-icons-100 [:when (name == "engine")]{car-info-part-element-[:name]-black}[:when (name != "engine")]{garage-car-setup-part-element-image-container-image}" [:when (name != "engine")]{style="background-image:url(test_store/[:name]/[:name]_[:d3d_model_id].jpg?t=[:eval TIMESTAMP(id)])"}>&nbsp;</div>-->
			<div class="garage-car-setup-part-element-image-container [:when (improvement > 0 & unique == false)]{garage-car-setup-part-element-image-container-improved}[:when (unique)]{garage-car-setup-part-element-image-container-unique} black-icons-100 garage-car-setup-part-element-image-container-image" style='background-image:url([:eval IMAGESERVER("[\"part\","+id+",\""+name+"\"]")])'>&nbsp;</div>			<div class="garage-car-setup-part-element-level">Level:&nbsp;<span>[:level]</span></div>
		</div>
		<div class="garage-car-setup-part-element-data-container">
			<div class="garage-car-setup-part-element-info-container">
				<div class="garage-car-setup-part-element-vertical-line"></div>
				<div class="garage-car-setup-part-element-infobar-container">
					<div class="garage-car-setup-part-element-info-data-box">
						<div class="garage-car-setup-part-element-info-data-box-name">[:parameter1_name]: <span>[:parameter1_values.text]</span> [:when (parameter1_unit != null)]{[:parameter1_unit]}</div>
						<div class="garage-car-setup-part-element-progress-bar-box ui-corner-all-1px">
							<div class="garage-car-setup-part-element-progress-bar ui-corner-all-1px" style='width:[:parameter1_values.bar]%'></div>

							<div class="garage-car-setup-part-element-progress-bar-[:parameter1_bars.cls] ui-corner-all-1px" style='left:[:parameter1_bars.left]%; width:[:parameter1_bars.diff]%'></div>
						</div>
					</div>
					[:when (parameter2_name)]{
						<div class="garage-car-setup-part-element-info-data-box">
							<div class="garage-car-setup-part-element-info-data-box-name">[:parameter2_name]: <span>[:parameter2_values.text]</span> [:when (parameter2_unit != null)]{[:parameter2_unit]}</div>
							<div class="garage-car-setup-part-element-progress-bar-box ui-corner-all-1px">
								<div class="garage-car-setup-part-element-progress-bar ui-corner-all-1px" style="width:[:parameter2_values.bar]%"></div>
								<div class="garage-car-setup-part-element-progress-bar-[:parameter2_bars.cls] ui-corner-all-1px" style='left:[:parameter2_bars.left]%; width:[:parameter2_bars.diff]%'></div>
							</div>
						</div>
					}
					<div class="garage-car-setup-part-element-info-data-box">
						<div class="garage-car-setup-part-element-info-data-box-name">Weight <span>[:weight_values.text]</span> kg</div>
						<div class="garage-car-setup-part-element-progress-bar-box ui-corner-all-1px">
							<div class="garage-car-setup-part-element-progress-bar ui-corner-all-1px" style="width:[:weight_values.bar]%"></div>
						</div>
					</div>
					[:when (unique == false)]{
						<div class="garage-car-setup-part-element-info-data-box">
							<div class="garage-car-setup-part-element-info-data-box-name">Improve <span>[:eval floor(improvement/100)]</span> %</div>
							<div class="garage-car-setup-part-element-progress-bar-box ui-corner-all-1px">
								<div class="garage-car-setup-part-element-progress-bar garage-car-setup-part-element-progress-used ui-corner-all-1px" style="width:[:eval (improvement/100)]%"></div>
							</div>
						</div>
					}
					<div class="garage-car-setup-part-element-info-data-box">
						<div class="garage-car-setup-part-element-info-data-box-name">Used <span>[:eval floor(wear/100)]</span> %</div>
						<div class="garage-car-setup-part-element-progress-bar-box ui-corner-all-1px">
							<div class="garage-car-setup-part-element-progress-bar garage-car-setup-part-element-progress-used ui-corner-all-1px" style="width:[:eval floor(wear/100)]%"></div>
						</div>
					</div>
					<!--
					<div class="garage-car-setup-part-element-info-data-box">
						<div class="garage-car-setup-part-element-info-data-box-name">[:parameter1_name]: <span>+[:parameter1]</span> [:when (parameter1_unit != null)]{[:parameter1_unit]}</div>
						<div class="garage-car-setup-part-element-progress-bar-box ui-corner-all-1px">
							<div class="garage-car-setup-part-element-progress-bar ui-corner-all-1px" style='width:[:parameter1_bars.currBarPerc]%'></div>

							<div class="garage-car-setup-part-element-progress-bar-[:parameter1_bars.cls] ui-corner-all-1px" style='left:[:parameter1_bars.left]%; width:[:parameter1_bars.diff]%'></div>
						</div>
					</div>
					[:when (parameter2_name)]{
						<div class="garage-car-setup-part-element-info-data-box">
							<div class="garage-car-setup-part-element-info-data-box-name">[:parameter2_name]: <span>+[:parameter2]</span> [:when (parameter2_unit != null)]{[:parameter2_unit]}</div>
							<div class="garage-car-setup-part-element-progress-bar-box ui-corner-all-1px">
								<div class="garage-car-setup-part-element-progress-bar ui-corner-all-1px" style="width:[:eval (parameter2/100)*100]%"></div>
							</div>
						</div>
					}
					<div class="garage-car-setup-part-element-info-data-box">
						<div class="garage-car-setup-part-element-info-data-box-name">Weight <span>+[:weight]</span> kg</div>
						<div class="garage-car-setup-part-element-progress-bar-box ui-corner-all-1px">
							<div class="garage-car-setup-part-element-progress-bar ui-corner-all-1px" style="width:[:eval ((weight/100)*100)]%"></div>
						</div>
					</div>
					[:when (unique == false)]{
						<div class="garage-car-setup-part-element-info-data-box">
							<div class="garage-car-setup-part-element-info-data-box-name">Improve <span>[:eval floor(improvement/1000)]</span> %</div>
							<div class="garage-car-setup-part-element-progress-bar-box ui-corner-all-1px">
								<div class="garage-car-setup-part-element-progress-bar garage-car-setup-part-element-progress-used ui-corner-all-1px" style="width:[:eval ((improvement/100000)*100)]%"></div>
							</div>
						</div>
					}
					<div class="garage-car-setup-part-element-info-data-box">
						<div class="garage-car-setup-part-element-info-data-box-name">Used <span>[:eval floor(wear/1000)]</span> %</div>
						<div class="garage-car-setup-part-element-progress-bar-box ui-corner-all-1px">
							<div class="garage-car-setup-part-element-progress-bar garage-car-setup-part-element-progress-used ui-corner-all-1px" style="width:[:eval floor(wear/1000)]%"></div>
						</div>
					</div>
					-->
				</div>
				<div class="clearfix"></div>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="garage-car-setup-part-element-button-box button-box-wider">
		[:when (floor(wear/1000) < 100)]{<a href="#Garage/addPart?part_instance_id=[:part_instance_id]&car_instance_id=[:requestParams.preview_car_instance_id]" changePart="[:part_type_id]" class="button setup-part-button show_info" pid="[:part_instance_id]" module="GARAGE_CAR_PART_ADD">add<div>&nbsp;</div></a>}
		[:when (unique == false)]{<a href="#Personnel/task?subject_id=[:part_instance_id]&task=improve_part" class="button setup-part-button cmd-improve" module="GARAGE_TASK">improve<div>&nbsp;</div></a>}
		[:when (wear > 0)]{<a href="#Personnel/task?subject_id=[:part_instance_id]&task=repair_part" class="button setup-part-button cmd-repair" module="GARAGE_TASK">repair<div>&nbsp;</div></a>}
	</div>
	<div class="clearfix"></div>
</li>