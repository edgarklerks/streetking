<form id="edit_form" action="track_time/put" method="post">
	<div class="error">&nbsp;</div>
	<input type="hidden" name="id" value="[:0.id]"/>
	
<div><label>account_id:</label><input type="text" name="account_id" value="[:0.account_id]"/></div>
<div><label>time:</label><input type="text" name="time" value="[:0.time]"/></div>
<div><label>track_id:</label><input type="text" name="track_id" value="[:0.track_id]"/></div>

	<input type="button" value="save" id="save" module="SAVE">
</form>