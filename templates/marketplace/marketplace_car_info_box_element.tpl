<div class="car-info-part-element-icon backgound-blue">
	<div class="car-info-part-element-icon-box sk-icons-info sk-icons-info-[:name] [:when (improvement > 0 & unique == false)]{car-info-part-element-icon-box-improved}[:when (unique)]{car-info-part-element-icon-box-unique}">&nbsp;</div>
	<div class="car-info-part-element-container backgound-transparent">
		<!--<div class="car-info-part-element-image-container [:when (improvement > 0 & unique == false)]{car-info-part-element-image-container-improved}[:when (unique)]{car-info-part-element-image-container-unique} black-icons-100 [:when (name == "engine")]{car-info-part-element-[:name]-black}[:when (name != "engine")]{car-info-part-element-image-container-image}" [:when (name != "engine")]{style="background-image:url(test_store/[:name]/[:name]_[:d3d_model_id].jpg?t=[:eval TIMESTAMP(id)])"}>&nbsp;</div>-->
		<div class="car-info-part-element-image-container [:when (improvement > 0 & unique == false)]{car-info-part-element-image-container-improved}[:when (unique)]{car-info-part-element-image-container-unique} black-icons-100 car-info-part-element-image-container-image" style='background-image:url([:eval IMAGESERVER("[\"part\","+part_id+",\""+name+"\"]")])'>&nbsp;</div>
		<div class="car-info-part-element-data-container">
				<div class="car-info-part-element-infotext-container">
					<div>Manufacturer:&nbsp;<span>[:when (manufacturer_name != null)]{[:manufacturer_name]}[:when (manufacturer_name == null)]{For all}</span></div>
					<div>Model:&nbsp;<span>[:when (car_model != null)]{[:car_model]}[:when (car_model == null)]{For all}</span></div>
					<div>Type:&nbsp;<span>[:part_modifier]</span></div>
					<div>Price:&nbsp;<span>SK$ [:price]</span></div>
					<div>Level:&nbsp;<span>[:level]</span></div>
					[:when (unique == false)]{
						<div class="car-info-part-element-info-data-box-absolute">
							<div class="car-info-part-element-info-data-box-name">Improve <span>[:eval floor(improvement/1000)]</span> %</div>
							<div class="car-info-part-element-progress-bar-box ui-corner-all-2px">
								<div class="car-info-part-element-progress-bar car-info-part-element-progress-improve ui-corner-all-1px" style="width:[:eval ((improvement/100000)*100)]%"></div>
							</div>
						</div>
					}
				</div>
				<div class="car-info-part-element-vertical-line"></div>
				<div class="car-info-part-element-infobar-container">
										<div class="car-info-part-element-info-data-box">
						<div class="car-info-part-element-info-data-box-name">[:parameter1_name]: <span>[:parameter1_values.text]</span> [:when (parameter1_unit != null)]{[:parameter1_unit]}</div>
						<div class="car-info-part-element-progress-bar-box ui-corner-all-1px">
							<div class="car-info-part-element-progress-bar ui-corner-all-1px" style="width:[:parameter1_values.bar]%"></div>
						</div>
					</div>
					[:when (parameter2_name)]{
						<div class="car-info-part-element-info-data-box">
							<div class="car-info-part-element-info-data-box-name">[:parameter2_name]: <span>[:parameter2_values.text]</span> [:when (parameter2_unit != null)]{[:parameter2_unit]}</div>
							<div class="car-info-part-element-progress-bar-box ui-corner-all-1px">
								<div class="car-info-part-element-progress-bar ui-corner-all-1px" style="width:[:parameter2_values.bar]%"></div>
							</div>
						</div>
					}
					<div class="car-info-part-element-info-data-box">
						<div class="car-info-part-element-info-data-box-name">Weight <span>[:weight_values.text]</span> kg</div>
						<div class="car-info-part-element-progress-bar-box ui-corner-all-1px">
							<div class="car-info-part-element-progress-bar ui-corner-all-1px" style="width:[:weight_values.bar]%"></div>
						</div>
					</div>
					<div class="car-info-part-element-info-data-box-absolute">
						<div class="car-info-part-element-info-data-box-name">Used <span>[:eval floor(wear/100)]</span> %</div>
						<div class="car-info-part-element-progress-bar-box ui-corner-all-2px">
							<div class="car-info-part-element-progress-bar car-info-part-element-progress-used ui-corner-all-1px" style="width:[:eval floor(wear/100)]%"></div>
						</div>
					</div>

					<!--
					<div class="car-info-part-element-info-data-box">
						<div class="car-info-part-element-info-data-box-name">[:parameter1_name]: <span>+[:parameter1]</span> [:when (parameter1_unit != null)]{[:parameter1_unit]}</div>
						<div class="car-info-part-element-progress-bar-box ui-corner-all-1px">
							<div class="car-info-part-element-progress-bar ui-corner-all-1px" style="width:[:eval (parameter1/100)*100]%"></div>
						</div>
					</div>
					[:when (parameter2_name)]{
						<div class="car-info-part-element-info-data-box">
							<div class="car-info-part-element-info-data-box-name">[:parameter2_name]: <span>+[:parameter2]</span> [:when (parameter2_unit != null)]{[:parameter2_unit]}</div>
							<div class="car-info-part-element-progress-bar-box ui-corner-all-1px">
								<div class="car-info-part-element-progress-bar ui-corner-all-1px" style="width:[:eval (parameter2/100)*100]%"></div>
							</div>
						</div>
					}
					<div class="car-info-part-element-info-data-box">
						<div class="car-info-part-element-info-data-box-name">Weight <span>+[:weight]</span> kg</div>
						<div class="car-info-part-element-progress-bar-box ui-corner-all-1px">
							<div class="car-info-part-element-progress-bar ui-corner-all-1px" style="width:[:eval ((weight/100)*100)]%"></div>
						</div>
					</div>
					<div class="car-info-part-element-info-data-box-absolute">
						<div class="car-info-part-element-info-data-box-name">Used <span>[:eval floor(wear/1000)]</span> %</div>
						<div class="car-info-part-element-progress-bar-box ui-corner-all-2px">
							<div class="car-info-part-element-progress-bar car-info-part-element-progress-used ui-corner-all-1px" style="width:[:eval floor(wear/1000)]%"></div>
						</div>
					</div>
					-->
				</div>
				<div class="clearfix"></div>
		</div>
		<div class="clearfix"></div>
		<a href="#" class="car-info-part-element-close ui-corner-all ui-dialog-titlebar-close ui-corner-all"><span class="ui-icon ui-icon-closethick">close</span></a>
	</div>
</div>