<form id="edit_form" action="car_model/put" method="post">
	<div class="error">&nbsp;</div>
	<input type="hidden" name="id" value="[:0.id]"/>
		
<div><label>acceleration:</label><input type="text" name="acceleration" value="[:0.acceleration]"/></div>
<div><label>braking:</label><input type="text" name="braking" value="[:0.braking]"/></div>
<div><label>handling:</label><input type="text" name="handling" value="[:0.handling]"/></div>
<div><label>level:</label><input type="text" name="level" value="[:0.level]"/></div>
<div><label>manufacturer_id:</label><input type="text" name="manufacturer_id" value="[:0.manufacturer_id]"/></div>
<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
<div><label>nos:</label><input type="text" name="nos" value="[:0.nos]"/></div>
<div><label>price:</label><input type="text" name="price" value="[:0.price]"/></div>
<div><label>top_speed:</label><input type="text" name="top_speed" value="[:0.top_speed]"/></div>
<div><label>use_3d:</label><input type="text" name="use_3d" value="[:0.use_3d]"/></div>
<div><label>year:</label><input type="text" name="year" value="[:0.year]"/></div>
	
	<input type="button" value="save" id="save" module="SAVE">
	<input type="button" value="Upload image" module="CAR_SELECT_MODEL_IMAGE">
	
</form>