<div class="track-element-box">
	[:when (me.level > (track_level - 1))]{
		<div class="track-element-image-container ui-corner-all">
			<img src="images/tracks/track_[:track_id].png" alt="" border="0" width="100" height="100" class="track-element-track-image  ui-corner-all" />
		</div>
		<div class="track-element-name">[:track_name]</div>
	}
	[:when (me.level < track_level)]{
		<div class="track-element-image-container-disable ui-corner-all">
			<img src="images/tracks/track_[:track_id].png" alt="" border="0" width="100" height="100" class="track-element-track-image  ui-corner-all" />
			<div class="track-element-level-disable">from<br>level<br>[:track_level]</div>
		</div>
		<div class="track-element-name-disable">[:track_name]</div>
	}
</div>