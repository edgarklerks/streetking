<form id="edit_form" action="personnel/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box">
			<div><label>country_id:</label><input type="text" name="country_id" value="[:0.country_id]"/></div>
			<div><label>gender:</label>[:eval OPTIONTRUEFALSE("[\"gender\",\""+0.gender+"\"]")]</div>
			<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
			<div><label>picture:</label><input type="text" name="picture" value="[:0.picture]"/></div>
			<div><label>price:</label><input type="text" name="price" value="[:0.price]"/></div>
			<div><label>salary:</label><input type="text" name="salary" value="[:0.salary]"/></div>
			<div><label>skill_engineering:</label><input type="text" name="skill_engineering" value="[:0.skill_engineering]"/></div>
			<div><label>skill_repair:</label><input type="text" name="skill_repair" value="[:0.skill_repair]"/></div>
			<div><label>sort:</label><input type="text" name="sort" value="[:0.sort]"/></div>
		</div>
		<div class="edit-element-image-box">
			<div class="edit-element-image-container edit-element-image-part" style='background-image:url(images/personnel/[:0.gender]_[:0.picture].png)'>&nbsp;</div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="edit-element-buttons-container">
		<input type="button" value="cancel" id="cancel" module="BACK">
		<input type="button" value="save" id="save" module="SAVE">
	</div>
</form>