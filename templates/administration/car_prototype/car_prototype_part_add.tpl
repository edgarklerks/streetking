<form id="edit_form" action="part_instance/put" method="post">
	<div class="error">&nbsp;</div>
	<input type="text" name="id" value=""/>
	<input type="text" name="car_instance_id" value="[:0.id]"/>
	<input type="text" name="deleted" value="false"/>
	<input type="text" name="account_id" value="0"/>
<!--<div><label>account_id:</label><input type="text" name="account_id" value="[:0.account_id]"/></div>-->
	<div><label>part_id:</label><input type="text" name="part_id" list="part_model" value="[:0.part_id]"/></div>
	
	<input type="button" value="save" id="save" module="SAVE">
</form>
<div>[:0.visual]</div>