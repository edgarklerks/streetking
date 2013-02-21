<div class="form-div">
	<form id="filter" action="track_time/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>id:</label><input type="text" name="id" value=""/></div>
		<div><label>track:</label><input type="text" name="track_id" list="track" value=""/></div>
		<div><label>account_id:</label><input type="text" name="account_id" list="account" listShowField="id,nickname" value=""/></div>
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="TRACK_TIME_LIST">
			<a href="#track_time/get?id=0" class="button" module="TRACK_TIME_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>