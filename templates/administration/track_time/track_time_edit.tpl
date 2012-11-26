<form id="edit_form" action="track_time/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box-noimage">
			<div><label>account_id:</label><input type="text" name="account_id" list="account" listShowField="id,nickname" value="[:0.account_id]"/></div>
			<div><label>time:</label><input type="text" name="time" value="[:0.time]"/></div>
			<div><label>track_id:</label><input type="text" name="track_id" value="[:0.track_id]"/></div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="edit-element-buttons-container">
		<input type="button" value="cancel" id="cancel" module="BACK">
		<input type="button" value="save" id="save" module="SAVE">
	</div>
</form>