<div style="border:1px solid #f00;">
	<div style="float:left">
		<div>level: [:level]</div>
		<div>type: [:name]</div>
		<div>modifier: [:part_modifier]</div>
	</div>
	<div style="margin-left:10px;">
		<div style="float:left;">
			<img src='[:eval IMAGESERVER("[\"part\",\""+part_id+"\",\"part\"]")]' style="width:45px; height:45px">
		</div>
		<div>
			<a href="#part_instance/get?id=[:part_instance_id]" class="button" module="PART_INSTANCE_EDIT">edit part instance</a><br>
			<a href="#part_model/get?id=[:part_id]" class="button" module="PART_MODEL_EDIT">edit part model</a><br>
			<a href="#part_instance/put?id=[:part_instance_id]&part_id=[:part_id]" class="button" module="PART_INSTANCE_DELETE">delete</a>
		</div>
	</div>
	<div style="clear:both"></div>
</div>