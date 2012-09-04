<form id="filter" action="tournament/get" method="post">
	<div class="error">&nbsp;</div>
	<div><label>id:</label><input type="text" name="id" value=""/></div>
	<div><label>name:</label><input type="text" name="name" value=""/></div>
	<input type="submit" value="Sort" id="sort" module="TOURNAMENT_LIST">
	<a href="#tournament/get?id=0" class="button" module="TOURNAMENT_EDIT">new</a>
</form>
<div id="list"></div>