<div class="form-div">
	<form id="filter" action="reward/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>id:</label><input type="text" name="id" value=""/></div>
		<div><label>experience:</label><input type="text" name="experience" value=""/></div>
		<div><label>money:</label><input type="text" name="money" value=""/></div>
		<div><label>name:</label><input type="text" name="name" value=""/></div>
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="REWARD_LIST">
			<a href="#reward/get?id=0" class="button" module="REWARD_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>