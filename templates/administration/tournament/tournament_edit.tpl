<form id="edit_form" action="tournament/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<input type="hidden" name="rewards" value="[:0.rewards]"/>
	<input type="hidden" name="image" value="[:0.image]"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box">
			<div><label>car_id:</label><input type="text" name="car_id" list="car_model" value="[:0.car_id]"/></div>
			<div><label>costs:</label><input type="text" name="costs" value="[:0.costs]"/></div>
			<div>
				<label>done:</label>
				<!--<input id="done" type="text" name="done" value="[:0.done]"/>-->
				[:eval OPTIONTRUEFALSE("[\"done\",\""+0.done+"\"]")]
			</div>
			<div><label>maxlevel:</label><input type="text" name="maxlevel" value="[:0.maxlevel]"/></div>
			<div><label>minlevel:</label><input type="text" name="minlevel" value="[:0.minlevel]"/></div>
			<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
			<div><label>players:</label><input type="text" name="players" value="[:0.players]"/></div>
			<div><label>tournament type id:</label><input type="text" name="tournament_type_id" list="tournament_type" value="[:0.tournament_type_id]"/></div>
			<div>
				<label>running:</label>
				<!--<input type="text" id="running" name="running" value="[:0.running]"/>-->
				[:eval OPTIONTRUEFALSE("[\"running\",\""+0.running+"\"]")]
			</div>
			<div><label>start_time:</label><input type="text" id="datepicker" name="start_time" value="[:0.start_time]"/><a href="#" class="button" iconnotext="ui-icon-clock" tabindex="-1" id="calendar">...</a></div>
			<div><label>track_id:</label><input type="text" name="track_id" list="track" value="[:0.track_id]"/></div>
		</div>
		<div class="edit-element-image-box">
			<div class="edit-element-image-container edit-element-image-part" style='background-image:url([:eval IMAGESERVER("[\"tournament\",\""+0.id+"\",\"tournament\"]")])'>&nbsp;</div>
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