<form id="edit_form" action="rule/put" method="post">
	<div class="error">&nbsp;</div>
	<input type="hidden" name="id" value="[:0.id]"/>
	<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
	<div><label>once:</label><input type="text" name="once" value="[:0.once]"/></div>
	<div><label>rule:</label><input type="text" name="rule" value="[:0.rule]" style="width:400px"/></div>
	
	<input type="button" value="save" id="save" module="SAVE">
</form>