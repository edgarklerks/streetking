
<div class="small-element-container [:when (improvement > 0 & unique == false)]{small-element-container-improved}[:when (unique)]{small-element-container-unique} ui-corner-all">
	<div class="small-element-image-container [:when (improvement > 0 & unique == false)]{small-element-image-container-improved}[:when (unique)]{small-element-image-container-unique} ui-corner-left">
		[:when (name == "wheel")]{<img src="test_store/[:requestParams.part_type]/[:name]_[:eval RANDOM(104)].jpg?t=[:eval TIMESTAMP(id)]" alt="" border="0" width="140" height="140" class="small-element-part-image ui-corner-left" />}
		[:when (name == "spoiler")]{<img src="test_store/[:requestParams.part_type]/[:name]_[:eval RANDOM(11)].jpg?t=[:eval TIMESTAMP(id)]" alt="" border="0" width="140" height="140" class="small-element-part-image ui-corner-left" />}
		<div class="big-element-image-overlay ui-corner-left">&nbsp;</div>
		[:when (name != "wheel" & name != "spoiler")]{<div class="small-element-image-box sk-icons-100x180-white-tr-75 sk-icons-100x140-[:name] ui-corner-left">&nbsp;</div>}
	</div>
	<div class="small-element-info-container">
		<div class="small-element-info-box">
			<div class="small-element-info-about">
				<div>Manufacturer:&nbsp;<b>[:when (manufacturer_name != null)]{[:manufacturer_name]}[:when (manufacturer_name == null)]{For all}</b></div>
				<div>Model:&nbsp;<b>[:when (car_model != null)]{[:car_model]}[:when (car_model == null)]{For all}</b></div>
				<div>Type:&nbsp;<b>[:part_modifier]</b></div>
				<div>Price:&nbsp;<b class="red">SK$ [:price]</b></div>
				<div>Level:&nbsp;<b>[:level]</b></div>
			</div>
			<div class="small-element-info-data">
				<div class="small-element-info-data-box-container">
					<div class="small-element-info-data-box">
						<div class="small-element-info-data-name">[:parameter1_name]: <span>+[:parameter1]</span> [:when (parameter1_unit != null)]{[:parameter1_unit]}</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (parameter1/100)*100]%"></div>
						</div>
					</div>
					[:when (parameter2_name)]{
						<div class="small-element-info-data-box">
							<div class="small-element-info-data-name">[:parameter2_name]: <span>+[:parameter2]</span> [:when (parameter2_unit != null)]{[:parameter2_unit]}</div>
							<div class="progress-bar-box-small ui-corner-all-2px">
								<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval (parameter2/100)*100]%"></div>
							</div>
						</div>
					}
					<div class="small-element-info-data-box">
						<div class="small-element-info-data-name">Weight <span>+[:weight]</span> kg</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((weight/100)*100)]%"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="small-element-button-box">
			<a href="#Market/buy?id=[:id]" class="button part-button" module="MARKETPLACE_BUY">buy</a>
		</div>
	</div>
	<div class="crearfix"></div>
</div>