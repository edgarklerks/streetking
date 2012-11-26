<form id="edit_form" action="car_options/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box-noimage">
			<div><label>car_instance_id:</label><input type="text" name="car_instance_id" value="[:0.car_instance_id]"/></div>
			<div><label>key:</label><input type="text" name="key" value="[:0.key]"/></div>
			<div>
				<label>value:</label>
				<textarea class="code_josn" name="value">[:0.value]</textarea>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="edit-element-buttons-container">
		<input type="button" value="cancel" id="cancel" module="BACK">
		<input type="button" value="save" id="save" module="SAVE">
	</div>
</form>