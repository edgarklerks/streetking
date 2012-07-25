<div class="setup-part-element-container backgound-darkgray">
	<div class="setup-part-element-image-container [:when (improvement > 0 & unique == false)]{setup-part-element-image-container-improved}[:when (unique)]{setup-part-element-image-container-unique} sk-icons-info [:when (name == "engine")]{sk-icons-setup-info-[:name]}[:when (name != "engine")]{setup-part-element-image-container-image}" [:when (name != "engine")]{style="background-image:url(test_store/[:name]/[:name]_[:d3d_model_id].jpg?t=[:eval TIMESTAMP(id)])"}>[:when (name != "engine")]{<div class="setup-part-element-image-zoom element-image-zoom">&nbsp;</div>}</div>
	<div class="setup-part-element-data-container">
		<a href="#Car/part?part_instance_id=[:part_instance_id]" class="button-notext setup-part-button" icon="ui-icon-info" module="GARAGE_CAR_PART_INFO">info</a>
		<a href="#Garage/removePart?part_instance_id=[:part_instance_id]&car_instance_id=[:car_instance_id]" removePart="[:part_type_id]" class="button-notext setup-part-button" icon="ui-icon-trash" module="GARAGE_CAR_PART_REMOVE">remove</a>
	</div>
</div>