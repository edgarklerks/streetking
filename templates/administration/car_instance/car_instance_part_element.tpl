<div style="padding:5px;">
	<div style="float:left; width:130px;">
		<div>level: [:level]</div>
		<div>type: [:name]</div>
		<div>modifier: [:part_modifier]</div>
	</div>
	<div style="float:left; margin: 0 5px;">
		<img src='[:eval IMAGESERVER("[\"part\",\""+part_id+"\",\"part\"]")]' style="width:45px; height:45px">
	</div>
	<div style="float:left;">
		<a href="#part_instance/get?id=[:part_instance_id]" class="button" module="PART_INSTANCE_EDIT">edit</a><br>
		<a href="#part_instance/put?id=[:part_instance_id]&part_id=[:part_id]&garage_id=[:garage_id]" class="button" module="PART_INSTANCE_REMOVE_FROM_CAR">remove from car</a><br>
		<a href="#part_instance/put?id=[:part_instance_id]&part_id=[:part_id]" class="button color-red" module="PART_INSTANCE_DELETE">delete</a>
	</div>
	<div style="clear:both"></div>
</div>