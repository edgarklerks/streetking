<div class="form-div">
	<form id="filter" action="part_instance/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>id:</label><input type="text" name="id" value=""/></div>
		<div><label>account_id:</label><input type="text" name="account_id" list="account" listShowField="id,nickname" value=""/></div>
		<div><label>garage:</label><input type="text" name="garage_id" list="account_garage" listFillField="garage_id" listShowField="garage_id,nickname" value=""/></div>
		<div><label>car_instance_id:</label><input type="text" name="car_instance_id" value=""/></div>
		<div><label>deleted:</label><input type="text" name="deleted" value=""/></div>
		<div><label>part_id:</label><input type="text" name="part_id" value=""/></div>
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="PART_INSTANCE_LIST">
			<a href="#part_instance/get?id=0" class="button" module="PART_INSTANCE_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>