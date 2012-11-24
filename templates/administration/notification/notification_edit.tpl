<form id="edit_form" action="notification/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box">
			<div><label>body:</label><textarea id="body" class="code_html" name="body">[:0.body]</textarea></div>
			<div><label>language:</label><input type="text" name="language" value="[:0.language]"/></div>
			<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
			<div><label>title:</label><input type="text" name="title" value="[:0.title]"/></div>
			<div><label>type:</label><input type="text" name="type" value="[:0.type]"/></div>
		</div>
		<div class="edit-element-image-box">&nbsp;</div>
		<div class="clearfix"></div>
	</div>
	<div class="edit-element-buttons-container">
		<input type="button" value="cancel" id="cancel" module="BACK">
		<input type="button" value="save" id="save" module="SAVE">
	</div>
</form>
