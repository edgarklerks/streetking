<div style="border:1px solid #f00;">
	<div style="float:left">
		<div>level: [:level]</div>
		<div>type: [:name]</div>
		<div>modifier: [:part_modifier]</div>
	</div>
	<div style="margin-left:10px;">
		<img src='[:eval IMAGESERVER("[\"part\",\""+part_id+"\",\"part\"]")]' style="width:45px; height:45px">
		<a href="#part_instance/put?id=[:part_instance_id]&part_id=[:part_id]" class="button" module="PART_INSTANCE_DELETE">delete</a>
	</div>
	<div style="clear:both"></div>
</div>