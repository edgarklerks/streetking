<form id="edit_form" action="notification/put" method="post">
	<div class="error">&nbsp;</div>
	<input type="hidden" name="id" value="[:0.id]"/>
	
	<label>body:</label>
	<textarea id="code_josn" name="body">[:0.body]</textarea>

<div><label>language:</label><input type="text" name="language" value="[:0.language]"/></div>
<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
<div><label>title:</label><input type="text" name="title" value="[:0.title]"/></div>
<div><label>type:</label><input type="text" name="type" value="[:0.type]"/></div>

	<input type="button" value="save" id="save" module="SAVE">
</form>