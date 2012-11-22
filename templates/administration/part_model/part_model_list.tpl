<div class="form-div">
	<form id="filter" action="part_model/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>id:</label><input type="text" name="id" value=""/></div>
		<div><label>part_type_id:</label><input type="text" name="part_type_id" list="part_type" value=""/></div>
		<div><label>car_id:</label><input type="text" name="car_id" list="car_model" value=""/></div>
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="PART_MODEL_LIST">
			<a href="#part_model/get?id=0" class="button" module="PART_MODEL_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>