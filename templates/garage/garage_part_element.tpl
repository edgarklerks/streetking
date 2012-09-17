<div class="garage-part-element-container backgound-darkgray">
	<!--<div class="garage-part-element-image-container [:when (improvement > 0 & unique == false)]{garage-part-element-image-container-improved}[:when (unique)]{garage-part-element-image-container-unique} black-icons-100 [:when (name == "engine")]{garage-part-element-[:name]-black}[:when (name != "engine")]{garage-part-element-image-container-image}" [:when (name != "engine")]{style="background-image:url(test_store/[:name]/[:name]_[:d3d_model_id].jpg?t=[:eval TIMESTAMP(id)])"}>[:when (name != "engine")]{<div class="garage-part-element-image-zoom element-image-zoom">&nbsp;</div>}</div>-->
	<div class="garage-part-element-image-container [:when (improvement > 0 & unique == false)]{garage-part-element-image-container-improved}[:when (unique)]{garage-part-element-image-container-unique} black-icons-100" style='background-image:url([:eval IMAGESERVER("[\"part\","+id+","+name+"]")])'}><div class="garage-part-element-image-zoom element-image-zoom">&nbsp;</div></div>
	<div class="garage-part-element-data-container">
		<div class="garage-part-element-info-container">
			<div class="garage-part-element-infotext-container">
				<div>Manufacturer:&nbsp;<span>[:when (manufacturer_name != null)]{[:manufacturer_name]}[:when (manufacturer_name == null)]{For all}</span></div>
				<div>Model:&nbsp;<span>[:when (car_model != null)]{[:car_model]}[:when (car_model == null)]{For all}</span></div>
				<div>Type:&nbsp;<span>[:part_modifier]</span></div>
				<div>Price:&nbsp;<span>SK$ [:price]</span></div>
				<div>Level:&nbsp;<span>[:level]</span></div>
				[:when (unique == false)]{
					<div class="garage-part-element-info-data-box-absolute">
						<div class="garage-part-element-info-data-box-name">Improve <span>[:eval floor(improvement/1000)]</span> %</div>
						<div class="garage-part-element-progress-bar-box ui-corner-all-2px">
							<div class="garage-part-element-progress-bar garage-part-element-progress-improve ui-corner-all-1px" style="width:[:eval ((improvement/100000)*100)]%"></div>
						</div>
					</div>
				}
			</div>
			<div class="garage-part-element-vertical-line"></div>
			<div class="garage-part-element-infobar-container">
				<div class="garage-part-element-info-data-box">
					<div class="garage-part-element-info-data-box-name">[:parameter1_name]: <span>+[:parameter1]</span> [:when (parameter1_unit != null)]{[:parameter1_unit]}</div>
					<div class="garage-part-element-progress-bar-box ui-corner-all-1px">
						<div class="garage-part-element-progress-bar ui-corner-all-1px" style="width:[:eval (parameter1/100)*100]%"></div>
					</div>
				</div>
				[:when (parameter2_name)]{
					<div class="garage-part-element-info-data-box">
						<div class="garage-part-element-info-data-box-name">[:parameter2_name]: <span>+[:parameter2]</span> [:when (parameter2_unit != null)]{[:parameter2_unit]}</div>
						<div class="garage-part-element-progress-bar-box ui-corner-all-1px">
							<div class="garage-part-element-progress-bar ui-corner-all-1px" style="width:[:eval (parameter2/100)*100]%"></div>
						</div>
					</div>
				}
				<div class="garage-part-element-info-data-box">
					<div class="garage-part-element-info-data-box-name">Weight <span>+[:weight]</span> kg</div>
					<div class="garage-part-element-progress-bar-box ui-corner-all-1px">
						<div class="garage-part-element-progress-bar ui-corner-all-1px" style="width:[:eval ((weight/100)*100)]%"></div>
					</div>
				</div>
				<div class="garage-part-element-info-data-box-absolute">
					<div class="garage-part-element-info-data-box-name">Used <span>[:eval floor(wear/1000)]</span> %</div>
					<div class="garage-part-element-progress-bar-box ui-corner-all-2px">
						<div class="garage-part-element-progress-bar garage-part-element-progress-used ui-corner-all-1px" style="width:[:eval floor(wear/1000)]%"></div>
					</div>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
		<div class="garage-part-element-buttons-container button-box-wider">
			<a href="#Market/sell?part_instance_id=[:part_instance_id]" class="button" module="GARAGE_PART_SELL">sell<div>&nbsp;</div></a>
			[:when (unique == false & floor(improvement/1000) < 100)]{<a href="#Personnel/task?subject_id=[:part_instance_id]&task=improve_part" class="button cmd-improve" module="GARAGE_TASK">improve<div>&nbsp;</div></a>}
			[:when (wear > 0)]{<a href="#Personnel/task?subject_id=[:part_instance_id]&task=repair_part" class="button cmd-repair" module="GARAGE_TASK">repair<div>&nbsp;</div></a>}
		</div>
	</div>
	<div class="clearfix"></div>
</div>