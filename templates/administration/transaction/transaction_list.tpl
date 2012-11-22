<div class="form-div">
	<form id="filter" action="transaction/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>id:</label><input type="text" name="id" value=""/></div>
		<div><label>account_id:</label><input type="text" name="account_id" value=""/></div>
		<div><label>type:</label><input type="text" name="type" value=""/></div>
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="TRANSACTION_LIST" />
			<a href="#transaction/get?id=0" class="button" module="TRANSACTION_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>