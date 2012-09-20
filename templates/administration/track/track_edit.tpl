<div style="float:left">
	<form id="edit_form" action="track/put" method="post">
		<div class="error">&nbsp;</div>
		<input type="hidden" name="id" value="[:0.id]"/>
		
	<div><label>city_id:</label><input type="text" name="city_id" value="[:0.city_id]"/></div>
	<div><label>data:</label><input type="text" name="data" value="[:0.data]"/></div>
	<div><label>length:</label><input type="text" name="length" value="[:0.length]"/></div>
	<div><label>level:</label><input type="text" name="level" value="[:0.level]"/></div>
	<div><label>loop:</label><input type="text" name="loop" value="[:0.loop]"/></div>
	<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
	<div><label>top_time_id:</label><input type="text" name="top_time_id" value="[:0.top_time_id]"/></div>

		<input type="button" value="save" id="save" module="SAVE">
	</form>
</div>
<div>
	<img src='[:eval IMAGESERVER("[\"track\",\""+0.id+"\",\"track\"]")]'  style="width:400px; height:250px">
	<input id="fileupload" type="file" name="files" data-url="">
	<div id="selectedImage"></div>
</div>