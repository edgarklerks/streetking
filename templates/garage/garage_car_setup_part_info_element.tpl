<div class="setup-car-parts-info-element-container [:when (improvement > 0 & unique == false)]{setup-car-parts-info-element-container-improved}[:when (unique)]{setup-car-parts-info-element-container-unique} ui-corner-all">
	<div class="setup-car-parts-info-element-image-container ui-corner-left [:when (improvement > 0 & unique == false)]{setup-car-parts-info-element-image-container-improved}[:when (unique)]{setup-car-parts-info-element-image-container-unique}">
		<div class="setup-car-parts-info-element-image-box ui-corner-left sk-icons-40x40-white-tr-75 sk-icons-40x40-[:name]">&nbsp;</div>
	</div>
	<div class="setup-car-parts-info-element-info-container">
		<div class="setup-car-parts-info-element-buttons-box-container">
			<a href="#Car/part?part_instance_id=[:part_instance_id]" class="button-notext setup-part-button" icon="ui-icon-info" module="GARAGE_CAR_PART_INFO">info</a>
			<a href="#Garage/removePart?part_instance_id=[:part_instance_id]&car_instance_id=[:car_instance_id]" removePart="[:part_type_id]" class="button-notext setup-part-button" icon="ui-icon-trash" module="GARAGE_CAR_PART_REMOVE">remove</a>
		</div>
	</div>
	<div class="crearfix"></div>
</div>