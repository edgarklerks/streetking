<form id="edit_form" action="part_type/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box-noimage">
			<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
			<div><label>required:</label>[:eval OPTIONTRUEFALSE("[\"required\",\""+0.required+"\"]")]</div>
			<div><label>sort:</label><input type="text" name="sort" value="[:0.sort]"/></div>
			<div><label>use 3D model name:</label><input type="text" name="use_3d" value="[:0.use_3d]"/></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="edit-element-buttons-container">
		<input type="button" value="cancel" id="cancel" module="BACK">
		<input type="button" value="save" id="save" module="SAVE">
	</div>
</form>