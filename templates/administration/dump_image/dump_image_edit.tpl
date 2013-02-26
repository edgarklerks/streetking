<div class="edit-element-data-container">
	<div class="edit-element-data-box">
		<div><label>name:</label><input type="text" id="filename" name="filename" value="[:name]"/></div>
	</div>
	<div class="edit-element-image-box">
		<div class="edit-element-image-container edit-element-image-part" style='background-image:url([:eval IMAGESERVER("[\"dump\",\""+image+"\"]")])'>&nbsp;</div>
		<div class="edit-element-image-preview-box">
			<input id="fileupload" type="file" name="files" >
			<div class="clearfix"></div>
		</div>
	</div>
	<div class="clearfix"></div>
</div>
<div class="edit-element-buttons-container">
	<input type="button" value="cancel" id="cancel" module="BACK">
</div>