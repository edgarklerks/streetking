<div class="list-element-container">
	<div class="list-element-image-container list-element-image-part" style='background-image:url([:eval IMAGESERVER("[\"part\",\""+part_id+"\",\""+part_type_id+"\"]")])'>&nbsp;</div>
	<div class="list-element-data-container">
		<div><label class="list-element-data-label">level:</label><span>[:level]</span></div>
		<div><label class="list-element-data-label">name:</label><span>[:name]</span></div>
		<div><label class="list-element-data-label">modifier:</label><span>[:part_modifier]</span></div>
		<div><label class="list-element-data-label">unique:</label><span>[:unique]</span></div>
	</div>
	<div class="list-element-buttons-container">
		<div><a href="#part_instance/get?id=[:part_instance_id]" class="button" module="PART_INSTANCE_EDIT">edit part instance</a><br></div>
		<div><a href="#part_model/get?id=[:part_id]" class="button" module="PART_MODEL_EDIT">edit part model</a><br></div>
		<div><a href="#part_instance/put?id=[:part_instance_id]&part_id=[:part_id]" class="button delete" module="PART_INSTANCE_DELETE">delete</a></div>
	</div>
	<div class="clearfix"></div>
</div>
