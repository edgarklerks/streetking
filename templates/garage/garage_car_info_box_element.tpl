<div class="info-car-parts-info-element ui-corner-all">
	<div class="info-car-part-element-image40x40 ui-corner-all sk-icon-40x40 sk-icon-40x40-[:name]">&nbsp;
		[:when (improvement > 0)]{<div class="part-element-improvement-image ui-corner-all"></div><div class="part-element-improvement-image-border ui-corner-all"></div>}
		[:when (unique)]{<div class="part-element-unique-image ui-corner-all"></div><div class="part-element-unique-image-border ui-corner-all"></div>}
	</div>
	<div class="info-car-parts-info-element-buttons-box">
		<div class="info-car-parts-info-element-buttons-box-container">
			<a href="#Car/part?part_instance_id=[:part_instance_id]" class="button-notext info-car-part-button" icon="ui-icon-comment">info</a>
		</div>
	</div>
	<div class="clearfix"></div>
	<div class="car-element-info-part-element-box ui-corner-all">
		<div class="car-element-info-part-element-image ui-corner-all sk-icon-70x70 sk-icon-70x70-[:name]">&nbsp;
			[:when (improvement > 0)]{<div class="car-element-info-part-element-improvement-image ui-corner-all"></div><div class="car-element-info-part-element-improvement-image-border ui-corner-all"></div>}
			[:when (unique)]{<div class="car-element-info-part-element-unique-image ui-corner-all"></div><div class="car-element-info-part-element-unique-image-border ui-corner-all"></div>}
		</div>
		<div class="car-element-info-part-element-info-box">
			<div class="car-element-info-part-element-info-about">
				<div>Manufacturer:&nbsp;<b>[:when (manufacturer_name != null)]{[:manufacturer_name]}[:when (manufacturer_name == null)]{For all}</b></div>
				<div>Model:&nbsp;<b>[:when (car_model != null)]{[:car_model]}[:when (car_model == null)]{For all}</b></div>
				<div>Type:&nbsp;<b>[:part_modifier]</b></div>
				<div>Level:&nbsp;<b>[:level]</b></div>
			</div>
			<div class="car-element-info-part-element-info-data">
				<div class="car-element-info-part-element-info-data-box-container">
					<div class="car-element-info-part-element-info-data-box">
						<div class="car-element-info-part-element-info-data-name">[:parameter1_name] <span>+[:parameter1]</span> [:when (parameter1_unit != null)]{([:parameter1_unit])}</div>
						<div class="progress-bar-box-small">
							<div class="progress-bar-small" style="left:-[:eval 100-((parameter1/100)*100)]%"></div>
						</div>
					</div>
					<div class="car-element-info-part-element-info-data-box">
						<div class="car-element-info-part-element-info-data-name">Weight <span>+[:weight]</span> (kg)</div>
						<div class="progress-bar-box-small">
							<div class="progress-bar-small" style="left:-[:eval 100-((weight/100)*100)]%"></div>
						</div>
					</div>
					[:when (unique == false)]{
						<div class="car-element-info-part-element-info-data-box">
							<div class="car-element-info-part-element-info-data-name">Improve <span>[:eval floor(improvement/1000)]</span> (%)</div>
							<div class="progress-bar-box-small">
								<div class="progress-improve-bar-small" style="left:-[:eval 100-((improvement/100000)*100)]%"></div>
							</div>
						</div>
					}
					<div class="car-element-info-part-element-info-data-box">
						<div class="car-element-info-part-element-info-data-name">Used <span>[:eval floor(wear/1000)]</span> (%)</div>
						<div class="progress-bar-box-small">
							<div class="progress-wear-bar-small" style="width:[:eval floor(wear/1000)]%"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="crearfix"></div>
		<a href="#" class="car-element-info-part-element-info-close ui-corner-all"><span class="ui-icon ui-icon-closethick">close</span></a>
	</div>
</div>