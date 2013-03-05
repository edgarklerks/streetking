<form id="edit_form" action="track/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box">
			<div>
				<label>city_id:</label>
				<input type="text" name="city_id" list="city" value="[:0.city_id]"/>
				<a href="#city/get?id=[:0.city_id]" class="button" module="CITY_EDIT">edit</a>
			</div>
			<div><label>data:</label><input type="text" name="data" value="[:0.data]"/></div>
			<div><label>length:</label><input type="text" name="length" value="[:0.length]"/></div>
			<div><label>level:</label><input type="text" name="level" value="[:0.level]"/></div>
			<div><label>energy_cost:</label><input type="text" name="energy_cost" value="[:0.energy_cost]"/></div>
			<div>
				<label>loop:</label>
				<!--<input type="text" name="loop" value="[:0.loop]"/>-->
				[:eval OPTIONTRUEFALSE("[\"loop\",\""+0.loop+"\"]")]
			</div>
			<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
			<div>
				<label>top_time_id:</label>
				<input type="text" name="top_time_id" value="[:0.top_time_id]"/>
				<a href="#track_time/get?id=[:0.top_time_id]" class="button" module="TRACK_TIME_EDIT">edit</a>
			</div>
		</div>
		<div class="edit-element-image-box">
			<div class="edit-element-image-container edit-element-image-part" style='background-image:url([:eval IMAGESERVER("[\"track\",\""+0.id+"\",\"track\"]")])'>&nbsp;</div>
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