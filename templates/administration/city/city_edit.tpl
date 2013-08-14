<form id="edit_form" action="city/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box-noimage">
			<div><label>continent_id:</label><input type="text" name="continent_id" list="continent" value="[:0.continent_id]"/></div>
			<div><label>data:</label><input type="text" name="data" value="[:0.data]"/></div>
			<div><label>default:</label>[:eval OPTIONTRUEFALSE("[\"default\",\""+0.default+"\"]")]</div>
			<div><label>level:</label><input type="text" name="level" value="[:0.level]"/></div>
			<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="edit-element-buttons-container">
		<input type="button" value="cancel" id="cancel" module="BACK">
		<input type="button" value="save" id="save" module="SAVE">
	</div>
</form>
