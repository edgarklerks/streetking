<form id="filter" action="transaction/get" method="post">
	<div class="error">&nbsp;</div>
	<div><label>id:</label><input type="text" name="id" value=""/></div>
	<div><label>account_id:</label><input type="text" name="account_id" value=""/></div>
	<div><label>type:</label><input type="text" name="type" value=""/></div>
	<input type="submit" value="Sort" id="sort" module="TRANSACTION_LIST">
</form>
<div id="list"></div>