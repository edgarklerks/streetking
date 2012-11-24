<form id="edit_form" action="part_model/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box">
			<div>
				<label>car_id:</label>
				<input type="text" name="car_id" list="car_model" value="[:0.car_id]"/>[:when (0.car_id)]{<a href="#car_model/get?id=[:0.car_id]" class="button" module="CAR_MODEL_EDIT" iconnotext="ui-icon-pencil">edit</a>}
			</div>
			<div><label>d3d_model_id:</label><input type="text" name="d3d_model_id" value="[:0.d3d_model_id]"/></div>
			<div><label>level:</label><input type="text" name="level" value="[:0.level]"/></div>
			<div><label>parameter1:</label><input type="text" name="parameter1" value="[:0.parameter1]"/></div>
			<div><label>parameter1_type_id:</label><input type="text" name="parameter1_type_id" list="parameter" listFillField="id" listShowField="id,name,modifier"  value="[:0.parameter1_type_id]"/></div>
			<div><label>parameter2:</label><input type="text" name="parameter2" value="[:0.parameter2]"/></div>
			<div><label>parameter2_type_id:</label><input type="text" name="parameter2_type_id" list="parameter" listFillField="id" listShowField="id,name,modifier" value="[:0.parameter2_type_id]"/></div>
			<div><label>parameter3:</label><input type="text" name="parameter3" value="[:0.parameter3]"/></div>
			<div><label>parameter3_type_id:</label><input type="text" name="parameter3_type_id" list="parameter" listFillField="id" listShowField="id,name,modifier" value="[:0.parameter3_type_id]"/></div>
			<div><label>part_modifier_id:</label><input type="text" name="part_modifier_id" list="part_modifier" value="[:0.part_modifier_id]"/></div>
			<div><label>part_type_id:</label><input type="text" name="part_type_id" list="part_type" value="[:0.part_type_id]"/></div>
			<div><label>price:</label><input type="text" name="price" value="[:0.price]"/></div>
			<div><label>unique:</label>[:eval OPTIONTRUEFALSE("[\"unique\",\""+0.unique+"\"]")]</div>
			<div><label>weight:</label><input type="text" name="weight" value="[:0.weight]"/></div>
		</div>
		<div class="edit-element-image-box">
			<div class="edit-element-image-container edit-element-image-part" style='background-image:url([:eval IMAGESERVER("[\"part\",\""+0.id+"\",\""+0.part_type_id+"\"]")])'>&nbsp;</div>
			[:when (0.id > 0)]{
				<div class="edit-element-image-preview-box">
					<input id="fileupload" type="file" name="files" data-url="" />
					<div class="clearfix"></div>
				</div>
			}
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="edit-element-buttons-container">
		<input type="button" value="cancel" id="cancel" module="BACK">
		<input type="button" value="save" id="save" module="SAVE">
	</div>
</form>