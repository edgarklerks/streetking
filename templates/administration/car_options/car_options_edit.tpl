<form id="edit_form" action="car_options/put" method="post">
	<div class="error">&nbsp;</div>
	<input type="hidden" name="id" value="[:0.id]"/>
	
<div><label>car_instance_id:</label><input type="text" name="car_instance_id" value="[:0.car_instance_id]"/></div>
<div><label>key:</label><input type="text" name="key" value="[:0.key]"/></div>
<div>
	<label>value:</label>
	<textarea class="code_josn" name="value">[:0.value]</textarea>
</div>

	<input type="button" value="save" id="save" module="SAVE">
</form>