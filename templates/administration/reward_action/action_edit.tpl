<form id="edit_form" action="action/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box">
			<div><label>rule_id:</label><input type="text" name="rule_id" value="[:0.rule_id]" list="rule"/></div>
			<div><label>reward_id:</label><input type="text" name="reward_id" value="[:0.reward_id]" list="reward"/></div>
			<div><label>chance:</label><input type="text" name="change" value="[:0.change]"/></div>
			<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
		</div>
		<div class="edit-element-image-box">&nbsp;</div>
		<div class="clearfix"></div>
	</div>
	<div class="edit-element-buttons-container">
		<input type="button" value="cancel" id="cancel" module="BACK">
		<input type="button" value="save" id="save" module="SAVE">
	</div>
</form>
