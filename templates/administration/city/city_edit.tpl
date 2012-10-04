<form id="edit_form" action="city/put" method="post">
	<div class="error">&nbsp;</div>
	<input type="hidden" name="id" value="[:0.id]"/>
	
<div><label>continent_id:</label><input type="text" name="continent_id" value="[:0.continent_id]"/></div>
<div><label>data:</label><input type="text" name="data" value="[:0.data]"/></div>
<div><label>default:</label><input type="text" name="default" value="[:0.default]"/></div>
<div><label>level:</label><input type="text" name="level" value="[:0.level]"/></div>
<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
	
	<input type="button" value="save" id="save" module="SAVE">
</form>