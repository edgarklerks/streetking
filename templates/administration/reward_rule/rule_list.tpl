<div class="form-div">
	<form id="filter" action="rule/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>name:</label><input type="text" name="name" value=""/></div>
		<div><label>once:</label><input type="text" name="once" value=""/></div>
		<div><label>rule:</label><input type="text" name="rule" value=""/></div>
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="RULE_LIST">
			<a href="#rule/get?id=0" class="button" module="RULE_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>