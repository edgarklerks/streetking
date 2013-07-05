<div class="form-div">
	<form id="filter" action="personnel_instance/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>id:</label><input type="text" name="id" value=""/></div>
		<div><label>garage_id:</label><input type="text" name="garage_id" list="account_garage" listFillField="garage_id" listShowField="garage_id,nickname" value=""/></div>
		<div><label>personnel_id:</label><input type="text" name="personnel_id" list="personnel" value=""/></div>
		<div><label>deleted:</label><input type="text" name="deleted" value=""/></div>
		<div><label>engineering:</label><input type="text" name="skill_engineering" value=""/></div>
		<div><label>repair:</label><input type="text" name="skill_repair" value=""/></div>
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="PERSONNEL_INSTANCE_LIST">
			<a href="#personnel_instance/get?id=0" class="button" module="PERSONNEL_INSTANCE_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>
