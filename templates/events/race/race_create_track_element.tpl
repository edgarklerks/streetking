<li class="declare-your-own-race-car-track-element-container">
	<div class="declare-your-own-race-car-track-element-box backgound-lightdarkgray [:when (me.level > (track_level - 1))]{declare-your-own-race-car-track-element-box-click}" track_id="[:track_id]">
		<div class="declare-your-own-race-car-track-element-image-container [:when (me.level < track_level)]{declare-your-own-race-car-track-element-image-container-disabled}" style="background-image:url(images/tracks/track_[:track_id].png)">[:when (me.level > (track_level - 1))]{&nbsp;}[:when (me.level < track_level)]{<span>from<br>level<br><span>[:track_level]</span></span>}</div>
	</div>
</li>