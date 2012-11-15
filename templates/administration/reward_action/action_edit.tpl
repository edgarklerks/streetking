<form id="edit_form" action="action/put" method="post">
	<div class="error">&nbsp;</div>
	<input type="hidden" name="id" value="[:0.id]"/>
	<div><label>rule_id:</label><input type="text" name="rule_id" value="[:0.rule_id]" list="rule"/></div>
	<div><label>reward_id:</label><input type="text" name="reward_id" value="[:0.reward_id]" list="reward"/></div>
	<div><label>chance:</label><input type="text" name="change" value="[:0.change]"/></div>
	<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
	
	<input type="button" value="save" id="save" module="SAVE">
</form>