<div class="list-element-container">
	<div class="list-element-image-container list-element-image-part" style='background-image:url([:eval IMAGESERVER("[\"dump\",\""+fullName+"\"]")])'>&nbsp;</div>
	<div class="list-element-data-container">
		<div><label class="list-element-data-label">name:</label><span>[:name]</span></div>
	</div>
	<div class="list-element-buttons-container">
		<div><a href="#?name=[:name]&url=[:url]&image=[:fullName]" class="button" module="DUMP_IMAGE_EDIT">edit</a></div>
		<div><a href="#?file=[:delete]" class="button delete" module="IMAGE_DELETE">delete</a></div>
	</div>
	<div class="clearfix"></div>
</div>
