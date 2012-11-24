<div class="form-div">
	<form id="filter" action="personnel/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>id:</label><input type="text" name="id" value=""/></div>
		<div><label>name:</label><input type="text" name="name" value=""/></div>
		<div><label>engineering:</label><input type="text" name="skill_engineering" value=""/></div>
		<div><label>repair:</label><input type="text" name="repair" value=""/></div>
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="PERSONNEL_LIST">
			<a href="#personnel/get?id=0" class="button" module="PERSONNEL_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>
