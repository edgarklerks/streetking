<form id="edit_form" action="track/put" method="post">
	<div class="error">&nbsp;</div>
	<input type="text" name="id" value="[:0.id]"/>
	
	
	[:repeat data:0 as:data] {
		
		<div><label>data:</label><input type="text" name="data" value="[:0.data]"/></div>
	}
	
<div><label>city_id:</label><input type="text" name="city_id" value="[:0.city_id]"/></div>
<div><label>data:</label><input type="text" name="data" value="[:0.data]"/></div>
<div><label>length:</label><input type="text" name="length" value="[:0.length]"/></div>
<div><label>level:</label><input type="text" name="level" value="[:0.level]"/></div>
<div><label>loop:</label><input type="text" name="loop" value="[:0.loop]"/></div>
<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
<div><label>top_time_id:</label><input type="text" name="top_time_id" value="[:0.top_time_id]"/></div>

	<input type="button" value="save" id="save" module="SAVE">
</form>