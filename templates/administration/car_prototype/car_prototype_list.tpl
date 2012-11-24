<div class="form-div">
	<form id="filter" action="car_instance/get" method="post">
		<div class="error">&nbsp;</div>
		<div><label>car_id:</label><input type="text" name="car_id" value="" list="car_model"/></div>
		<div><label>id:</label><input type="text" name="id" value=""/></div>
		<div><label>prototype_name:</label><input type="text" name="prototype_name" value=""/></div>
		<div><label>prototype_available:</label><input type="text" name="prototype_available" value=""/></div>
<!--		
		<div>
			<label>prototype_available:</label>
			[:eval OPTIONTRUEFALSE("[\"prototype_available\"]")]
		</div>
-->
		<div class="clearfix"></div>
		<div class="buttons-container">
			<input type="submit" value="Sort" id="sort" module="CAR_PROTOTYPE_LIST">
			<a href="#car_instance/get?id=0" class="button" module="CAR_PROTOTYPE_EDIT">Add new</a>
			<input type="reset" value="Clear" class="button" />
		</div>
	</form>
</div>
<div id="list" class="list-div scroll-content"></div>
