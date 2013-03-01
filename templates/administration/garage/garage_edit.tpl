<form id="edit_form" action="garage/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box-noimage">
			<div><label>account_id:</label><input type="text" name="account_id" list="account" listShowField="id,nickname" value="[:0.account_id]"/></div>
			<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="edit-element-buttons-container">
		<input type="button" value="cancel" id="cancel" module="BACK">
		<input type="button" value="save" id="save" module="SAVE">
	</div>
</form>

