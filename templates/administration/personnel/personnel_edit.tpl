<form id="edit_form" action="personnel/put" method="post">
	<div class="error">&nbsp;</div>
	<input type="hidden" name="id" value="[:0.id]"/>
	
<div><label>country_id:</label><input type="text" name="country_id" value="[:0.country_id]"/></div>
<div><label>gender:</label><input type="text" name="gender" value="[:0.gender]"/></div>
<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
<div><label>picture:</label><input type="text" name="picture" value="[:0.picture]"/></div>
<div><label>price:</label><input type="text" name="price" value="[:0.price]"/></div>
<div><label>salary:</label><input type="text" name="salary" value="[:0.salary]"/></div>
<div><label>skill_engineering:</label><input type="text" name="skill_engineering" value="[:0.skill_engineering]"/></div>
<div><label>skill_repair:</label><input type="text" name="skill_repair" value="[:0.skill_repair]"/></div>
<div><label>sort:</label><input type="text" name="sort" value="[:0.sort]"/></div>

	<input type="button" value="save" id="save" module="SAVE">
</form>