<form id="filter" action="part_model/get" method="post">
	<div class="error">&nbsp;</div>
	<div><label>id:</label><input type="text" name="id" value=""/></div>
	<div><label>part_type_id:</label><input type="text" name="part_type_id" list="part_type" value=""/></div>
	<input type="submit" value="Sort" id="sort" module="PART_MODEL_LIST">
	<a href="#part_model/get?id=0" class="button" module="PART_MODEL_EDIT">new</a>
</form>
<div id="list"></div>