<form id="edit_form" action="part_instance/put" method="post">
	<input type="hidden" name="id" value=""/>
	<input type="hidden" name="car_instance_id" value="[:0.id]"/>
	<input type="hidden" name="deleted" value="false"/>
	<input type="hidden" name="account_id" value="0"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box-noimage">
			<div><label>part_id:</label><input type="text" name="part_id" list="market_parts" listFillField="id" listShowField="name,level,parameter1_name,parameter1,parameter2_name,parameter2,part_modifier,car_model" value="[:0.part_id]"/></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="edit-element-buttons-container">
		<input type="button" value="cancel" id="cancel" module="BACK">
		<input type="button" value="save" id="save" module="SAVE">
	</div>
</form>