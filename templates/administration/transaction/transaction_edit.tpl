<form id="edit_form" action="transaction/put" method="post">
	<div class="error">&nbsp;</div>
	<input type="hidden" name="id" value="[:0.id]"/>
<div><label>account_id:</label><input type="text" name="account_id" value="[:0.account_id]"/></div>
<div><label>amount:</label><input type="text" name="amount" value="[:0.amount]"/></div>
<div><label>current:</label><input type="text" name="current" value="[:0.current]"/></div>
<div><label>time:</label><input type="text" name="time" value="[:0.time]"/></div>
<div><label>type:</label><input type="text" name="type" value="[:0.type]"/></div>
<div><label>type_id:</label><input type="text" name="type_id" value="[:0.type_id]"/></div>

	<input type="button" value="save" id="save" module="SAVE">
</form>