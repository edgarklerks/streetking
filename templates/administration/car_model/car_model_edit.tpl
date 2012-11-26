<form id="edit_form" action="car_model/put" method="post">
	<input type="hidden" name="id" value="[:0.id]"/>
	<input type="hidden" name="acceleration" value="0"/>
	<input type="hidden" name="braking" value="0"/>
	<input type="hidden" name="top_speed" value="0"/>
	<input type="hidden" name="handling" value="0"/>
	<input type="hidden" name="nos" value="0"/>
	<div class="edit-element-data-container">
		<div class="edit-element-data-box">
			<div><label>name:</label><input type="text" name="name" value="[:0.name]"/></div>
			<div><label>use_3d:</label><input type="text" name="use_3d" value="[:0.use_3d]"/></div>
			<div><label>year:</label><input type="text" name="year" value="[:0.year]"/></div>
			<div><label>level:</label><input type="text" name="level" value="[:0.level]"/></div>
			<div><label>manufacturer_id:</label><input type="text" name="manufacturer_id" value="[:0.manufacturer_id]"/></div>
			<div><label>price:</label><input type="text" name="price" value="[:0.price]"/></div>
		</div>
		<div class="edit-element-image-box">
			<div class="edit-element-image-container edit-element-image-part" style='background-image:url([:eval IMAGESERVER("[\"car\",\""+0.id+"\",\"20\"]")])'>&nbsp;</div>
			[:when (0.id > 0)]{
				<div class="edit-element-image-preview-box">
					<input id="fileupload" type="file" name="files" data-url="" />
					<div class="clearfix"></div>
				</div>
			}
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="edit-element-buttons-container">
		<input type="button" value="cancel" id="cancel" module="BACK">
		<input type="button" value="save" id="save" module="SAVE">
	</div>
</form>
