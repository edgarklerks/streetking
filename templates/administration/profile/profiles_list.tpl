<div class="form-div">
	<form id="filter" action="account/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>id:</label><input type="text" name="id" value=""/></div>
		<div><label>nickname:</label><input type="text" name="nickname" value=""/></div>
		<div><label>level:</label><input type="text" name="level" value=""/></div>
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="PROFILE_LIST">
			<a href="#account/get?id=-1" class="button" module="PROFILE_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>
