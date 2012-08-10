<form id="edit_form" action="part_instance/put" method="post">
	<div class="error">&nbsp;</div>
	<input type="hidden" name="id" value="[:0.id]"/>
	
<div><label>account_id:</label><input type="text" name="account_id" value="[:0.account_id]"/></div>
<div><label>car_instance_id:</label><input type="text" name="car_instance_id" value="[:0.car_instance_id]"/></div>
<div><label>deleted:</label><input type="text" name="deleted" value="[:0.deleted]"/></div>
<div><label>garage_id:</label><input type="text" name="garage_id" value="[:0.garage_id]"/></div>
<div><label>improvement:</label><input type="text" name="improvement" value="[:0.improvement]"/></div>
<div><label>part_id:</label><input type="text" name="part_id" value="[:0.part_id]"/></div>
<div><label>wear:</label><input type="text" name="wear" value="[:0.wear]"/></div>
	
	<input type="button" value="save" id="save" module="SAVE">
	<div id="svg"></div>
</form>