<form id="filter" action="action/get" method="post">
	<div class="error">&nbsp;</div>
	<div><label>rule_id:</label><input type="text" name="rule_id" value="" list="rule"/></div>
	<div><label>reward_id:</label><input type="text" name="reward_id" value="" list="reward"/></div>
	<div><label>change:</label><input type="text" name="change" value=""/></div>
	<div><label>name:</label><input type="text" name="name" value=""/></div>
	<input type="submit" value="Sort" id="sort" module="PROFILE_LIST">
	<a href="#action/get?id=0" class="button" module="ACTION_EDIT">new</a>
</form>
<div id="list"></div>