<form id="edit_form" action="part_instance/put" method="post">
	<div class="error">&nbsp;</div>
	<input type="hidden" name="id" value=""/>
	<input type="hidden" name="car_instance_id" value="[:0.id]"/>
	<input type="hidden" name="deleted" value="false"/>
	<input type="hidden" name="account_id" value="0"/>
<!--<div><label>account_id:</label><input type="text" name="account_id" value="[:0.account_id]"/></div>-->
	<div><label>part_id:</label><input type="text" name="part_id" list="market_parts" listFillField="id" listShowField="name,level,parameter1_name,parameter1,parameter2_name,parameter2,part_modifier,car_model" value="[:0.part_id]"/></div>
	
	<input type="button" value="save" id="save" module="SAVE">
</form>
<div>[:0.visual]</div>