<form id="edit_form" action="car_instance/put" method="post">
	<div class="error">&nbsp;</div>
<input type="hidden" name="id" value="[:0.id]"/>
<div><label>car_id:</label><input type="text" name="car_id" value="[:0.car_id]"/></div>
<div><label>deleted:</label><input type="text" name="deleted" value="[:0.deleted]"/></div>
<div><label>garage_id:</label><input type="text" name="garage_id" value="[:0.garage_id]"/></div>
<div><label>prototype:</label><input type="text" name="prototype" value="[:0.prototype]"/></div>
<div><label>prototype_available:</label><input type="text" name="prototype_available" value="[:0.prototype_available]"/></div>
<div><label>prototype_name:</label><input type="text" name="prototype_name" value="[:0.prototype_name]"/></div>
	
	<input type="button" value="save" id="save" module="SAVE">
</form>
<div>
	Car part list
	<div id="part_list">loading please wait..</div>
	<div><a class="button" module="CAR_PROTOTYPE_ADD_PART">add</a></div>
</div>
<div>[:0.visual]</div>