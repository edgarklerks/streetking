<form id="edit_form" action="config/put" method="post">
	<div class="error">&nbsp;</div>
	
<div><label>key:</label><input type="text" name="key" value="[:0.key]"/></div>
<div>
	<label>value:</label>
<!--<input type="text" name="value" value="[:0.value]"/>-->
	<textarea id="code_lua" class="code" name="value">[:0.value]</textarea>
</div>
	
	<input type="button" value="save" id="save" module="SAVE">
</form>