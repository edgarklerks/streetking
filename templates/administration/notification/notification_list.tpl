<div class="form-div">
	<form id="filter" action="notification/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>id:</label><input type="text" name="id" value=""/></div>
		<div><label>title:</label><input type="text" name="title" value=""/></div>
		<div><label>type:</label><input type="text" name="type" value=""/></div>
		<div><label>name:</label><input type="text" name="name" value=""/></div>
		<div><label>language:</label><input type="text" name="language" value=""/></div>
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="NOTIFICATION_LIST">
			<a href="#notification/get?id=0" class="button" module="NOTIFICATION_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>