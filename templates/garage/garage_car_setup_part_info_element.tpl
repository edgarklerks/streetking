<div class="setup-car-parts-info-element ui-corner-all">
	<div class="setup-part-element-image40x40 ui-corner-all sk-icon-40x40 sk-icon-40x40-[:name]">&nbsp;
		[:when (improvement > 0)]{<div class="part-element-improvement-image ui-corner-all"></div><div class="part-element-improvement-image-border ui-corner-all"></div>}
		[:when (unique)]{<div class="part-element-unique-image ui-corner-all"></div><div class="part-element-unique-image-border ui-corner-all"></div>}
	</div>
	<div class="setup-car-parts-info-element-buttons-box">
		<div class="setup-car-parts-info-element-buttons-box-container">
			<a href="#Car/part?part_instance_id=[:part_instance_id]" class="button-notext setup-part-button" icon="ui-icon-comment" module="GARAGE_CAR_PART_INFO">info</a>
			<a href="#Garage/removePart?part_instance_id=[:part_instance_id]&car_instance_id=[:car_instance_id]" class="button-notext setup-part-button" icon="ui-icon-trash" module="GARAGE_CAR_PART_REMOVE">remove</a>
		</div>
	</div>
	<div class="clearfix"></div>
</div>
