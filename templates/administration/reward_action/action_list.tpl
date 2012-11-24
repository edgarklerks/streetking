<div class="form-div">
	<form id="filter" action="action/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>rule_id:</label><input type="text" name="rule_id" value="" list="rule"/></div>
		<div><label>reward_id:</label><input type="text" name="reward_id" value="" list="reward"/></div>
		<div><label>change:</label><input type="text" name="change" value=""/></div>
		<div><label>name:</label><input type="text" name="name" value=""/></div>
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="ACTION_LIST">
			<a href="#action/get?id=0" class="button" module="ACTION_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>