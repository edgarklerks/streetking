<div class="form-div">
	<form id="filter" action="tournament/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>id:</label><input type="text" name="id" value=""/></div>
		<div><label>name:</label><input type="text" name="name" value=""/></div>
		<div><label>car_id:</label><input type="text" name="car_id" value=""/></div>
		<div><label>done:</label><input type="text" name="done" value=""/></div>
		<div><label>running:</label><input type="text" name="running" value=""/></div>
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="TOURNAMENT_LIST">
			<a href="#tournament/get?id=0" class="button" module="TOURNAMENT_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>