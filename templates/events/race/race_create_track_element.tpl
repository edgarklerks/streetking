<li class="declare-your-own-race-car-track-element-container">
	<div class="declare-your-own-race-car-track-element-box backgound-lightdarkgray [:when (me.level > (track_level - 1))]{declare-your-own-race-car-track-element-box-click}" trdata="[:continent_name]__[:city_name]__[:track_name]__[:track_id]__[:track_level]__[:length]__[:top_time]__[:top_time_name]">
		<div class="declare-your-own-race-car-track-element-image-container [:when (me.level < track_level)]{declare-your-own-race-car-track-element-image-container-disabled}" style="background-image:url(images/tracks/track_[:track_id].png)">[:when (me.level > (track_level - 1))]{&nbsp;}[:when (me.level < track_level)]{<span>from<br>level<br><span>[:track_level]</span></span>}</div>
	</div>
</li>
<!--
<div class="track-element-box track-element-box140">
	[:when (me.level > (track_level - 1))]{
		<div class="track-element-image-container track-element-image-containerl20 ui-corner-all select-track" track_id="[:track_id]">
			<img src="images/tracks/track_[:track_id].png" alt="" border="0" width="100" height="100" class="track-element-track-image  ui-corner-all" />
		</div>
		<div class="track-element-name">[:track_name]</div>
	}
	[:when (me.level < track_level)]{
		<div class="track-element-image-container-disable track-element-image-containerl20 ui-corner-all">
			<img src="images/tracks/track_[:track_id].png" alt="" border="0" width="100" height="100" class="track-element-track-image  ui-corner-all" />
			<div class="track-element-level-disable">from<br>level<br>[:track_level]</div>
		</div>
		<div class="track-element-name-disable">[:track_name]</div>
	}
</div>
-->