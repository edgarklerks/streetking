<div class="part-element-container backgound-darkgray">
	<!--<div class="part-element-image-container black-icons-100 [:when (name == "engine")]{part-element-[:name]-black}[:when (name != "engine")]{part-element-image-container-image}" [:when (name != "engine")]{style="background-image:url(test_store/[:requestParams.part_type]/[:name]_[:d3d_model_id].jpg?t=[:eval TIMESTAMP(id)])"}>[:when (name != "engine")]{<div class="part-element-image-zoom element-image-zoom">&nbsp;</div>}</div>-->
	<div class="part-element-image-container black-icons-100  part-element-image-container-image" style='background-image:url([:eval IMAGESERVER("[\"part\","+id+",\""+name+"\"]")])'><div class="part-element-image-zoom element-image-zoom">&nbsp;</div></div>
	<div class="part-element-data-container">
		<div class="part-element-info-container">
			<div class="part-element-infotext-container">
				<div>Manufacturer:&nbsp;<span>[:when (manufacturer_name != null)]{[:manufacturer_name]}[:when (manufacturer_name == null)]{For all}</span></div>
				<div>Model:&nbsp;<span>[:when (car_model != null)]{[:car_model]}[:when (car_model == null)]{For all}</span></div>
				<div>Type:&nbsp;<span>[:part_modifier]</span></div>
				<div>Price:&nbsp;<span>SK$ [:price]</span></div>
				<div>Level:&nbsp;<span>[:level]</span></div>
			</div>
			<div class="part-element-vertical-line"></div>
			<div class="part-element-infobar-container">
				<div class="part-element-info-data-box">
					<div class="part-element-info-data-box-name">[:parameter1_name]: <span>+[:eval parameter1]</span> [:when (parameter1_unit != null)]{[:parameter1_unit]}</div>
					<div class="part-element-progress-bar-box ui-corner-all-1px">
						<div class="part-element-progress-bar ui-corner-all-1px" style='width:[:eval PROGRESSBAR("["+parameter1/100+",40,70]")]%'></div>
					</div>
				</div>
				[:when (parameter2_name)]{
					<div class="part-element-info-data-box">
						<div class="part-element-info-data-box-name">[:parameter2_name]: <span>+[:parameter2]</span> [:when (parameter2_unit != null)]{[:parameter2_unit]}</div>
						<div class="part-element-progress-bar-box ui-corner-all-1px">
							<div class="part-element-progress-bar ui-corner-all-1px" style='width:[:eval PROGRESSBAR("["+parameter2/100+",40,70]")]%'></div>
						</div>
					</div>
				}
				<div class="part-element-info-data-box">
					<div class="part-element-info-data-box-name">Weight <span>+[:weight]</span> kg</div>
					<!--
					<div class="part-element-progress-bar-box ui-corner-all-1px">
						<div class="part-element-progress-bar ui-corner-all-1px" style="width:[:eval ((weight/100)*100)]%"></div>
					</div>
					-->
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
		<div class="part-element-buttons-container">
			<a href="#Market/buy?id=[:id]" class="button part-button" module="MARKETPLACE_BUY">buy</a>
		</div>
	</div>
	<div class="clearfix"></div>
</div>