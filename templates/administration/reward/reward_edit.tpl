<form id="edit_form" action="reward/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box">
				<div><label>experience:</label><input type="text" name="experience" value="[:0.experience]"/></div>
				<div><label>money:</label><input type="text" name="money" value="[:0.money]"/></div>
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