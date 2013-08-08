<div class="form-div">
	<form id="filter" action="garage/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>id:</label><input type="text" name="id" value=""/></div>
		<div><label>account_id:</label><input type="text" name="account_id" list="account" listShowField="id,nickname" value=""/></div>
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="GARAGE_LIST">
			<a href="#garage/get?id=-1" class="button" module="GARAGE_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>