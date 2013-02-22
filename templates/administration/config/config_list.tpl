<div class="form-div">
	<form id="filter" action="config/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>key:</label><input type="text" name="key" value=""/></div>
		<div><label>value:</label><input type="text" name="value" value=""/></div>
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="CONFIG_LIST">
			<a href="#config/get?id=0" class="button" module="CONFIG_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>