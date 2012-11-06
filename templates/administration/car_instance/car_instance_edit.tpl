<div style="float: left">
	<form id="edit_form" action="car_instance/put" method="post">
		<div class="error">&nbsp;</div>
	<input type="hidden" name="id" value="[:0.id]"/>
	<div><label>car_id:</label><input type="text" name="car_id" value="[:0.car_id]"/></div>
	<div><label>deleted:</label><input type="text" name="deleted" value="[:0.deleted]"/></div>
	<div><label>garage_id:</label><input type="text" name="garage_id" value="[:0.garage_id]"/></div>
		
		<input type="button" value="save" id="save" module="SAVE">
	</form>
</div>
<div style="float: left">
	<img src='[:eval IMAGESERVER("[\"user_car\",\""+0.id+"\",\"car\"]")]'  style="width:300px; height:200px">
</div>
<div style="float: left; font-size:9px;" id="car_prototype_parameters">
	car information
</div>
<div style="clear:both;"></div>
<div>
	Car part list
	<div id="car_instance_part_list">loading..</div>
	<div id="addPart"></div>
	<!--<div><a href="#car_instance/get?id=[:0.id]&garage_id=[:0.garage_id]" class="button" module="CAR_INSTANCE_PARTS_ADD">add</a></div>-->
</div>
<div>[:0.visual]</div>