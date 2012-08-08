<form id="edit_form" action="transaction/put" method="post">
	<div class="error">&nbsp;</div>
	<input type="hidden" name="id" value="[:0.id]"/>
	
<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
<div><label>required:</label><input type="text" name="required" value="[:0.required]"/></div>
<div><label>sort:</label><input type="text" name="sort" value="[:0.sort]"/></div>
<div><label>use_3d:</label><input type="text" name="use_3d" value="[:0.use_3d]"/></div>

	<input type="button" value="save" id="save" module="SAVE">
</form>