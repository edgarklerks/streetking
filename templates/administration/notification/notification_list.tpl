<form id="filter" action="notification/get" method="post">
	<div class="error">&nbsp;</div>
	<div><label>id:</label><input type="text" name="id" value=""/></div>
	<div><label>title:</label><input type="text" name="title" value=""/></div>
	<div><label>type:</label><input type="text" name="type" value=""/></div>
	<div><label>name:</label><input type="text" name="name" value=""/></div>
	<input type="submit" value="Sort" id="sort" module="NOTIFICATION_LIST">
	<a href="#notification/get?id=-1" class="button" module="NOTIFICATION_EDIT">new</a>
</form>
<div id="list"></div>