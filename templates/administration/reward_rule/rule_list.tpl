<form id="filter" action="rule/get" method="post">
	<div class="error">&nbsp;</div>
	<div><label>name:</label><input type="text" name="name" value=""/></div>
	<div><label>once:</label><input type="text" name="once" value=""/></div>
	<div><label>rule:</label><input type="text" name="rule" value=""/></div>
	<input type="submit" value="Sort" id="sort" module="RULE_LIST">
	<a href="#rule/get?id=0" class="button" module="RULE_EDIT">new</a>
</form>
<div id="list"></div>