<div class="list-element-container">
<!--
	<div class="list-element-image-container">&nbsp;</div>
	[:eval IMAGESERVER("[\"tournament\",\""+0.id+"\",\"tournament\"]")]
-->
	<div class="list-element-image-container list-element-image-part" style='background-image:url([:eval IMAGESERVER("[\"tournament\",\""+id+"\",\"tournament\"]")])'>&nbsp;</div>
	<div class="list-element-data-container">
		<div><label class="list-element-data-label">id:</label><span>[:id]</span></div>
		<div><label class="list-element-data-label">name:</label><span>[:name]</span></div>
		<div><label class="list-element-data-label">car_id:</label><span>[:car_id]</span></div>
		<div><label class="list-element-data-label">costs:</label><span>[:costs]</span></div>
		<div><label class="list-element-data-label">done:</label><span>[:done]</span></div>
		<div><label class="list-element-data-label">maxlevel:</label><span>[:maxlevel]</span></div>
		<div><label class="list-element-data-label">minlevel:</label><span>[:minlevel]</span></div>
		<div><label class="list-element-data-label">players:</label><span>[:players]</span></div>
		<div><label class="list-element-data-label">running:</label><span>[:running]</span></div>
		<div><label class="list-element-data-label">start_time:</label><span>[:start_time]</span></div>
		<div><label class="list-element-data-label">track_id:</label><span>[:track_id]</span></div>
	</div>
	<div class="list-element-buttons-container">
		<div><a href="#tournament/get?id=[:id]" class="button" module="TOURNAMENT_EDIT">edit</a></div>
	</div>
	<div class="clearfix"></div>
</div>

