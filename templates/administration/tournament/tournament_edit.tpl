<div style="float:left">
	<form id="edit_form" action="tournament/put" method="post">
		<div class="error">&nbsp;</div>
		<input type="hidden" name="id" value="[:0.id]"/>
		
	<div><label>car_id:</label><input type="text" name="car_id" value="[:0.car_id]"/></div>
	<div><label>costs:</label><input type="text" name="costs" value="[:0.costs]"/></div>
	<div><label>done:</label><input type="text" name="done" value="[:0.done]"/></div>
	<div><label>id:</label><input type="text" name="id" value="[:0.id]"/></div>
	<div><label>image:</label><input type="text" name="image" value="[:0.image]"/></div>
	<div><label>maxlevel:</label><input type="text" name="maxlevel" value="[:0.maxlevel]"/></div>
	<div><label>minlevel:</label><input type="text" name="minlevel" value="[:0.minlevel]"/></div>
	<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
	<div><label>players:</label><input type="text" name="players" value="[:0.players]"/></div>
	<div><label>rewards:</label><input type="text" name="rewards" value="[:0.rewards]"/></div>
	<div><label>running:</label><input type="text" name="running" value="[:0.running]"/></div>
	<div><label>start_time:</label><input type="text" id="datepicker" name="start_time" value="[:0.start_time]"/></div>
	<div><label>track_id:</label><input type="text" name="track_id" value="[:0.track_id]"/></div>

		<input type="button" value="save" id="save" module="SAVE">
	</form>
</div>
<div>
	<img src='[:eval IMAGESERVER("[\"tournament\",\""+0.id+"\",\"tournament\"]")]'  style="width:400px; height:250px">
	[:when (0.id > 0)]{
		<input id="fileupload" type="file" name="files" data-url="">
		<div id="selectedImage"></div>
	}
</div>