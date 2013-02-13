<div class="form-div">
	<form id="filter" action="car_model/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>id:</label><input type="text" name="id" value=""/></div>
		<div><label>name:</label><input type="text" name="name" value=""/></div>
		<div><label>level:</label><input type="text" name="level" value=""/></div>
		<div><label>manufacturer_id:</label><input type="text" name="manufacturer_id" value=""/></div>
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="CAR_MODEL_LIST">
			<a href="#car_model/get?id=0" class="button" module="CAR_MODEL_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>
