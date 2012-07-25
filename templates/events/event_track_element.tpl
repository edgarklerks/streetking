<li class="track-element-container">
	<div class="track-element-box backgound-lightdarkgray [:when (me.level > (track_level - 1))]{track-element-box-click}" trdata="[:continent_name]__[:city_name]__[:track_name]__[:track_id]__[:track_level]__[:length]__[:top_time]__[:top_time_name]">
		<div class="track-element-image-container [:when (me.level < track_level)]{track-element-image-container-disabled}" style="background-image:url(images/tracks/track_[:track_id].png)">[:when (me.level > (track_level - 1))]{&nbsp;}[:when (me.level < track_level)]{<span>from<br>level<br><span>[:track_level]</span></span>}</div>
	</div>
</li>