<div class="form-div">
	<form id="filter" action="challenge_type/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>id:</label><input type="text" name="id" value=""/></div>
		<div><label>name:</label><input type="text" name="name" value=""/></div>
				<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="CHALLENGE_TYPE_LIST">
			<a href="#challenge_type/get?id=0" class="button" module="CHALLENGE_TYPE_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>