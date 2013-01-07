<div class="list-element-container">
<!--
	<div class="list-element-image-container">&nbsp;</div>
-->
	<div class="list-element-image-container list-element-image-part" style='background-image:url([:eval IMAGESERVER("[\"part\",\""+id+"\",\""+part_type_id+"\"]")])'>&nbsp;</div>
	<div class="list-element-data-container">
		<div><label class="list-element-data-label">id:</label><span>[:id]</span></div>
		<div><label class="list-element-data-label">car id:</label><span>[:car_id]</span></div>
		<div><label class="list-element-data-label">level:</label><span>[:level]</span></div>
		<div><label class="list-element-data-label">3D model id:</label><span>[:d3d_model_id]</span></div>
		<div><label class="list-element-data-label">price:</label><span>[:price]</span></div>
		<div><label class="list-element-data-label">weight:</label><span>[:weight]</span></div>
		<div><label class="list-element-data-label">modifier id:</label><span>[:part_modifier_id]</span></div>
		<div><label class="list-element-data-label">part type id:</label><span>[:part_type_id]</span></div>
		<div><label class="list-element-data-label">unique:</label><span>[:unique]</span></div>
		<div><label class="list-element-data-label">param 1:</label><span>[:parameter1]&nbsp;<span class="list-element-data-type">(type:&nbsp;[:parameter1_type_id])</span></span></div>
		<div><label class="list-element-data-label">param 2:</label><span>[:parameter2]&nbsp;<span class="list-element-data-type">(type:&nbsp;[:parameter2_type_id])</span></span></div>
		<div><label class="list-element-data-label">param 3:</label><span>[:parameter3]&nbsp;<span class="list-element-data-type">(type:&nbsp;[:parameter3_type_id])</span></span></div>
	</div>
	<div class="list-element-buttons-container">
		<div><a href="#part_model/get?id=[:id]" class="button" module="PART_MODEL_EDIT">edit</a></div>
	</div>
	<div class="clearfix"></div>
</div>
