<div style="margin-top: 5px;">
	<div style="float: left">
		<form id="edit_form" action="car_instance/put" method="post">
			<div class="error"></div>
			<input type="hidden" name="id" value="[:0.id]"/>
			<div><label>car_id:</label><input type="text" name="car_id" value="[:0.car_id]" list="car_model"/></div>
			<div><label>deleted:</label><input type="text" name="deleted" value="[:0.deleted]"/></div>
			<div><label>garage_id:</label><input type="text" name="garage_id" value="0"/></div>
			<div><label>prototype:</label><input type="text" name="prototype" value="[:0.prototype]"/></div>
			<div><label>prototype_available:</label><input type="text" name="prototype_available" value="[:0.prototype_available]"/></div>
			<div><label>prototype_name:</label><input type="text" name="prototype_name" value="[:0.prototype_name]"/></div>
			
			<input type="button" value="save" id="save" module="SAVE">
		</form>
	</div>
	<div style="float: left; width:150px; height:100px; margin:0 10px;">
		<div id="car_ready">
			<div style="margin-left:5px;"></div>
		</div>
		<div style="font-size:9px; display:none;" id="car_prototype_parameters">
			loading..
		</div>

	</div>
	<div style="float: left">
		<img src='[:eval IMAGESERVER("[\"car\",\""+0.car_id+"\",\"car\"]")]'  style="width:300px; height:200px">
	</div>
	<div style="clear:both;"></div>
	
	<div>
		Car parts: <a href="#car_instance/get?id=[:0.id]" class="button" module="CAR_PROTOTYPE_PARTS_ADD">add</a>
		<div id="car_prototype_part_list">loading..</div>
		<div style="clear:both;"></div>
	</div>
	<div style="display:none;">[:0.visual]</div>
</div>